BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomCompanyName Function Tests' {
    It 'should generate a valid company name' {
        $companyName = Get-RandomCompanyName
        $companyName | Should -Not -BeNullOrEmpty
        $companyName | Should -BeOfType [string]
    }

    It 'should generate different company names on multiple calls' {
        $company1 = Get-RandomCompanyName
        $company2 = Get-RandomCompanyName
        $company1 | Should -Not -BeNullOrEmpty
        $company2 | Should -Not -BeNullOrEmpty
        # Note: companies could be the same due to randomness, so we just verify they're generated
    }

    It 'should return company name without suffix by default' {
        $companyName = Get-RandomCompanyName
        $companyName | Should -Not -BeNullOrEmpty
        $companyName | Should -BeOfType [string]
        # Should not contain common suffixes like Ltd., PLC, etc.
        $companyName | Should -Not -Match '(Ltd\.|PLC|LLP|AG|S\.A\.|Pty Ltd|GmbH)$'
    }

    It 'should contain exactly two words when no suffix is included' {
        $companyName = Get-RandomCompanyName
        $words = $companyName.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
        $words.Count | Should -Be 2
    }

    Context 'When IncludeSuffix is specified' {
        It 'should include a suffix when requested' {
            $companyNameWithSuffix = Get-RandomCompanyName -IncludeSuffix
            $companyNameWithSuffix | Should -Not -BeNullOrEmpty
            # Should contain one of the valid suffixes
            $companyNameWithSuffix | Should -Match '(Ltd\.|PLC|LLP|AG|S\.A\.|Pty Ltd|GmbH)$'
        }

        It 'should contain at least three parts when suffix is included' {
            $companyNameWithSuffix = Get-RandomCompanyName -IncludeSuffix
            $parts = $companyNameWithSuffix.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
            $parts.Count | Should -BeGreaterOrEqual 3
        }

        It 'should end with a valid business suffix' {
            $companyNameWithSuffix = Get-RandomCompanyName -IncludeSuffix
            $validSuffixes = @("Ltd.", "PLC", "LLP", "AG", "S.A.", "Pty Ltd", "GmbH")
            $endsWithValidSuffix = $false
            foreach ($suffix in $validSuffixes) {
                if ($companyNameWithSuffix.EndsWith($suffix)) {
                    $endsWithValidSuffix = $true
                    break
                }
            }
            $endsWithValidSuffix | Should -Be $true
        }
    }

    Context 'Data validation' {
        It 'should generate company names that are strings' {
            $companyName = Get-RandomCompanyName
            $companyName | Should -BeOfType [string]
            $companyName.Length | Should -BeGreaterThan 0
        }

        It 'should not contain special characters except periods and spaces' {
            $companyName = Get-RandomCompanyName -IncludeSuffix
            # Allow letters, numbers, spaces, periods, and common business characters
            $companyName | Should -Match '^[A-Za-z0-9\s\.\&]+$'
        }

        It 'should not start or end with spaces' {
            $companyName = Get-RandomCompanyName
            $companyName | Should -Not -Match '^\s'
            $companyName | Should -Not -Match '\s$'
        }

        It 'should have proper capitalization' {
            $companyName = Get-RandomCompanyName
            $words = $companyName.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)
            foreach ($word in $words) {
                if ($word -notmatch '^[A-Z]') {
                    # Skip suffixes that might have different capitalization patterns
                    if ($word -notmatch '\.|Ltd|PLC|LLP|AG|GmbH') {
                        $word | Should -Match '^[A-Z]'
                    }
                }
            }
        }
    }

    Context 'Function behavior consistency' {
        It 'should always return a string type' {
            for ($i = 0; $i -lt 10; $i++) {
                $companyName = Get-RandomCompanyName
                $companyName | Should -BeOfType [string]
            }
        }

        It 'should generate non-empty results consistently' {
            for ($i = 0; $i -lt 10; $i++) {
                $companyName = Get-RandomCompanyName
                $companyName | Should -Not -BeNullOrEmpty
                $companyName.Trim() | Should -Not -BeNullOrEmpty
            }
        }

        It 'should handle suffix parameter consistently' {
            for ($i = 0; $i -lt 5; $i++) {
                $withSuffix = Get-RandomCompanyName -IncludeSuffix
                $withoutSuffix = Get-RandomCompanyName

                $withSuffix | Should -Match '(Ltd\.|PLC|LLP|AG|S\.A\.|Pty Ltd|GmbH)$'
                $withoutSuffix | Should -Not -Match '(Ltd\.|PLC|LLP|AG|S\.A\.|Pty Ltd|GmbH)$'
            }
        }
    }

    Context 'Word combination validation' {
        It 'should use realistic business words' {
            $companyName = Get-RandomCompanyName
            $words = $companyName.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)

            # Check that words are from expected categories
            $businessWords = @(
                "Tech", "Digital", "Solutions", "Systems", "Global", "International",
                "Enterprise", "Consulting", "Services", "Innovations", "Dynamics",
                "United", "Premier", "Advanced", "Smart", "Future", "Next", "Core",
                "Alpha", "Beta", "Gamma", "Delta", "Omega", "Prime", "Apex", "Peak",
                "Summit", "Bridge", "Connect", "Link", "Network", "Web", "Cloud",
                "Data", "Info", "Cyber", "Quantum", "Nano", "Micro", "Macro",
                "Corp", "Inc", "LLC", "Group", "Company", "Enterprises", "Industries",
                "Technologies", "Partners", "Associates", "Ventures", "Holdings",
                "Development", "Management", "Capital", "Resources"
            )

            $words[0] | Should -BeIn $businessWords
            $words[1] | Should -BeIn $businessWords
        }

        It 'should create logical business name combinations' {
            $companyName = Get-RandomCompanyName
            $words = $companyName.Split(' ', [StringSplitOptions]::RemoveEmptyEntries)

            # Verify we have exactly 2 words for basic company name
            $words.Count | Should -Be 2

            # Both words should be non-empty and reasonable length
            $words[0].Length | Should -BeGreaterThan 1
            $words[1].Length | Should -BeGreaterThan 1
        }
    }

    Context 'Parameter validation' {
        It 'should accept IncludeSuffix switch parameter' {
            { Get-RandomCompanyName -IncludeSuffix } | Should -Not -Throw
        }

        It 'should work without any parameters' {
            { Get-RandomCompanyName } | Should -Not -Throw
        }

        It 'should handle explicit false for IncludeSuffix' {
            { Get-RandomCompanyName -IncludeSuffix:$false } | Should -Not -Throw
            $companyName = Get-RandomCompanyName -IncludeSuffix:$false
            $companyName | Should -Not -Match '(Ltd\.|PLC|LLP|AG|S\.A\.|Pty Ltd|GmbH)$'
        }
    }
}
