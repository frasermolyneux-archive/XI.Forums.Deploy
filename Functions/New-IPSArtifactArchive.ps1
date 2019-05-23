function New-IPSArtifactArchive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $WebsiteFilePath,
        [Parameter(Mandatory = $true)] [String] $ArchiveName,
        [Parameter(Mandatory = $true)] [String] $WorkingDirectory
    )
    
    begin {
        Write-Debug "Begin creating IPS artifact archive for $WebsiteFilePath"
    }
    
    process {

        if ((Test-Path -Path "$WorkingDirectory\$ArchiveName.zip") -eq $true) {
            Remove-Item -Path "$WorkingDirectory\$ArchiveName.zip" -Force
        }

        Get-ChildItem -Path $WebsiteFilePath
        New-Item -Path "$WebsiteFilePath\.ebextensions" -ItemType Directory -Force
        Copy-Item -Path "$PSScriptRoot\..\EBExtensions\*" -Destination "$WebsiteFilePath\.ebextensions" -Force

        $customEncoder = '
        using System.Text;
        public class CustomEncoder : UTF8Encoding
        {
            public override byte[] GetBytes(string s)
            {
                s = s.Replace("\\", "/");
                return base.GetBytes(s);
           }
        }'
        
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        Add-Type -TypeDefinition $customEncoder -Language CSharp

        $encoding = [CustomEncoder]::new()
        [System.IO.Compression.ZipFile]::CreateFromDirectory("$WebsiteFilePath", "$WorkingDirectory\$ArchiveName.zip", 'Optimal', $false, $encoding)
        
    }
    
    end {
        Write-Debug "End creating IPS artifact archive for $WebsiteFilePath"
    }
}