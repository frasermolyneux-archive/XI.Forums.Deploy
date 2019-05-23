function Merge-HashTables {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)] [HashTable] $HashTable
    )

    begin {
        Write-Debug "Beginning merging hash tables"
        $outputHashTable = @{}
    }

    process {
        $HashTable.GetEnumerator() | Sort-Object $_.Key | ForEach-Object {
            $key = $_.Key

            Write-Debug "Processing key $key"
            if ($outputHashTable.ContainsKey($key)) {
                if ($outputHashTable.$key -is [HashTable]) {
                    Write-Debug "Output hashtable contains key '$key', merging hash tables"
                    $outputHashTable.$key = $outputHashTable.$key, $hashTable.$key | Merge-HashTables
                }
                elseif ($outputHashTable.$key -is [Array]) {
                    Write-Debug "Output hashtable contains key '$key', merging arrays"
                    $outputHashTable.$key = $outputHashTable.$key, $hashTable.$key | Merge-Arrays
                }
                else {
                    throw "Output hashtable contains key '$key', you cannot override variables!"
                }
            }
            else {
                Write-Debug "Output hash does not contain key '$key' - straight copy"
                $outputHashTable.$key = $hashTable.$key
            }
        }
    }

    end {
        Write-Debug "Ending merging hashtables"
        return $outputHashTable
    }
}