BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomGuid Function Tests' {
    It 'should generate a valid GUID' {
        $guid = Get-RandomGuid
        $guid | Should -Not -BeNullOrEmpty
        $guid | Should -BeOfType [string]
    }

    It 'should generate different GUIDs on multiple calls' {
        $guid1 = Get-RandomGuid
        $guid2 = Get-RandomGuid
        $guid1 | Should -Not -BeNullOrEmpty
        $guid2 | Should -Not -BeNullOrEmpty
        $guid1 | Should -Not -Be $guid2  # GUIDs should be unique
    }

    It 'should return standard format GUID by default' {
        $guid = Get-RandomGuid
        $guid | Should -Match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$'
    }

    It 'should be a valid GUID format that can be parsed' {
        $guid = Get-RandomGuid
        { [System.Guid]::Parse($guid) } | Should -Not -Throw
    }

    Context 'Format parameter tests' {
        It 'should return standard format with Standard parameter' {
            $guid = Get-RandomGuid -Format "Standard"
            $guid | Should -Match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$'
        }

        It 'should return uppercase format with Upper parameter' {
            $guid = Get-RandomGuid -Format "Upper"
            $guid | Should -Match '^[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}$'
        }

        It 'should return lowercase format with Lower parameter' {
            $guid = Get-RandomGuid -Format "Lower"
            $guid | Should -Match '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$'
        }

        It 'should return no hyphens format with NoHyphens parameter' {
            $guid = Get-RandomGuid -Format "NoHyphens"
            $guid | Should -Match '^[a-f0-9]{32}$'
            $guid | Should -Not -Match '-'
        }

        It 'should return bracketed format with Brackets parameter' {
            $guid = Get-RandomGuid -Format "Brackets"
            $guid | Should -Match '^\{[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\}$'
        }

        It 'should return parentheses format with Parentheses parameter' {
            $guid = Get-RandomGuid -Format "Parentheses"
            $guid | Should -Match '^\([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\)$'
        }
    }

    Context 'Switch parameter tests' {
        It 'should include braces when IncludeBraces is specified' {
            $guid = Get-RandomGuid -IncludeBraces
            $guid | Should -Match '^\{[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\}$'
        }

        It 'should include parentheses when IncludeParentheses is specified' {
            $guid = Get-RandomGuid -IncludeParentheses
            $guid | Should -Match '^\([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\)$'
        }

        It 'should remove hyphens when RemoveHyphens is specified' {
            $guid = Get-RandomGuid -RemoveHyphens
            $guid | Should -Match '^[a-f0-9]{32}$'
            $guid | Should -Not -Match '-'
        }

        It 'should combine RemoveHyphens with IncludeBraces correctly' {
            $guid = Get-RandomGuid -RemoveHyphens -IncludeBraces
            $guid | Should -Match '^\{[a-f0-9]{32}\}$'
            $guid | Should -Not -Match '-'
        }
    }

    Context 'When AddressStyle is MultiLine' {
        It 'should return hashtable for GUID only' {
            $result = Get-RandomGuid -AddressStyle "MultiLine"
            $result | Should -BeOfType [hashtable]
            $result.Guid | Should -Not -BeNullOrEmpty
            $result.Format | Should -Be "Standard"
            $result.Timestamp | Should -BeOfType [DateTime]
            $result.OriginalGuid | Should -BeOfType [System.Guid]
        }

        It 'should include format metadata in MultiLine' {
            $result = Get-RandomGuid -AddressStyle "MultiLine"
            $result.HasHyphens | Should -BeOfType [bool]
            $result.HasBraces | Should -BeOfType [bool]
            $result.HasParentheses | Should -BeOfType [bool]
        }

        It 'should set HasHyphens correctly for NoHyphens format' {
            $result = Get-RandomGuid -Format "NoHyphens" -AddressStyle "MultiLine"
            $result.HasHyphens | Should -Be $false
        }

        It 'should set HasBraces correctly for Brackets format' {
            $result = Get-RandomGuid -Format "Brackets" -AddressStyle "MultiLine"
            $result.HasBraces | Should -Be $true
        }

        It 'should set HasParentheses correctly for Parentheses format' {
            $result = Get-RandomGuid -Format "Parentheses" -AddressStyle "MultiLine"
            $result.HasParentheses | Should -Be $true
        }

        It 'should set metadata correctly for switch parameters' {
            $result = Get-RandomGuid -IncludeBraces -RemoveHyphens -AddressStyle "MultiLine"
            $result.HasBraces | Should -Be $true
            $result.HasHyphens | Should -Be $false
        }
    }

    Context 'Format validation' {
        It 'should accept Standard format' {
            { Get-RandomGuid -Format "Standard" } | Should -Not -Throw
        }

        It 'should accept Upper format' {
            { Get-RandomGuid -Format "Upper" } | Should -Not -Throw
        }

        It 'should accept Lower format' {
            { Get-RandomGuid -Format "Lower" } | Should -Not -Throw
        }

        It 'should accept NoHyphens format' {
            { Get-RandomGuid -Format "NoHyphens" } | Should -Not -Throw
        }

        It 'should accept Brackets format' {
            { Get-RandomGuid -Format "Brackets" } | Should -Not -Throw
        }

        It 'should accept Parentheses format' {
            { Get-RandomGuid -Format "Parentheses" } | Should -Not -Throw
        }

        It 'should reject invalid format' {
            { Get-RandomGuid -Format "Invalid" } | Should -Throw
        }
    }

    Context 'AddressStyle validation' {
        It 'should accept SingleLine style' {
            { Get-RandomGuid -AddressStyle "SingleLine" } | Should -Not -Throw
        }

        It 'should accept MultiLine style' {
            { Get-RandomGuid -AddressStyle "MultiLine" } | Should -Not -Throw
        }

        It 'should reject invalid address style' {
            { Get-RandomGuid -AddressStyle "Invalid" } | Should -Throw
        }
    }

    Context 'Parameter combinations' {
        It 'should work with Upper format and IncludeBraces' {
            $guid = Get-RandomGuid -Format "Upper" -IncludeBraces
            $guid | Should -Match '^\{[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}\}$'
        }

        It 'should work with Lower format and RemoveHyphens' {
            $guid = Get-RandomGuid -Format "Lower" -RemoveHyphens
            $guid | Should -Match '^[a-f0-9]{32}$'
        }

        It 'should work with all switches combined' {
            $guid = Get-RandomGuid -IncludeBraces -RemoveHyphens
            $guid | Should -Match '^\{[a-f0-9]{32}\}$'
        }

        It 'should prioritize Format over switches when conflicting' {
            $guid = Get-RandomGuid -Format "Brackets" -IncludeParentheses
            $guid | Should -Match '^\{[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\}$'
            $guid | Should -Not -Match '^\('
        }
    }

    Context 'GUID validity and uniqueness' {
        It 'should generate valid GUID that can be converted back to System.Guid' {
            $guidString = Get-RandomGuid
            $parsedGuid = [System.Guid]::Parse($guidString)
            $parsedGuid | Should -BeOfType [System.Guid]
        }

        It 'should generate unique GUIDs consistently' {
            $guids = @()
            for ($i = 0; $i -lt 100; $i++) {
                $guids += Get-RandomGuid
            }
            $uniqueGuids = $guids | Sort-Object | Get-Unique
            $uniqueGuids.Count | Should -Be $guids.Count
        }

        It 'should generate GUIDs with proper version and variant bits' {
            $guidString = Get-RandomGuid
            $guid = [System.Guid]::Parse($guidString)
            $guidBytes = $guid.ToByteArray()

            # Check version (should be 4 for random GUID)
            ($guidBytes[7] -band 0xF0) | Should -Be 0x40

            # Check variant (should be 10xx for RFC 4122)
            ($guidBytes[8] -band 0xC0) | Should -Be 0x80
        }
    }

    Context 'Function behavior consistency' {
        It 'should always return string type for SingleLine' {
            for ($i = 0; $i -lt 10; $i++) {
                $guid = Get-RandomGuid
                $guid | Should -BeOfType [string]
            }
        }

        It 'should always return hashtable type for MultiLine' {
            for ($i = 0; $i -lt 10; $i++) {
                $result = Get-RandomGuid -AddressStyle "MultiLine"
                $result | Should -BeOfType [hashtable]
            }
        }

        It 'should generate non-empty results consistently' {
            for ($i = 0; $i -lt 10; $i++) {
                $guid = Get-RandomGuid
                $guid | Should -Not -BeNullOrEmpty
                $guid.Trim() | Should -Not -BeNullOrEmpty
            }
        }

        It 'should handle format parameters consistently' {
            for ($i = 0; $i -lt 5; $i++) {
                $upper = Get-RandomGuid -Format "Upper"
                $lower = Get-RandomGuid -Format "Lower"
                $noHyphens = Get-RandomGuid -Format "NoHyphens"

                $upper | Should -Match '^[A-F0-9\-]+$'  # Only uppercase hex and hyphens
                $lower | Should -Match '^[a-f0-9\-]+$'  # Only lowercase hex and hyphens
                $noHyphens | Should -Not -Match '-'
            }
        }
    }

    Context 'Data validation' {
        It 'should generate proper GUID length for different formats' {
            $standard = Get-RandomGuid -Format "Standard"
            $noHyphens = Get-RandomGuid -Format "NoHyphens"
            $brackets = Get-RandomGuid -Format "Brackets"

            $standard.Length | Should -Be 36  # 32 chars + 4 hyphens
            $noHyphens.Length | Should -Be 32  # 32 chars only
            $brackets.Length | Should -Be 38   # 36 chars + 2 braces
        }

        It 'should not contain invalid characters' {
            $guid = Get-RandomGuid
            $guid | Should -Match '^[a-f0-9\-]+$'  # Only hex chars and hyphens
        }

        It 'should maintain GUID structure with hyphens in correct positions' {
            $guid = Get-RandomGuid
            $parts = $guid.Split('-')
            $parts.Count | Should -Be 5
            $parts[0].Length | Should -Be 8
            $parts[1].Length | Should -Be 4
            $parts[2].Length | Should -Be 4
            $parts[3].Length | Should -Be 4
            $parts[4].Length | Should -Be 12
        }
    }
}
