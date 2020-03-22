param (
    [Parameter(Mandatory=$true)] [String] $ModuleRoot
)

Describe "Environments Tests" {
    Context "Environments Structure" {
        It "has a Environment.Base.psd1 file under Environments" {
            "$ModuleRoot\Environments\Environment.Base.psd1" | Should Exist
        }

        It "has no ps1 files in the environments directory" {
            (Get-ChildItem "$ModuleRoot\Environments" -Filter "*.ps1").Count | Should Be 0
        }
    }

    Get-ChildItem -Path "$ModuleRoot\Environments" -Filter "*.psd1" | ForEach-Object {
        
        $file = $_

        Context "$($file.Name)" {

            It "$($file.Name) is valid Powershell code" {
                $psFile = Get-Content -Path "$($file.FullName)" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                if ($errors.Count -gt 0) {
                    Write-Host $errors.Message
                }
                $errors.Count | Should Be 0
            }

        }

    }
}