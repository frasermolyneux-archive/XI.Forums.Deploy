function Apply-LatestConfigurationToEnvironment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ApplicationName,
        [Parameter(Mandatory = $true)] [String] $EnvironmentName,
        [Parameter(Mandatory = $true)] [String] $SolutionStackName,
        [Parameter(Mandatory = $true)] [String] $TierType,
        [Parameter(Mandatory = $true)] [String] $TierName,
        [Parameter(Mandatory = $true)] [Array] $OptionSettings,
        [Parameter(Mandatory = $true)] [String] $VersionLabel
    )
    
    begin {
        Write-Debug "Begin applying latest configuration to $EnvironmentName under $ApplicationName"
    }
    
    process {

        $parameters = @{
            ApplicationName   = $ApplicationName
            EnvironmentName   = $EnvironmentName
            SolutionStackName = $SolutionStackName
            Tier_Type         = $TierType
            Tier_Name         = $TierName
            OptionSettings    = $OptionSettings
            VersionLabel      = $VersionLabel
        }

        $environment = Get-EBEnvironment -ApplicationName $ApplicationName -EnvironmentName $EnvironmentName
        if ($null -eq $environment) {
            Write-Error "Environment $EnvironmentName under $ApplicationName does not exist"
        }
        else {
            $parameters.EnvironmentId = $environment.EnvironmentId

            Write-Information "Applying latest configuration for environment $EnvironmentName under $ApplicationName"
            Update-EBEnvironment @parameters
            Write-Information "Finished applying latest configuration for environment $EnvironmentName under $ApplicationName"
        }

    }
    
    end {
        Write-Debug "End applying latest configuration to $EnvironmentName under $ApplicationName"
    }
}