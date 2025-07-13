BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomPhoneNumber Function Tests' {
    It 'should generate a valid phone number format' {
        $result = Get-RandomPhoneNumber
        $result | Should -Match '^\(\d{3}\) \d{3}-\d{4}$'
    }

    It 'should generate a valid phone number' {
        $phone = Get-RandomPhoneNumber
        $phone | Should -Not -BeNullOrEmpty
        $phone | Should -BeOfType [string]
    }

    It 'should generate different phone numbers on multiple calls' {
        $phone1 = Get-RandomPhoneNumber
        $phone2 = Get-RandomPhoneNumber
        $phone1 | Should -Not -BeNullOrEmpty
        $phone2 | Should -Not -BeNullOrEmpty
    }
}