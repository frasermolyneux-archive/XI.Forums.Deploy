function Ensure-ArtifactS3BucketExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $ArtifactS3BucketName
    )
    
    begin {
        Write-Debug "Begin ensure Artifact S3 Bucket exists named $ArtifactS3BucketName"
    }
    
    process {

        $s3Bucket = Get-S3Bucket -BucketName $ArtifactS3BucketName
        if ($null -eq $s3Bucket)
        {
            Write-Information "Creating S3 Bucket $ArtifactS3BucketName"
            New-S3Bucket -BucketName $ArtifactS3BucketName
        }
        else {
            Write-Information "S3 Bucket $ArtifactS3BucketName already exists"
        }

    }
    
    end {
        Write-Debug "End ensure Artifact S3 Bucket exists named $ArtifactS3BucketName"
    }
}