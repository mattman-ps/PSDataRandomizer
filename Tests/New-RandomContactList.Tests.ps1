BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'New-RandomContactList Function Tests' {

    It 'should create a list with count parameter' {
        $count = 3
        $result = New-RandomContactList -Count $count
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -Be $count
    }
}