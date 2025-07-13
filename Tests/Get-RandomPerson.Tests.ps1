BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomPerson Function Tests' {
    It 'should generate a valid person object' {
        $person = Get-RandomPerson
        $person | Should -Not -BeNullOrEmpty
    }

    It 'should have valid name properties' {
        $person = Get-RandomPerson
        $person.FirstName | Should -Not -BeNullOrEmpty
        $person.LastName | Should -Not -BeNullOrEmpty
        $person.FullName | Should -Not -BeNullOrEmpty
        $person.FullName | Should -Match '^[A-Za-z\s]+$'
    }

    It 'should generate consistent full name' {
        $person = Get-RandomPerson
        $expectedFullName = "$($person.FirstName) $($person.LastName)"
        if ($person.MiddleName) {
            $expectedFullName = "$($person.FirstName) $($person.MiddleName) $($person.LastName)"
        }
        $person.FullName | Should -Be $expectedFullName
    }

    It 'should include middle name by default' {
        $person = Get-RandomPerson
        $person.MiddleName | Should -Not -BeNullOrEmpty
    }

    It 'should exclude middle name when requested' {
        $person = Get-RandomPerson -IncludeMiddleName:$false
        $person.MiddleName | Should -BeNullOrEmpty
    }
}