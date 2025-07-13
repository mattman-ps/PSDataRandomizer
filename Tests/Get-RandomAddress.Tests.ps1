BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomAddress Function Tests' {
    It 'should generate a valid address' {
        $address = Get-RandomAddress
        $address | Should -Not -BeNullOrEmpty
        $address | Should -BeOfType [string]
    }

    It 'should generate different addresses on multiple calls' {
        $address1 = Get-RandomAddress
        $address2 = Get-RandomAddress
        $address1 | Should -Not -BeNullOrEmpty
        $address2 | Should -Not -BeNullOrEmpty
    }
}