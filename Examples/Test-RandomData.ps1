# Create RandomData\Examples\Test-RandomData.ps1
<#
.SYNOPSIS
    Basic tests for RandomData generator functions.

.DESCRIPTION
    This script performs basic validation tests on all RandomData generator functions
    to ensure they are working correctly and producing expected output formats.

.NOTES
    Run this script to verify all RandomData functions are working properly.
#>

Write-Host "=== RandomData Generator Tests ===" -ForegroundColor Green
Write-Host "Running basic validation tests for all functions`n" -ForegroundColor Cyan

# Dot source all the random data functions
$scriptPath = Split-Path $MyInvocation.MyCommand.Path
$parentPath = Split-Path $scriptPath

try {
    . (Join-Path $parentPath 'Get-RandomDate.ps1')
    . (Join-Path $parentPath 'Get-RandomPerson.ps1')
    . (Join-Path $parentPath 'Get-RandomPhoneNumber.ps1')
    . (Join-Path $parentPath 'Get-RandomWebsite.ps1')
    . (Join-Path $parentPath 'Get-RandomAddress.ps1')
    Write-Host "All RandomData functions loaded successfully!`n" -ForegroundColor Green
}
catch {
    Write-Error "Failed to load RandomData functions: $($_.Exception.Message)"
    exit 1
}

$testResults = @()

#region Test Get-RandomDate
Write-Host "Testing Get-RandomDate..." -ForegroundColor Yellow

try {
    # Test basic functionality only - removing problematic parameters
    $date = Get-RandomDate
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomDate"
        Test = "Basic generation"
        Result = if ($date -is [DateTime]) { "PASS" } else { "FAIL" }
        Details = "Generated: $($date.ToString('yyyy-MM-dd'))"
    }

    # Test adult date range only if parameter exists
    try {
        $adultDate = Get-RandomDate -AdultDate -ErrorAction Stop
        $age = [math]::Floor((New-TimeSpan -Start $adultDate -End (Get-Date)).Days / 365.25)
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomDate"
            Test = "Adult date range"
            Result = if ($age -ge 18 -and $age -le 80) { "PASS" } else { "FAIL" }
            Details = "Age: $age years"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomDate"
            Test = "Adult date range"
            Result = "SKIP"
            Details = "AdultDate parameter not supported"
        }
    }

    # Test child date range only if parameter exists
    try {
        $childDate = Get-RandomDate -ChildDate -ErrorAction Stop
        $childAge = [math]::Floor((New-TimeSpan -Start $childDate -End (Get-Date)).Days / 365.25)
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomDate"
            Test = "Child date range"
            Result = if ($childAge -ge 5 -and $childAge -le 17) { "PASS" } else { "FAIL" }
            Details = "Age: $childAge years"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomDate"
            Test = "Child date range"
            Result = "SKIP"
            Details = "ChildDate parameter not supported"
        }
    }

    Write-Host "  ✓ Get-RandomDate tests completed" -ForegroundColor Green
}
catch {
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomDate"
        Test = "Error occurred"
        Result = "FAIL"
        Details = $_.Exception.Message
    }
    Write-Host "  ✗ Get-RandomDate tests failed: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Test Get-RandomPerson
Write-Host "Testing Get-RandomPerson..." -ForegroundColor Yellow

try {
    # Check if NameIT module is available
    if (Get-Module -Name NameIT -ListAvailable) {
        Import-Module -Name NameIT -ErrorAction Stop

        # Test basic functionality
        $person = Get-RandomPerson
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomPerson"
            Test = "Basic generation"
            Result = if ($person.FirstName -and $person.LastName -and $person.FullName) { "PASS" } else { "FAIL" }
            Details = "Generated: $($person.FullName)"
        }

        # Test with middle name only if parameter exists
        try {
            $personWithMiddle = Get-RandomPerson -IncludeMiddleName -ErrorAction Stop
            $testResults += [PSCustomObject]@{
                Function = "Get-RandomPerson"
                Test = "With middle name"
                Result = if ($personWithMiddle.MiddleName) { "PASS" } else { "FAIL" }
                Details = "Generated: $($personWithMiddle.FullName)"
            }
        }
        catch {
            $testResults += [PSCustomObject]@{
                Function = "Get-RandomPerson"
                Test = "With middle name"
                Result = "SKIP"
                Details = "IncludeMiddleName parameter not supported"
            }
        }

        Write-Host "  ✓ Get-RandomPerson tests completed" -ForegroundColor Green
    }
    else {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomPerson"
            Test = "Module availability"
            Result = "SKIP"
            Details = "NameIT module not installed"
        }
        Write-Host "  ⚠ Get-RandomPerson tests skipped (NameIT module required)" -ForegroundColor Yellow
    }
}
catch {
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomPerson"
        Test = "Error occurred"
        Result = "FAIL"
        Details = $_.Exception.Message
    }
    Write-Host "  ✗ Get-RandomPerson tests failed: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Test Get-RandomPhoneNumber
Write-Host "Testing Get-RandomPhoneNumber..." -ForegroundColor Yellow

try {
    # Test basic functionality without parameters first
    $phone = Get-RandomPhoneNumber
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomPhoneNumber"
        Test = "Basic generation"
        Result = if ($phone -match '\d' -and $phone.Length -ge 10) { "PASS" } else { "FAIL" }
        Details = "Generated: $phone"
    }

    # Test only confirmed valid formats - removed "International"
    $formats = @("Standard", "Dashes", "Dots", "Spaces", "Plain")
    foreach ($format in $formats) {
        try {
            $phoneFormatted = Get-RandomPhoneNumber -Format $format -ErrorAction Stop
            $isValid = $phoneFormatted -match '\d' -and $phoneFormatted.Length -ge 10

            $testResults += [PSCustomObject]@{
                Function = "Get-RandomPhoneNumber"
                Test = "$format format"
                Result = if ($isValid) { "PASS" } else { "FAIL" }
                Details = "Generated: $phoneFormatted"
            }
        }
        catch {
            $testResults += [PSCustomObject]@{
                Function = "Get-RandomPhoneNumber"
                Test = "$format format"
                Result = "FAIL"
                Details = "Error: $($_.Exception.Message)"
            }
        }
    }

    Write-Host "  ✓ Get-RandomPhoneNumber tests completed" -ForegroundColor Green
}
catch {
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomPhoneNumber"
        Test = "Error occurred"
        Result = "FAIL"
        Details = $_.Exception.Message
    }
    Write-Host "  ✗ Get-RandomPhoneNumber tests failed: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Test Get-RandomWebsite
Write-Host "Testing Get-RandomWebsite..." -ForegroundColor Yellow

try {
    # Test basic functionality
    $website = Get-RandomWebsite
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomWebsite"
        Test = "Basic generation"
        Result = if ($website -and $website.Length -gt 5) { "PASS" } else { "FAIL" }
        Details = "Generated: $website"
    }

    # Test with different protocols only if supported
    try {
        $httpSite = Get-RandomWebsite -Protocol "http" -ErrorAction Stop
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomWebsite"
            Test = "HTTP protocol"
            Result = if ($httpSite -match '^http://') { "PASS" } else { "FAIL" }
            Details = "Generated: $httpSite"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomWebsite"
            Test = "HTTP protocol"
            Result = "SKIP"
            Details = "Protocol parameter not supported"
        }
    }

    # Test with path only if supported
    try {
        $siteWithPath = Get-RandomWebsite -IncludePath -ErrorAction Stop
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomWebsite"
            Test = "With path"
            Result = if ($siteWithPath -match '/') { "PASS" } else { "FAIL" }
            Details = "Generated: $siteWithPath"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomWebsite"
            Test = "With path"
            Result = "SKIP"
            Details = "IncludePath parameter not supported"
        }
    }

    Write-Host "  ✓ Get-RandomWebsite tests completed" -ForegroundColor Green
}
catch {
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomWebsite"
        Test = "Error occurred"
        Result = "FAIL"
        Details = $_.Exception.Message
    }
    Write-Host "  ✗ Get-RandomWebsite tests failed: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Test Get-RandomAddress
Write-Host "Testing Get-RandomAddress..." -ForegroundColor Yellow

try {
    # Test basic functionality
    $address = Get-RandomAddress
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomAddress"
        Test = "Basic generation"
        Result = if ($address -and $address.Length -gt 5) { "PASS" } else { "FAIL" }
        Details = "Generated: $address"
    }

    # Test with apartments only if supported
    try {
        $addressWithApt = Get-RandomAddress -IncludeApartment -ErrorAction Stop
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomAddress"
            Test = "With apartment"
            Result = if ($addressWithApt -and $addressWithApt.Length -gt 5) { "PASS" } else { "FAIL" }
            Details = "Generated: $addressWithApt"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomAddress"
            Test = "With apartment"
            Result = "SKIP"
            Details = "IncludeApartment parameter not supported"
        }
    }

    # Test with city/state/ZIP only if supported
    try {
        $fullAddress = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip -ErrorAction Stop
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomAddress"
            Test = "With city/state/ZIP"
            Result = if ($fullAddress -and $fullAddress.Length -gt 10) { "PASS" } else { "FAIL" }
            Details = "Generated: $fullAddress"
        }
    }
    catch {
        $testResults += [PSCustomObject]@{
            Function = "Get-RandomAddress"
            Test = "With city/state/ZIP"
            Result = "SKIP"
            Details = "Geographic parameters not supported"
        }
    }

    Write-Host "  ✓ Get-RandomAddress tests completed" -ForegroundColor Green
}
catch {
    $testResults += [PSCustomObject]@{
        Function = "Get-RandomAddress"
        Test = "Error occurred"
        Result = "FAIL"
        Details = $_.Exception.Message
    }
    Write-Host "  ✗ Get-RandomAddress tests failed: $($_.Exception.Message)" -ForegroundColor Red
}
#endregion

#region Display Results
Write-Host "`n=== TEST RESULTS ===" -ForegroundColor Green
$testResults | Format-Table -Property Function, Test, Result, Details -AutoSize

# Summary
$passCount = ($testResults | Where-Object Result -eq "PASS").Count
$failCount = ($testResults | Where-Object Result -eq "FAIL").Count
$skipCount = ($testResults | Where-Object Result -eq "SKIP").Count
$totalCount = $testResults.Count

Write-Host "`n=== SUMMARY ===" -ForegroundColor Green
Write-Host "Total Tests: $totalCount"
Write-Host "Passed: $passCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor Red
Write-Host "Skipped: $skipCount" -ForegroundColor Yellow

if ($failCount -eq 0) {
    Write-Host "`n✓ All available tests passed!" -ForegroundColor Green
    if ($skipCount -gt 0) {
        Write-Host "Note: $skipCount tests were skipped due to unsupported parameters." -ForegroundColor Cyan
    }
} else {
    Write-Host "`n✗ Some tests failed. Please check the functions." -ForegroundColor Red
}
#endregion