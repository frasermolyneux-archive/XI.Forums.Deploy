function Ensure-EBApplicationExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ApplicationName
    )
    
    begin {
        Write-Debug "Begin ensure ElasticBeanstalk application exists named $ApplicationName"
    }
    
    process {

        $application = Get-EBApplication -ApplicationName $ApplicationName
        if ($null -eq $application)
        {
            Write-Information "Creating EB Application $ApplicationName"
            New-EBApplication -ApplicationName $ApplicationName
        }
        else {
            Write-Information "EB Application $ApplicationName already exists"
        }

    }
    
    end {
        Write-Debug "End ensure ElasticBeanstalk application exists named $ApplicationName"
    }
}