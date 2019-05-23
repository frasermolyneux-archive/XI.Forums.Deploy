param (
    [Parameter(Mandatory=$true)] [String] $ModuleRoot
)

. "$PSScriptRoot\Merge-HashTables.TestData.ps1"

function Assert-HashTablesAreEqual {
    param (
        $expectedHashTable,
        $resultHashTable
    )

    $expectedJson = $expectedHashTable | ConvertTo-Json -Depth 15 -Compress
    $resultJson = $resultHashTable | ConvertTo-Json -Depth 15 -Compress
    
    $resultJson | Should -BeExactly $expectedJson
}

Describe "Merge-HashTables" {
    It "should straight copy" {
        # Arrange
        $inputHashTable = $MergeHashTablesTestData.ShouldStraightCopy.InputHashTable

        # Act
        $result = $inputHashTable | Merge-HashTables

        # Assert
        $expectedResult = $MergeHashTablesTestData.ShouldStraightCopy.ExpectedResult
        Assert-HashTablesAreEqual -expectedHashTable $expectedResult -resultHashTable $result
    }

    It "should straight copy on multiple hash tables" {
        # Arrange
        $inputHashTable1 = $MergeHashTablesTestData.ShouldStraightCopyMultiple.InputHashTable1
        $inputHashTable2 = $MergeHashTablesTestData.ShouldStraightCopyMultiple.InputHashTable2

        # Act
        $result = $inputHashTable1, $inputHashTable2 | Merge-HashTables

        # Assert
        $expectedResult = $MergeHashTablesTestData.ShouldStraightCopyMultiple.ExpectedResult
        Assert-HashTablesAreEqual -expectedHashTable $expectedResult -resultHashTable $result
    }

    It "should merge hash tables with no duplicate values" {
        # Arrange
        $inputHashTable1 = $MergeHashTablesTestData.ShouldMergeNoDuplicate.InputHashTable1
        $inputHashTable2 = $MergeHashTablesTestData.ShouldMergeNoDuplicate.InputHashTable2

        # Act
        $result = $inputHashTable1, $inputHashTable2 | Merge-HashTables

        # Assert
        $expectedResult = $MergeHashTablesTestData.ShouldMergeNoDuplicate.ExpectedResult
        Assert-HashTablesAreEqual -expectedHashTable $expectedResult -resultHashTable $result
    }

    It "should merge sub hash tables" {
        # Arrange
        $inputHashTable1 = $MergeHashTablesTestData.ShouldMergeSubHashTables.InputHashTable1
        $inputHashTable2 = $MergeHashTablesTestData.ShouldMergeSubHashTables.InputHashTable2

        # Act
        $result = $inputHashTable1, $inputHashTable2 | Merge-HashTables

        # Assert
        $expectedResult = $MergeHashTablesTestData.ShouldMergeSubHashTables.ExpectedResult
        Assert-HashTablesAreEqual -expectedHashTable $expectedResult -resultHashTable $result
    }

    It "should merge sub arrays" {
        # Arrange
        $inputHashTable1 = $MergeHashTablesTestData.ShouldMergeSubArrays.InputHashTable1
        $inputHashTable2 = $MergeHashTablesTestData.ShouldMergeSubArrays.InputHashTable2

        # Act
        $result = $inputHashTable1, $inputHashTable2 | Merge-HashTables

        # Assert
        $expectedResult = $MergeHashTablesTestData.ShouldMergeSubArrays.ExpectedResult
        Assert-HashTablesAreEqual -expectedHashTable $expectedResult -resultHashTable $result
    }
}