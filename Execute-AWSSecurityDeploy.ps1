param (
    [Parameter(Mandatory = $true)] [String] $Environment,
    [Parameter(Mandatory = $true)] [String] $AWSAccessKey,
    [Parameter(Mandatory = $true)] [String] $AWSSecretKey,
    [Parameter(Mandatory = $true)] [String] $AWSRegion
)

Install-Module -Name AWSPowerShell -Force
Import-Module -Name AWSPowerShell

$InformationPreference = 'Continue'
$DebugPreference = 'Continue'
$VerbosePreference = 'Continue'

$ErrorActionPreference = "Stop"

Get-ChildItem -Path "$PSScriptRoot/Functions" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
    Write-Debug "Importing function file $($_.FullName)"
}

Write-Information "Executing AWS Security deployment to AWS for environment $Environment"

$environmentConfig = Import-EnvironmentConfig -Environment $Environment

Set-AWSCredential -AccessKey $AWSAccessKey -SecretKey $AWSSecretKey -StoreAs "default"
Set-DefaultAWSRegion -Region $AWSRegion

$groupName = "$($environmentConfig.ElasticBeanstalk.ApplicationName)-$Environment-AWS-RDS-DatabaseSecurityGroup"
$groupDescription = "$($environmentConfig.ElasticBeanstalk.ApplicationName)-$Environment-AWS-RDS-DatabaseSecurityGroup"

try {
    $databaseAccessGroup = Get-EC2SecurityGroup -GroupName $groupName
} 
catch {
    Write-Information "Creating Security Group named $groupName"
    New-EC2SecurityGroup -GroupName $groupName -GroupDescription $groupDescription
}