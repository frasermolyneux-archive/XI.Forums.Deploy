function Import-EnvironmentConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $Environment
    )
    
    begin {
        Write-Debug "Begin importing environment config for environment $Environment"

        [HashTable] $configurationData = @{}
        [System.Collections.ArrayList]$configs = @()
    }
    
    process {

        if ((Test-Path -Path "$PSScriptRoot\..\Environments\Environment.$Environment.psd1") -eq $false) {
            Write-Error "The environment file for $Environment does not exist"
        }

        $configs.Add("$PSScriptRoot\..\Environments\Environment.Base.psd1") | Out-Null
        $configs.Add("$PSScriptRoot\..\Environments\Environment.$Environment.psd1") | Out-Null

        [System.Collections.ArrayList]$configFileData = @()

        $configs | ForEach-Object {
            $configData = (Import-PowerShellDataFile -Path $_)
            $configFileData.Add($configData) | Out-Null
        }
    
        $configurationData = $configFileData | Merge-HashTables
    }
    
    end {
        Write-Debug "End importing environment config for environment $Environment"
        return $configurationData
    }
}