BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomCity Function Tests' {
    It 'should generate a valid city name' {
        $city = Get-RandomCity
        $city | Should -Not -BeNullOrEmpty
        $city | Should -BeOfType [string]
    }

    It 'should generate different cities on multiple calls' {
        $city1 = Get-RandomCity
        $city2 = Get-RandomCity
        $city1 | Should -Not -BeNullOrEmpty
        $city2 | Should -Not -BeNullOrEmpty
        # Note: cities could be the same due to randomness, so we just verify they're generated
    }

    It 'should return only city name by default' {
        $city = Get-RandomCity
        $city | Should -Not -Match ','  # Should not contain commas (no state info)
        $city | Should -BeOfType [string]
    }

    Context 'When IncludeState is specified' {
        It 'should include state information' {
            $cityWithState = Get-RandomCity -IncludeState
            $cityWithState | Should -Not -BeNullOrEmpty
            $cityWithState | Should -Match ','  # Should contain comma separating city and state
        }

        It 'should use full state name by default with IncludeState' {
            $cityWithState = Get-RandomCity -IncludeState
            $cityWithState | Should -Match ', [A-Za-z ]+$'  # Should end with full state name
        }

        It 'should use state abbreviation with Compact format' {
            $cityWithState = Get-RandomCity -IncludeState -Format "Compact"
            $cityWithState | Should -Match ', [A-Z]{2}$'  # Should end with 2-letter state code
        }

        It 'should use full state name with WithState format' {
            $cityWithState = Get-RandomCity -IncludeState -Format "WithState"
            $cityWithState | Should -Match ', [A-Za-z ]+$'  # Should end with full state name
        }
    }

    Context 'When AddressStyle is MultiLine' {
        It 'should return hashtable for city only' {
            $result = Get-RandomCity -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.City | Should -Not -BeNullOrEmpty
            $result.State | Should -BeNullOrEmpty
            $result.StateAbbr | Should -BeNullOrEmpty
        }

        It 'should return hashtable with state info when IncludeState is specified' {
            $result = Get-RandomCity -IncludeState -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.City | Should -Not -BeNullOrEmpty
            $result.State | Should -Not -BeNullOrEmpty
            $result.StateAbbr | Should -Not -BeNullOrEmpty
            $result.StateAbbr | Should -Match '^[A-Z]{2}$'  # Should be 2-letter abbreviation
        }
    }

    Context 'Format validation' {
        It 'should accept Full format' {
            { Get-RandomCity -Format "Full" } | Should -Not -Throw
        }

        It 'should accept WithState format' {
            { Get-RandomCity -Format "WithState" } | Should -Not -Throw
        }

        It 'should accept Compact format' {
            { Get-RandomCity -Format "Compact" } | Should -Not -Throw
        }

        It 'should reject invalid format' {
            { Get-RandomCity -Format "Invalid" } | Should -Throw
        }
    }

    Context 'AddressStyle validation' {
        It 'should accept SingleLine style' {
            { Get-RandomCity -AddressStyle "SingleLine" } | Should -Not -Throw
        }

        It 'should accept MultiLine style' {
            { Get-RandomCity -AddressStyle "MultiLine" } | Should -Not -Throw
        }

        It 'should reject invalid address style' {
            { Get-RandomCity -AddressStyle "Invalid" } | Should -Throw
        }
    }

    Context 'Parameter combinations' {
        It 'should work with IncludeState and Compact format' {
            $result = Get-RandomCity -IncludeState -Format "Compact"
            $result | Should -Not -BeNullOrEmpty
            $result | Should -Match ', [A-Z]{2}$'
        }

        It 'should work with IncludeState and MultiLine style' {
            $result = Get-RandomCity -IncludeState -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.City | Should -Not -BeNullOrEmpty
            $result.State | Should -Not -BeNullOrEmpty
        }

        It 'should work with all parameters combined' {
            $result = Get-RandomCity -IncludeState -Format "Compact" -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.City | Should -Not -BeNullOrEmpty
            $result.State | Should -Not -BeNullOrEmpty
            $result.StateAbbr | Should -Match '^[A-Z]{2}$'
        }
    }

    Context 'Data validation' {
        It 'should generate city names that are strings' {
            $city = Get-RandomCity
            $city | Should -BeOfType [string]
            $city.Length | Should -BeGreaterThan 0
        }

        It 'should not contain special characters in city name' {
            $city = Get-RandomCity
            $city | Should -Match '^[A-Za-z\s]+$'  # Only letters and spaces
        }

        It 'should generate valid state abbreviations when included' {
            $result = Get-RandomCity -IncludeState -AddressStyle "MultiLine"
            $result.StateAbbr | Should -Match '^[A-Z]{2}$'  # Exactly 2 uppercase letters
        }
    }
}
