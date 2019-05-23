function Merge-Arrays {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)] [Array] $Array
    )

    begin {
        Write-Debug "Beginning merging array"
        $outputArray = @()
    }

    process {

        if ($Array -is [Array]) {
            Write-Debug "Is Array"
        }

        $Array.GetEnumerator() | ForEach-Object {
            $outputArray += $_
        }
    }

    end {
        Write-Debug "Ending merging array"
        return $outputArray
    }
}