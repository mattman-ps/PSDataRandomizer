BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomWebsite Function Tests' {

    It 'should generate valid format when not null' {
        # Run multiple times to get non-null result
        $validResults = @()
        for ($i = 0; $i -lt 10; $i++) {
            $website = Get-RandomWebsite
            if ($null -ne $website) {
                $validResults += $website
            }
        }

        # If we got any non-null results, test them
        if ($validResults.Count -gt 0) {
            foreach ($website in $validResults) {
                $website | Should -BeOfType [string]
                # Accept either protocol://domain or just domain
                $website | Should -Match '^((http|https)://)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$'
            }
        }
    }

    It 'should handle multiple calls consistently' {
        # Test that function doesn't throw errors
        { Get-RandomWebsite } | Should -Not -Throw
        { Get-RandomWebsite } | Should -Not -Throw
        { Get-RandomWebsite } | Should -Not -Throw
    }
}