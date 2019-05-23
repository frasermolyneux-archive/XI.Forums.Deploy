param (
    [Parameter(Mandatory = $true)] [String] $Environment,
    [Parameter(Mandatory = $true)] [String] $Version,
    [Parameter(Mandatory = $true)] [String] $AWSAccessKey,
    [Parameter(Mandatory = $true)] [String] $AWSSecretKey,
    [Parameter(Mandatory = $true)] [String] $AWSRegion,
    [Parameter(Mandatory = $true)] [String] $WebsiteFilePath,
    [Parameter(Mandatory = $true)] [String] $WorkingDirectory
)

Import-Module -Name AWSPowerShell

$InformationPreference = 'Continue'
$DebugPreference = 'Continue'
$VerbosePreference = 'Continue'

$ErrorActionPreference = "Stop"

Get-ChildItem -Path "$PSScriptRoot/Functions" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
    Write-Debug "Importing function file $($_.FullName)"
}

Write-Information "Executing IPS Community deployment to AWS for environment $Environment"

$environmentConfig = Import-EnvironmentConfig -Environment $Environment

Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs "default"
Set-DefaultAWSRegion -Region $AWSRegion

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

New-IPSArtifactArchive `
    -WebsiteFilePath $WebsiteFilePath `
    -ArchiveName $artifactName `
    -WorkingDirectory $WorkingDirectory

Ensure-ArtifactS3BucketExists `
    -ArtifactS3BucketName $environmentConfig.ArtifactS3Bucket.BucketName

Upload-IPSArtifactArchive `
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