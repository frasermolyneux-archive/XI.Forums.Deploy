function Upload-ArtifactArchiveToS3 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ArtifactS3BucketName,
        [Parameter(Mandatory = $true)] [String] $ArchiveName,
        [Parameter(Mandatory = $true)] [String] $WorkingDirectory
    )
    
    begin {
        Write-Debug "Begin uploading Artifact $ArchiveName to $ArtifactS3BucketName"
    }
    
    process {

        $artifact = Get-S3Object -BucketName $ArtifactS3BucketName -Key "$ArchiveName.zip"
        if ($null -eq $artifact)
        {
            Write-Information "Uploading $ArchiveName to $ArtifactS3BucketName"
            Write-S3Object -BucketName $ArtifactS3BucketName -File "$WorkingDirectory\$ArchiveName.zip" -Key "$ArchiveName.zip"
            Write-Information "Finished uploading $ArchiveName to $ArtifactS3BucketName"
        }
        else {
            Write-Information "Artifact $ArchiveName.zip already exists in $ArtifactS3BucketName"
        }

    }
    
    end {
        Write-Debug "End uploading Artifact $ArchiveName to $ArtifactS3BucketName"
    }
}