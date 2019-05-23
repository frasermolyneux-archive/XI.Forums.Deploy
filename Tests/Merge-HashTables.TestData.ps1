$MergeHashTablesTestData = @{
    ShouldStraightCopy         = @{
        InputHashTable = @{
            Value1 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value2 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
        }
        ExpectedResult = @{
            Value1 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value2 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
        }
    }

    ShouldStraightCopyMultiple = @{
        InputHashTable1 = @{
            Value1 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value2 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
        }
        InputHashTable2 = @{
            Value3 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value4 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
        }
        ExpectedResult  = @{
            Value1 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value2 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
            Value3 = @{
                SubValue1 = $true
                SubValue2 = "Test"
            }
            Value4 = @{
                SubValue1 = $false
                SubValue2 = "Test2"
            }
        }
    }

    ShouldMergeNoDuplicate     = @{
        InputHashTable1 = @{
            Value1 = @{
                SubValue1 = $true
            }
        }
        InputHashTable2 = @{
            Value1 = @{
                SubValue2 = $false
            }
        }
        ExpectedResult  = @{
            Value1 = @{
                SubValue1 = $true
                SubValue2 = $false
            }
        }
    }

    ShouldMergeSubHashTables   = @{
        InputHashTable1 = @{
            Value1 = @{
                SubValue1 = @{
                    Value1    = "Hello"
                    OnlyInOne = $false
                }
                UniqueTo1 = @{
                    OnlyInOne = $true
                }
            }
        }
        InputHashTable2 = @{
            Value1 = @{
                SubValue1 = @{
                    Value2    = "Hello"
                    OnlyInTwo = $false
                }
                UniqueTo2 = @{
                    OnlyInTwo = $true
                }
            }
        }
        ExpectedResult  = @{
            Value1 = @{
                SubValue1 = @{
                    Value1    = "Hello"
                    Value2    = "Hello"
                    OnlyInOne = $false
                    OnlyInTwo = $false
                }
                UniqueTo1 = @{
                    OnlyInOne = $true
                }
                UniqueTo2 = @{
                    OnlyInTwo = $true
                }
            }
        }
    }

    ShouldMergeSubArrays       = @{
        InputHashTable1 = @{
            Arr = @(
                @{
                    Value = 1
                }
            )
        }
        InputHashTable2 = @{
            Arr = @(
                @{
                    Value = 2
                },
                @{
                    Value = 3
                }
            )
        }
        ExpectedResult  = @{
            Arr = @(
                @{
                    Value = 1
                },
                @{
                    Value = 2
                },
                @{
                    Value = 3
                }
            )
        }
    }
}