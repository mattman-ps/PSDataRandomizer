# Create RandomData\Examples\RandomData-Examples.ps1
<#
.SYNOPSIS
    Comprehensive examples demonstrating all RandomData generator functions.

.DESCRIPTION
    This script provides detailed examples of how to use each random data generator
    function in the RandomData module, including various parameter combinations
    and real-world use cases for deduplication testing.

.NOTES
    Run this script to see live examples of all random data generation capabilities.
    Each section demonstrates different aspects and parameter combinations.
#>

Write-Host "=== RandomData Generator Examples ===" -ForegroundColor Green
Write-Host "Demonstrating all random data generation functions with various parameters`n" -ForegroundColor Cyan

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
    Write-Host "Current script path: $scriptPath" -ForegroundColor Yellow
    Write-Host "Parent path: $parentPath" -ForegroundColor Yellow
    Write-Host "Looking for files like: $(Join-Path $parentPath 'Get-RandomDate.ps1')" -ForegroundColor Yellow
    exit 1
}

# Check for NameIT module (required for person generation)
try {
    Import-Module -Name NameIT -ErrorAction Stop
}
catch {
    Write-Warning "NameIT module not found. Person generation examples will be skipped."
    Write-Host "Install with: Install-Module -Name NameIT" -ForegroundColor Yellow
}

#region Get-RandomDate Examples
Write-Host "1. GET-RANDOMDATE EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nBasic date generation:"
1..5 | ForEach-Object {
    $date = Get-RandomDate
    $age = [math]::Floor((New-TimeSpan -Start $date -End (Get-Date)).Days / 365.25)
    Write-Host "  Random date: $($date.ToString('yyyy-MM-dd')) (Age: $age years)"
}

Write-Host "`nAdult dates (18-80 years old):"
1..3 | ForEach-Object {
    $date = Get-RandomDate -AdultDate
    $age = [math]::Floor((New-TimeSpan -Start $date -End (Get-Date)).Days / 365.25)
    Write-Host "  Adult date: $($date.ToString('yyyy-MM-dd')) (Age: $age years)"
}

Write-Host "`nChild dates (5-17 years old):"
1..3 | ForEach-Object {
    $date = Get-RandomDate -ChildDate
    $age = [math]::Floor((New-TimeSpan -Start $date -End (Get-Date)).Days / 365.25)
    Write-Host "  Child date: $($date.ToString('yyyy-MM-dd')) (Age: $age years)"
}

Write-Host "`nComparison of date types:"
Write-Host "  Random date: $(Get-RandomDate)"
Write-Host "  Adult date: $(Get-RandomDate -AdultDate)"
Write-Host "  Child date: $(Get-RandomDate -ChildDate)"

Write-Host "`nMultiple random dates:"
1..5 | ForEach-Object {
    $date = Get-RandomDate
    Write-Host "  Generated: $($date.ToString('yyyy-MM-dd'))"
}
#endregion

#region Get-RandomPerson Examples
Write-Host "`n`n2. GET-RANDOMPERSON EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

if (Get-Module -Name NameIT) {
    Write-Host "`nBasic person generation:"
    1..5 | ForEach-Object {
        $person = Get-RandomPerson
        Write-Host "  $($person.FullName)"
    }

    Write-Host "`nWith middle names:"
    1..3 | ForEach-Object {
        $person = Get-RandomPerson -IncludeMiddleName
        Write-Host "  $($person.FullName)"
    }

    Write-Host "`nWith cultural variations:"
    # Only use cultures that are confirmed to work with NameIT
    $cultures = @("Hispanic", "Asian", "African")
    foreach ($culture in $cultures) {
        try {
            $person = Get-RandomPerson -Culture $culture -IncludeMiddleName -ErrorAction Stop
            Write-Host "  ${culture}: $($person.FullName)"
        }
        catch {
            Write-Host "  ${culture}: Culture not supported - using default" -ForegroundColor Yellow
            $person = Get-RandomPerson -IncludeMiddleName
            Write-Host "  Default: $($person.FullName)"
        }
    }

    Write-Host "`nGenerated person object structure:"
    $samplePerson = Get-RandomPerson -IncludeMiddleName
    $samplePerson | Format-List
} else {
    Write-Host "NameIT module required for person generation examples." -ForegroundColor Yellow
}
#endregion

#region Get-RandomPhoneNumber Examples
Write-Host "`n3. GET-RANDOMPHONENUMBER EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nDifferent phone number formats:"
$formats = @("Standard", "Dashes", "Dots", "Spaces", "Plain")
foreach ($format in $formats) {
    $phone = Get-RandomPhoneNumber -Format $format
    Write-Host "  $format format: $phone"
}

Write-Host "`nMultiple examples of different formats:"
Write-Host "  Standard format: $(Get-RandomPhoneNumber -Format 'Standard')"
Write-Host "  Dashes format: $(Get-RandomPhoneNumber -Format 'Dashes')"
Write-Host "  Dots format: $(Get-RandomPhoneNumber -Format 'Dots')"
Write-Host "  Spaces format: $(Get-RandomPhoneNumber -Format 'Spaces')"
Write-Host "  Plain format: $(Get-RandomPhoneNumber -Format 'Plain')"

Write-Host "`nGenerated phone number examples:"
1..5 | ForEach-Object {
    $phone = Get-RandomPhoneNumber -Format "Standard"
    Write-Host "  Random phone: $phone"
}

Write-Host "`nComparison of all formats:"
$sampleFormats = @("Standard", "Dashes", "Dots", "Spaces", "Plain")
foreach ($format in $sampleFormats) {
    $phone = Get-RandomPhoneNumber -Format $format
    Write-Host "  $format`.PadRight(10): $phone"
}
#endregion

#region Get-RandomWebsite Examples
Write-Host "`n`n4. GET-RANDOMWEBSITE EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nBasic website generation:"
1..5 | ForEach-Object {
    $website = Get-RandomWebsite
    Write-Host "  $website"
}

Write-Host "`nWith different protocols:"
$protocols = @("http", "https")
foreach ($protocol in $protocols) {
    $website = Get-RandomWebsite -Protocol $protocol
    Write-Host "  $protocol website: $website"
}

Write-Host "`nWith paths:"
1..3 | ForEach-Object {
    $website = Get-RandomWebsite -IncludePath
    Write-Host "  With path: $website"
}

Write-Host "`nMultiple website examples:"
1..5 | ForEach-Object {
    $website = Get-RandomWebsite -IncludePath
    Write-Host "  Random website: $website"
}

Write-Host "`nTesting different parameter combinations:"
Write-Host "  Basic: $(Get-RandomWebsite)"
Write-Host "  With path: $(Get-RandomWebsite -IncludePath)"
Write-Host "  HTTP: $(Get-RandomWebsite -Protocol 'http')"
Write-Host "  HTTPS: $(Get-RandomWebsite -Protocol 'https')"
#endregion

#region Get-RandomAddress Examples
Write-Host "`n`n5. GET-RANDOMADDRESS EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nBasic address generation (street only - default):"
1..5 | ForEach-Object {
    $address = Get-RandomAddress
    Write-Host "  $address"
}

Write-Host "`nWith apartments and directions:"
1..3 | ForEach-Object {
    $address = Get-RandomAddress -IncludeApartment -IncludeDirection
    Write-Host "  $address"
}

Write-Host "`nWith city, state, and ZIP:"
1..3 | ForEach-Object {
    $address = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
    Write-Host "  Complete: $address"
}

Write-Host "`nWith ZIP+4 codes:"
1..3 | ForEach-Object {
    $address = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip -IncludeZipPlus4
    Write-Host "  With ZIP+4: $address"
}

Write-Host "`nTesting different parameter combinations:"
Write-Host "  Basic: $(Get-RandomAddress)"
Write-Host "  With apartment: $(Get-RandomAddress -IncludeApartment)"
Write-Host "  With direction: $(Get-RandomAddress -IncludeDirection)"
Write-Host "  Full address: $(Get-RandomAddress -IncludeCity -IncludeState -IncludeZip)"

# Only test advanced parameters if they exist
try {
    Write-Host "`nTesting format parameter (if supported):"
    $testAddress = Get-RandomAddress -Format "Full" -ErrorAction Stop
    Write-Host "  Format test: $testAddress"
} catch {
    Write-Host "  Format parameter not supported - using default" -ForegroundColor Yellow
}

try {
    Write-Host "`nTesting multi-line format (if supported):"
    $structuredAddress = Get-RandomAddress -AddressStyle "MultiLine" -IncludeCity -IncludeState -IncludeZip -ErrorAction Stop
    Write-Host "  Structured address object:"
    if ($structuredAddress -is [hashtable]) {
        $structuredAddress.GetEnumerator() | Sort-Object Name | ForEach-Object {
            Write-Host "    $($_.Key): $($_.Value)"
        }
    } else {
        $structuredAddress | Format-List
    }
} catch {
    Write-Host "  Multi-line format not supported - using default" -ForegroundColor Yellow
}
#endregion

#region Real-World Use Case Examples
Write-Host "`n`n6. REAL-WORLD USE CASE EXAMPLES" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nGenerating customer database sample:"
$customers = @()
1..10 | ForEach-Object {
    if (Get-Module -Name NameIT) {
        $person = Get-RandomPerson -IncludeMiddleName
        $phone = Get-RandomPhoneNumber -Format "Standard"
        $website = Get-RandomWebsite
        $address = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
        $birthday = Get-RandomDate -AdultDate

        $customer = [PSCustomObject]@{
            ID = $_
            Name = $person.FullName
            Email = "$($person.FirstName.ToLower()).$($person.LastName.ToLower())@example.com"
            Phone = $phone
            Address = $address
            Website = $website
            Birthday = $birthday.ToString("yyyy-MM-dd")
            Age = [math]::Floor((New-TimeSpan -Start $birthday -End (Get-Date)).Days / 365.25)
        }
        $customers += $customer
    }
}

if ($customers.Count -gt 0) {
    Write-Host "Sample customer database:"
    $customers | Select-Object ID, Name, Phone, Age | Format-Table -AutoSize
}

Write-Host "`nGenerating address variations for deduplication testing:"
$baseAddress = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip -IncludeApartment
Write-Host "  Original: $baseAddress"

# Create variations - fix the comma placement
$variations = @(
    ($baseAddress -replace 'Street', 'St' -replace 'Avenue', 'Ave'),
    ($baseAddress -replace 'Apartment', 'Apt' -replace 'Suite', 'Ste'),
    ($baseAddress -replace '\s+', ' ')  # Normalize spaces
)

Write-Host "  Variations for testing:"
$variations | ForEach-Object { Write-Host "    - $_" }

Write-Host "`nGenerating name variations for fuzzy matching:"
if (Get-Module -Name NameIT) {
    $originalPerson = Get-RandomPerson
    Write-Host "  Original: $($originalPerson.FullName)"

    # Create common variations
    $nameVariations = @(
        "$($originalPerson.FirstName) $($originalPerson.LastName.Substring(0, $originalPerson.LastName.Length-1))",  # Missing last letter
        "$($originalPerson.FirstName.Substring(0, 1)). $($originalPerson.LastName)",  # First initial only
        "$($originalPerson.LastName), $($originalPerson.FirstName)"  # Last, First format
    )

    Write-Host "  Variations for testing:"
    $nameVariations | ForEach-Object { Write-Host "    - $_" }
}
#endregion

#region Performance Testing
Write-Host "`n`n7. PERFORMANCE TESTING" -ForegroundColor Yellow
Write-Host "=" * 50

Write-Host "`nGenerating 100 addresses (performance test):"
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$addresses = 1..100 | ForEach-Object {
    Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
}
$stopwatch.Stop()
Write-Host "  Generated 100 complete addresses in $($stopwatch.ElapsedMilliseconds) ms"
Write-Host "  Average: $([math]::Round($stopwatch.ElapsedMilliseconds / 100, 2)) ms per address"

if (Get-Module -Name NameIT) {
    Write-Host "`nGenerating 50 complete contact records (performance test):"
    $stopwatch.Restart()
    $contacts = 1..50 | ForEach-Object {
        $person = Get-RandomPerson
        $phone = Get-RandomPhoneNumber -Format "Standard"
        $address = Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
        $birthday = Get-RandomDate -AdultDate

        [PSCustomObject]@{
            Name = $person.FullName
            Phone = $phone
            Address = $address
            Age = [math]::Floor((New-TimeSpan -Start $birthday -End (Get-Date)).Days / 365.25)
        }
    }
    $stopwatch.Stop()
    Write-Host "  Generated 50 complete contact records in $($stopwatch.ElapsedMilliseconds) ms"
    Write-Host "  Average: $([math]::Round($stopwatch.ElapsedMilliseconds / 50, 2)) ms per contact"
}
#endregion

Write-Host "`n`nAll RandomData examples completed!" -ForegroundColor Green
Write-Host "Try running the individual functions with different parameters to explore more options." -ForegroundColor Cyan