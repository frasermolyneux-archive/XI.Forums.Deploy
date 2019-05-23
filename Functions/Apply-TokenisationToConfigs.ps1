function Apply-TokenisationToConfigs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $WebsiteFilePath,
        [Parameter(Mandatory = $true)] [Hashtable] $SecretAppSettings,
        [Parameter(Mandatory = $true)] [Hashtable] $AppSettings,
        [Parameter(Mandatory = $true)] [Array] $FilesToTokenise
    )
    
    begin {
        Write-Debug "Begin applying tokenisation to configs in $WebsiteFilePath"
    }
    
    process {

        $SECSecretId = $SecretAppSettings.SECSecretId

        Write-Information "Retrieving secrets from AWS Secret Manager $SECSecretId"

        $secretManager = Get-SECSecretValue -SecretId $SECSecretId
        $secrets = $secretManager.SecretString | ConvertFrom-Json

        $FilesToTokenise | ForEach-Object {

            $fileToTokenise = "$WebsiteFilePath\$_"
            Write-Information "Tokenising file $fileToTokenise"

            [string]$content = (Get-Content $fileToTokenise -Raw)

            $SecretAppSettings.SecretKeys | ForEach-Object {
                $theKey = $_

                Write-Information "Replacing secret key $theKey with value from AWS Secret manager"

                $token = "__{0}__" -f $theKey
                $content = $content.Replace($token, $secrets.$theKey)
            }

            $AppSettings.Keys | ForEach-Object {
                $theKey = $_

                Write-Information "Replacing appsetting key $theKey with value from config"

                $token = "__{0}__" -f $theKey
                $content = $content.Replace($token, $AppSettings[$theKey])
            }

            $content | Out-File -FilePath $fileToTokenise -Encoding utf8
        }
        
    }
    
    end {
        Write-Debug "End applying tokenisation to configs in $WebsiteFilePath"
    }
}