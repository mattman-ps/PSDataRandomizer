@{
    Run = @{
        Path = 'Tests'
        PassThru = $true
    }
    Output = @{
        Verbosity = 'Detailed'
    }
    TestResult = @{
        Enabled = $true
        OutputFormat = 'NUnitXml'
        OutputPath = 'Tests\TestResults\TestResults.xml'
    }
    CodeCoverage = @{
        Enabled = $true
        Path = 'Public\*.ps1'
        OutputFormat = 'JaCoCo'
        OutputPath = 'Tests\TestResults\CodeCoverage.xml'
    }
    Should = @{
        ErrorAction = 'Stop'
    }
}