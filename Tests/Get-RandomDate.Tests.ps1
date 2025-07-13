BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot\..\PSDataRandomizer.psd1" -Force
}

Describe 'Get-RandomDate Function Tests' {
    It 'should generate a valid date' {
        $date = Get-RandomDate
        $date | Should -BeOfType [datetime]
    }

    It 'should generate a date within the specified range' {
        # Check what parameters the function actually accepts
        $command = Get-Command Get-RandomDate
        $parameters = $command.Parameters.Keys

        if ($parameters -contains 'StartDate' -and $parameters -contains 'EndDate') {
            $startDate = Get-Date '2020-01-01'
            $endDate = Get-Date '2023-12-31'
            $date = Get-RandomDate -StartDate $startDate -EndDate $endDate
            $date | Should -BeGreaterThanOrEqualTo $startDate
            $date | Should -BeLessThanOrEqualTo $endDate
        }
        elseif ($parameters -contains 'MinDate' -and $parameters -contains 'MaxDate') {
            $minDate = Get-Date '2020-01-01'
            $maxDate = Get-Date '2023-12-31'
            $date = Get-RandomDate -MinDate $minDate -MaxDate $maxDate
            $date | Should -BeGreaterThanOrEqualTo $minDate
            $date | Should -BeLessThanOrEqualTo $maxDate
        }
        else {
            # If no range parameters, just test that it returns a valid date
            $date = Get-RandomDate
            $date | Should -BeOfType [datetime]
        }
    }
}