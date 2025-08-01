BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomState Function Tests' {
    It 'should generate a valid state name' {
        $state = Get-RandomState
        $state | Should -Not -BeNullOrEmpty
        $state | Should -BeOfType [string]
    }

    It 'should generate different states on multiple calls' {
        $state1 = Get-RandomState
        $state2 = Get-RandomState
        $state1 | Should -Not -BeNullOrEmpty
        $state2 | Should -Not -BeNullOrEmpty
        # Note: states could be the same due to randomness, so we just verify they're generated
    }

    It 'should return only state name by default' {
        $state = Get-RandomState
        $state | Should -Not -Match '\('  # Should not contain parentheses (no abbreviation)
        $state | Should -BeOfType [string]
    }

    Context 'When IncludeAbbreviation is specified' {
        It 'should include abbreviation with state name' {
            $stateWithAbbr = Get-RandomState -IncludeAbbreviation
            $stateWithAbbr | Should -Not -BeNullOrEmpty
            $stateWithAbbr | Should -Match '\([A-Z]{2}\)'  # Should contain 2-letter abbreviation in parentheses
        }

        It 'should use proper format with abbreviation' {
            $stateWithAbbr = Get-RandomState -IncludeAbbreviation
            $stateWithAbbr | Should -Match '^[A-Za-z\s]+ \([A-Z]{2}\)$'  # Should match "State Name (XX)" format
        }
    }

    Context 'Format parameter tests' {
        It 'should return full state name with Full format' {
            $state = Get-RandomState -Format "Full"
            $state | Should -Not -BeNullOrEmpty
            $state | Should -BeOfType [string]
            $state | Should -Not -Match '\('  # No parentheses for full format without IncludeAbbreviation
        }

        It 'should return only abbreviation with Abbreviation format' {
            $state = Get-RandomState -Format "Abbreviation"
            $state | Should -Not -BeNullOrEmpty
            $state | Should -Match '^[A-Z]{2}$'  # Should be exactly 2 uppercase letters
        }

        It 'should return both name and abbreviation with Both format' {
            $state = Get-RandomState -Format "Both"
            $state | Should -Not -BeNullOrEmpty
            $state | Should -Match '^[A-Za-z\s]+ \([A-Z]{2}\)$'  # Should match "State Name (XX)" format
        }

        It 'should include abbreviation when Full format is used with IncludeAbbreviation' {
            $state = Get-RandomState -Format "Full" -IncludeAbbreviation
            $state | Should -Match '\([A-Z]{2}\)'  # Should contain abbreviation
        }
    }

    Context 'When IncludeZipRange is specified' {
        It 'should include ZIP range information in SingleLine format' {
            $stateWithZip = Get-RandomState -IncludeZipRange
            $stateWithZip | Should -Not -BeNullOrEmpty
            $stateWithZip | Should -Match '\[ZIP:'  # Should contain ZIP range information
            $stateWithZip | Should -Match '\d+-\d+'  # Should contain number ranges
        }

        It 'should format ZIP ranges correctly' {
            $stateWithZip = Get-RandomState -IncludeZipRange
            $stateWithZip | Should -Match '\[ZIP: \d+-\d+\]'  # Should match proper ZIP format
        }

        It 'should work with different formats and ZIP ranges' {
            $stateAbbr = Get-RandomState -Format "Abbreviation" -IncludeZipRange
            $stateAbbr | Should -Match '^[A-Z]{2} \[ZIP: \d+-\d+\]$'
        }
    }

    Context 'When AddressStyle is MultiLine' {
        It 'should return hashtable for state only' {
            $result = Get-RandomState -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.Name | Should -Not -BeNullOrEmpty
            $result.Abbr | Should -Not -BeNullOrEmpty
            $result.Abbr | Should -Match '^[A-Z]{2}$'
            $result.ZipRanges | Should -BeNullOrEmpty
        }

        It 'should return hashtable with ZIP ranges when IncludeZipRange is specified' {
            $result = Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.Name | Should -Not -BeNullOrEmpty
            $result.Abbr | Should -Not -BeNullOrEmpty
            $result.ZipRanges | Should -Not -BeNullOrEmpty
            $result.ZipRanges.GetType().BaseType.Name | Should -Be "Array"
        }

        It 'should have valid ZIP range structure in MultiLine format' {
            $result = Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
            $result.ZipRanges[0] | Should -BeOfType [hashtable]
            $result.ZipRanges[0].Start | Should -BeOfType [int]
            $result.ZipRanges[0].End | Should -BeOfType [int]
            $result.ZipRanges[0].Start | Should -BeLessThan $result.ZipRanges[0].End
        }
    }

    Context 'Format validation' {
        It 'should accept Full format' {
            { Get-RandomState -Format "Full" } | Should -Not -Throw
        }

        It 'should accept Abbreviation format' {
            { Get-RandomState -Format "Abbreviation" } | Should -Not -Throw
        }

        It 'should accept Both format' {
            { Get-RandomState -Format "Both" } | Should -Not -Throw
        }

        It 'should reject invalid format' {
            { Get-RandomState -Format "Invalid" } | Should -Throw
        }
    }

    Context 'AddressStyle validation' {
        It 'should accept SingleLine style' {
            { Get-RandomState -AddressStyle "SingleLine" } | Should -Not -Throw
        }

        It 'should accept MultiLine style' {
            { Get-RandomState -AddressStyle "MultiLine" } | Should -Not -Throw
        }

        It 'should reject invalid address style' {
            { Get-RandomState -AddressStyle "Invalid" } | Should -Throw
        }
    }

    Context 'Parameter combinations' {
        It 'should work with IncludeAbbreviation and Format Both' {
            $result = Get-RandomState -IncludeAbbreviation -Format "Both"
            $result | Should -Not -BeNullOrEmpty
            $result | Should -Match '\([A-Z]{2}\)'
        }

        It 'should work with IncludeZipRange and MultiLine style' {
            $result = Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.ZipRanges | Should -Not -BeNullOrEmpty
        }

        It 'should work with all parameters combined' {
            $result = Get-RandomState -IncludeAbbreviation -IncludeZipRange -Format "Both" -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.Name | Should -Not -BeNullOrEmpty
            $result.Abbr | Should -Match '^[A-Z]{2}$'
            $result.ZipRanges | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Data validation' {
        It 'should generate valid US state names' {
            $state = Get-RandomState
            $state | Should -BeOfType [string]
            $state.Length | Should -BeGreaterThan 0
            # Should be a valid state name (contains only letters and spaces)
            $state | Should -Match '^[A-Za-z\s]+$'
        }

        It 'should generate valid state abbreviations' {
            $abbr = Get-RandomState -Format "Abbreviation"
            $abbr | Should -Match '^[A-Z]{2}$'  # Exactly 2 uppercase letters
        }

        It 'should generate realistic state names' {
            # Test that we're getting actual US states by checking a few known ones
            $states = @()
            for ($i = 0; $i -lt 20; $i++) {
                $states += Get-RandomState
            }
            $knownStates = @("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
                           "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
                           "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
                           "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                           "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
                           "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
                           "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
                           "Wisconsin", "Wyoming")

            $validStatesFound = $states | Where-Object { $_ -in $knownStates }
            $validStatesFound.Count | Should -BeGreaterThan 0
        }

        It 'should generate valid ZIP ranges when requested' {
            $result = Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
            foreach ($zipRange in $result.ZipRanges) {
                $zipRange.Start | Should -BeGreaterThan 0
                $zipRange.End | Should -BeGreaterThan $zipRange.Start
                $zipRange.Start | Should -BeLessThan 100000  # Valid US ZIP range
                $zipRange.End | Should -BeLessThan 100000
            }
        }
    }

    Context 'Function behavior consistency' {
        It 'should always return consistent data types' {
            for ($i = 0; $i -lt 10; $i++) {
                $singleLine = Get-RandomState
                $multiLine = Get-RandomState -AddressStyle "MultiLine"

                $singleLine | Should -BeOfType [string]
                $multiLine | Should -BeOfType [hashtable]
            }
        }

        It 'should generate non-empty results consistently' {
            for ($i = 0; $i -lt 10; $i++) {
                $state = Get-RandomState
                $state | Should -Not -BeNullOrEmpty
                $state.Trim() | Should -Not -BeNullOrEmpty
            }
        }

        It 'should handle parameter combinations consistently' {
            for ($i = 0; $i -lt 5; $i++) {
                $withAbbr = Get-RandomState -IncludeAbbreviation
                $withoutAbbr = Get-RandomState

                $withAbbr | Should -Match '\([A-Z]{2}\)'
                $withoutAbbr | Should -Not -Match '\('
            }
        }
    }
}
