function Ensure-ArtifactApplicationVersionExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ApplicationName,
        [Parameter(Mandatory = $true)] [String] $ArchiveName,
        [Parameter(Mandatory = $true)] [String] $ArtifactS3BucketName
    )
    
    begin {
        Write-Debug "Begin ensure application version exists named $ArchiveName for $ApplicationName"
    }
    
    process {

        $applicationVersion = Get-EBApplicationVersion -VersionLabel $ArchiveName
        if ($null -eq $applicationVersion) {
            Write-Information "Creating Application Version $ArchiveName for application $ApplicationName"

            $params = @{
                ApplicationName       = $ApplicationName
                VersionLabel          = $ArchiveName
                SourceBundle_S3Bucket = $ArtifactS3BucketName
                SourceBundle_S3Key    = "$ArchiveName.zip"
            }
            New-EBApplicationVersion @params
        }
        else {
            Write-Information "Application Version $ArchiveName already exists for application $ApplicationName"
        }

    }
    
    end {
        Write-Debug "End ensure application version exists named $ArchiveName for $ApplicationName"
    }
}