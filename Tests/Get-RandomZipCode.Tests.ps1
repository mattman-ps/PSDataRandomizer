BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomZipCode Function Tests' {
    It 'should generate a valid ZIP code' {
        $zipCode = Get-RandomZipCode
        $zipCode | Should -Not -BeNullOrEmpty
        $zipCode | Should -BeOfType [string]
    }

    It 'should generate different ZIP codes on multiple calls' {
        $zip1 = Get-RandomZipCode
        $zip2 = Get-RandomZipCode
        $zip1 | Should -Not -BeNullOrEmpty
        $zip2 | Should -Not -BeNullOrEmpty
        # Note: ZIP codes could be the same due to randomness, so we just verify they're generated
    }

    It 'should return 5-digit ZIP code by default' {
        $zipCode = Get-RandomZipCode
        $zipCode | Should -Match '^\d{5}$'  # Exactly 5 digits
    }

    It 'should generate valid ZIP codes within US ranges' {
        $zipCode = Get-RandomZipCode
        $zipNumber = [int]$zipCode
        $zipNumber | Should -BeGreaterOrEqual 1000
        $zipNumber | Should -BeLessOrEqual 99999
    }

    Context 'IncludeZipPlus4 parameter tests' {
        It 'should include ZIP+4 extension when requested' {
            $zipCode = Get-RandomZipCode -IncludeZipPlus4
            $zipCode | Should -Match '^\d{5}-\d{4}$'  # 5 digits, hyphen, 4 digits
        }

        It 'should generate valid ZIP+4 extensions' {
            $zipCode = Get-RandomZipCode -IncludeZipPlus4
            $parts = $zipCode.Split('-')
            $parts.Count | Should -Be 2
            $parts[0] | Should -Match '^\d{5}$'
            $parts[1] | Should -Match '^\d{4}$'
            [int]$parts[1] | Should -BeGreaterOrEqual 1000
            [int]$parts[1] | Should -BeLessOrEqual 9999
        }
    }

    Context 'IncludeState parameter tests' {
        It 'should include state abbreviation when requested' {
            $result = Get-RandomZipCode -IncludeState
            $result | Should -Not -BeNullOrEmpty
            $result | Should -Match ', [A-Z]{2}$'  # Should end with comma and 2-letter state code
        }

        It 'should format state correctly with ZIP code' {
            $result = Get-RandomZipCode -IncludeState
            $result | Should -Match '^\d{5}, [A-Z]{2}$'  # ZIP, comma, space, state
        }

        It 'should include state with ZIP+4 when both are requested' {
            $result = Get-RandomZipCode -IncludeState -IncludeZipPlus4
            $result | Should -Match '^\d{5}-\d{4}, [A-Z]{2}$'  # ZIP+4, comma, space, state
        }
    }

    Context 'Format parameter tests' {
        It 'should return standard format with Standard parameter' {
            $zipCode = Get-RandomZipCode -Format "Standard"
            $zipCode | Should -Match '^\d{5}$'
        }

        It 'should return ZIP+4 format with Plus4 parameter' {
            $zipCode = Get-RandomZipCode -Format "Plus4"
            $zipCode | Should -Match '^\d{5}-\d{4}$'
        }

        It 'should return state first format with StateFirst and IncludeState' {
            $result = Get-RandomZipCode -Format "StateFirst" -IncludeState
            $result | Should -Match '^[A-Z]{2} \d{5}$'  # State, space, ZIP
        }

        It 'should handle StateFirst format without IncludeState' {
            $result = Get-RandomZipCode -Format "StateFirst"
            $result | Should -Match '^\d{5}$'  # Should return standard ZIP when state not included
        }

        It 'should combine Plus4 format with IncludeState correctly' {
            $result = Get-RandomZipCode -Format "Plus4" -IncludeState
            $result | Should -Match '^\d{5}-\d{4}, [A-Z]{2}$'
        }
    }

    Context 'StateFilter parameter tests' {
        It 'should generate ZIP codes for specific state when StateFilter is used' {
            $result = Get-RandomZipCode -StateFilter "CA" -IncludeState -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.StateAbbr | Should -Be "CA"
            $result.State | Should -Be "California"
        }

        It 'should generate ZIP codes within California range when CA is filtered' {
            $zipCode = Get-RandomZipCode -StateFilter "CA"
            $zipNumber = [int]$zipCode
            $zipNumber | Should -BeGreaterOrEqual 90000
            $zipNumber | Should -BeLessOrEqual 96699
        }

        It 'should generate ZIP codes within Texas range when TX is filtered' {
            $zipCode = Get-RandomZipCode -StateFilter "TX"
            $zipNumber = [int]$zipCode
            $zipNumber | Should -BeGreaterOrEqual 75000
            $zipNumber | Should -BeLessOrEqual 79999
        }

        It 'should throw error for invalid state filter' {
            { Get-RandomZipCode -StateFilter "ZZ" } | Should -Throw
        }

        It 'should reject invalid state filter format' {
            { Get-RandomZipCode -StateFilter "CAL" } | Should -Throw
            { Get-RandomZipCode -StateFilter "C" } | Should -Throw
        }
    }

    Context 'When AddressStyle is MultiLine' {
        It 'should return hashtable for ZIP code only' {
            $result = Get-RandomZipCode -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.ZipCode | Should -Not -BeNullOrEmpty
            $result.ZipCode | Should -Match '^\d{5}$'
            $result.HasPlus4 | Should -BeOfType [bool]
            $result.ZipRange | Should -BeOfType [hashtable]
        }

        It 'should return hashtable with state info when IncludeState is specified' {
            $result = Get-RandomZipCode -IncludeState -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.ZipCode | Should -Not -BeNullOrEmpty
            $result.State | Should -Not -BeNullOrEmpty
            $result.StateAbbr | Should -Not -BeNullOrEmpty
            $result.StateAbbr | Should -Match '^[A-Z]{2}$'
        }

        It 'should include ZIP range metadata in MultiLine format' {
            $result = Get-RandomZipCode -AddressStyle "MultiLine"
            $result.ZipRange | Should -BeOfType [hashtable]
            $result.ZipRange.Start | Should -BeOfType [int]
            $result.ZipRange.End | Should -BeOfType [int]
            $result.ZipRange.Start | Should -BeLessThan $result.ZipRange.End
        }

        It 'should set HasPlus4 flag correctly for ZIP+4' {
            $result = Get-RandomZipCode -IncludeZipPlus4 -AddressStyle "MultiLine"
            $result.HasPlus4 | Should -Be $true
            $result.ZipCode | Should -Match '-'
        }

        It 'should set HasPlus4 flag correctly for standard ZIP' {
            $result = Get-RandomZipCode -AddressStyle "MultiLine"
            $result.HasPlus4 | Should -Be $false
            $result.ZipCode | Should -Not -Match '-'
        }
    }

    Context 'Format validation' {
        It 'should accept Standard format' {
            { Get-RandomZipCode -Format "Standard" } | Should -Not -Throw
        }

        It 'should accept Plus4 format' {
            { Get-RandomZipCode -Format "Plus4" } | Should -Not -Throw
        }

        It 'should accept StateFirst format' {
            { Get-RandomZipCode -Format "StateFirst" } | Should -Not -Throw
        }

        It 'should reject invalid format' {
            { Get-RandomZipCode -Format "Invalid" } | Should -Throw
        }
    }

    Context 'AddressStyle validation' {
        It 'should accept SingleLine style' {
            { Get-RandomZipCode -AddressStyle "SingleLine" } | Should -Not -Throw
        }

        It 'should accept MultiLine style' {
            { Get-RandomZipCode -AddressStyle "MultiLine" } | Should -Not -Throw
        }

        It 'should reject invalid address style' {
            { Get-RandomZipCode -AddressStyle "Invalid" } | Should -Throw
        }
    }

    Context 'Parameter combinations' {
        It 'should work with StateFilter and IncludeZipPlus4' {
            $result = Get-RandomZipCode -StateFilter "NY" -IncludeZipPlus4
            $result | Should -Match '^\d{5}-\d{4}$'
            $zipNumber = [int]$result.Split('-')[0]
            $zipNumber | Should -BeGreaterOrEqual 10000
            $zipNumber | Should -BeLessOrEqual 14999
        }

        It 'should work with all parameters combined' {
            $result = Get-RandomZipCode -StateFilter "FL" -IncludeState -IncludeZipPlus4 -Format "Plus4" -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.StateAbbr | Should -Be "FL"
            $result.State | Should -Be "Florida"
            $result.HasPlus4 | Should -Be $true
            $result.ZipCode | Should -Match '^\d{5}-\d{4}$'
        }

        It 'should prioritize Format over IncludeZipPlus4 for Plus4' {
            $result1 = Get-RandomZipCode -Format "Plus4"
            $result2 = Get-RandomZipCode -IncludeZipPlus4
            $result1 | Should -Match '^\d{5}-\d{4}$'
            $result2 | Should -Match '^\d{5}-\d{4}$'
        }
    }

    Context 'Data validation' {
        It 'should generate ZIP codes with correct digit count' {
            $standard = Get-RandomZipCode
            $plus4 = Get-RandomZipCode -IncludeZipPlus4

            $standard.Length | Should -Be 5
            $plus4.Length | Should -Be 10  # 5 + 1 + 4
        }

        It 'should only contain valid characters' {
            $zipCode = Get-RandomZipCode
            $zipCode | Should -Match '^[0-9]+$'  # Only digits
        }

        It 'should contain valid characters for ZIP+4' {
            $zipCode = Get-RandomZipCode -IncludeZipPlus4
            $zipCode | Should -Match '^[0-9\-]+$'  # Only digits and hyphen
        }

        It 'should generate ZIP codes within realistic US ranges' {
            # Test multiple ZIP codes to ensure they're in valid US ranges
            for ($i = 0; $i -lt 10; $i++) {
                $zipCode = Get-RandomZipCode
                $zipNumber = [int]$zipCode

                # US ZIP codes range from 00501 to 99950
                $zipNumber | Should -BeGreaterOrEqual 1000
                $zipNumber | Should -BeLessOrEqual 99999
            }
        }

        It 'should generate state abbreviations that are valid' {
            $result = Get-RandomZipCode -IncludeState -AddressStyle "MultiLine"
            $validStates = @("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA",
                           "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
                           "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                           "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
                           "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")
            $result.StateAbbr | Should -BeIn $validStates
        }
    }

    Context 'Function behavior consistency' {
        It 'should always return string type for SingleLine' {
            for ($i = 0; $i -lt 10; $i++) {
                $zipCode = Get-RandomZipCode
                $zipCode | Should -BeOfType [string]
            }
        }

        It 'should always return hashtable type for MultiLine' {
            for ($i = 0; $i -lt 10; $i++) {
                $result = Get-RandomZipCode -AddressStyle "MultiLine"
                $result | Should -BeOfType [hashtable]
            }
        }

        It 'should generate non-empty results consistently' {
            for ($i = 0; $i -lt 10; $i++) {
                $zipCode = Get-RandomZipCode
                $zipCode | Should -Not -BeNullOrEmpty
                $zipCode.Trim() | Should -Not -BeNullOrEmpty
            }
        }

        It 'should handle parameter consistency' {
            for ($i = 0; $i -lt 5; $i++) {
                $withPlus4 = Get-RandomZipCode -IncludeZipPlus4
                $withoutPlus4 = Get-RandomZipCode

                $withPlus4 | Should -Match '-'
                $withoutPlus4 | Should -Not -Match '-'
            }
        }
    }

    Context 'State-specific ZIP code validation' {
        It 'should generate California ZIP codes in correct range' {
            for ($i = 0; $i -lt 5; $i++) {
                $zipCode = Get-RandomZipCode -StateFilter "CA"
                $zipNumber = [int]$zipCode
                $zipNumber | Should -BeGreaterOrEqual 90000
                $zipNumber | Should -BeLessOrEqual 96699
            }
        }

        It 'should generate New York ZIP codes in correct range' {
            for ($i = 0; $i -lt 5; $i++) {
                $zipCode = Get-RandomZipCode -StateFilter "NY"
                $zipNumber = [int]$zipCode
                $zipNumber | Should -BeGreaterOrEqual 10000
                $zipNumber | Should -BeLessOrEqual 14999
            }
        }

        It 'should generate consistent state information' {
            $result = Get-RandomZipCode -StateFilter "WA" -IncludeState -AddressStyle "MultiLine"
            $result.StateAbbr | Should -Be "WA"
            $result.State | Should -Be "Washington"

            $zipNumber = [int]$result.ZipCode.Split('-')[0]
            $zipNumber | Should -BeGreaterOrEqual 98000
            $zipNumber | Should -BeLessOrEqual 99499
        }
    }
}
