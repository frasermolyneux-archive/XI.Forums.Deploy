function Ensure-EBEnvironmentExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ApplicationName,
        [Parameter(Mandatory = $true)] [String] $EnvironmentName,
        [Parameter(Mandatory = $true)] [String] $SolutionStackName,
        [Parameter(Mandatory = $true)] [String] $TierType,
        [Parameter(Mandatory = $true)] [String] $TierName,
        [Parameter(Mandatory = $true)] [Array] $OptionSettings
    )
    
    begin {
        Write-Debug "Begin ensure ElasticBeanstalk environment exists named $EnvironmentName under $ApplicationName"
    }
    
    process {

        $parameters = @{
            ApplicationName   = $ApplicationName
            EnvironmentName   = $EnvironmentName
            SolutionStackName = $SolutionStackName
            Tier_Type         = $TierType
            Tier_Name         = $TierName
            OptionSettings    = $OptionSettings
        }

        $environment = Get-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $EnvironmentName
        if ($null -eq $environment) {
            Write-Information "Creating EB Environment $EnvironmentName"
            New-EBEnvironment @parameters
        }
        else {
            Write-Information "Environment $EnvironmentName under $ApplicationName already exists"
        }

    }
    
    end {
        Write-Debug "End ensure ElasticBeanstalk environment exists named $EnvironmentName under $ApplicationName"
    }
}