param (
    [Parameter(Mandatory = $true)] [String] $DeployScriptsPath,
    [Parameter(Mandatory = $true)] [String] $Environment,
    [Parameter(Mandatory = $true)] [String] $Version,
    [Parameter(Mandatory = $true)] [String] $AWSAccessKey,
    [Parameter(Mandatory = $true)] [String] $AWSSecretKey,
    [Parameter(Mandatory = $true)] [String] $AWSRegion,
    [Parameter(Mandatory = $true)] [String] $WebsiteFilePath,
    [Parameter(Mandatory = $true)] [String] $WorkingDirectory
)

Install-Module -Name AWSPowerShell -Force
Import-Module -Name AWSPowerShell

$InformationPreference = 'Continue'
$DebugPreference = 'Continue'
$VerbosePreference = 'Continue'
$ErrorActionPreference = "Stop"

. "$DeployScriptsPath\Import-DeployScripts.ps1"

Write-Information "Executing IPS Community deployment to AWS for environment $Environment"

$environmentConfig = Import-EnvironmentConfig -Environment $Environment -ConfigDir "$PSScriptRoot\Environments"

Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs "default"
Set-DefaultAWSRegion -Region $AWSRegion

Ensure-AwsRdsSecurityGroupExists `
    -Environment $environmentConfig.ElasticBeanstalk.EnvironmentName

Ensure-EBApplicationExists `
    -ApplicationName $environmentConfig.ElasticBeanstalk.ApplicationName

Ensure-EBEnvironmentExists `
    -ApplicationName $environmentConfig.ElasticBeanstalk.ApplicationName `
    -Environment $environmentConfig.ElasticBeanstalk.EnvironmentName `
    -SolutionStackName $environmentConfig.ElasticBeanstalk.SolutionStackName `
    -TierType $environmentConfig.ElasticBeanstalk.TierType `
    -TierName $environmentConfig.ElasticBeanstalk.TierName `
    -OptionSettings $environmentConfig.ElasticBeanstalk.OptionSettings

$artifactName = "$($environmentConfig.ElasticBeanstalk.EnvironmentName)-$Version"

Apply-TokenisationToConfigs `
    -WebsiteFilePath $WebsiteFilePath `
    -SecretAppSettings $environmentConfig.SecretAppSettings `
    -AppSettings $environmentConfig.AppSettings `
    -FilesToTokenise $environmentConfig.FilesToTokenise

Get-ChildItem -Path $WebsiteFilePath
New-Item -Path "$WebsiteFilePath\.ebextensions" -ItemType Directory -Force
Copy-Item -Path "$PSScriptRoot\EBExtensions\*" -Destination "$WebsiteFilePath\.ebextensions" -Force

New-ZipArtifactArchive `
    -WebsiteFilePath $WebsiteFilePath `
    -ArchiveName $artifactName `
    -WorkingDirectory $WorkingDirectory

Ensure-ArtifactS3BucketExists `
    -ArtifactS3BucketName $environmentConfig.ArtifactS3Bucket.BucketName

Upload-ArtifactArchiveToS3 `
    -ArtifactS3BucketName $environmentConfig.ArtifactS3Bucket.BucketName `
    -ArchiveName $artifactName `
    -WorkingDirectory $WorkingDirectory

Ensure-ArtifactApplicationVersionExists `
    -ApplicationName $environmentConfig.ElasticBeanstalk.ApplicationName `
    -ArchiveName $artifactName `
    -ArtifactS3BucketName $environmentConfig.ArtifactS3Bucket.BucketName

Apply-LatestConfigurationToEnvironment `
    -ApplicationName $environmentConfig.ElasticBeanstalk.ApplicationName `
    -Environment $environmentConfig.ElasticBeanstalk.EnvironmentName `
    -SolutionStackName $environmentConfig.ElasticBeanstalk.SolutionStackName `
    -TierType $environmentConfig.ElasticBeanstalk.TierType `
    -TierName $environmentConfig.ElasticBeanstalk.TierName `
    -OptionSettings $environmentConfig.ElasticBeanstalk.OptionSettings `
    -VersionLabel $artifactName