<#
.SYNOPSIS
    Generates a random contact list using the fake data generator functions.

.DESCRIPTION
    This script uses Get-RandomDate, Get-RandomPerson, Get-RandomPhoneNumber, Get-RandomWebsite,
    and Get-RandomAddress functions to create a realistic random contact list with names, emails,
    phone numbers, addresses, and birthdays. Includes separate fields for city, state, and ZIP codes.

.PARAMETER Count
    Number of contacts to generate (default: 10)

.PARAMETER OutputFormat
    Output format: none (display only), csv, or json (default: none)

.PARAMETER OutputPath
    Custom output path for files (default: script directory)

.PARAMETER IncludeCityStateZip
    Include city, state, and ZIP code information (default: false - leaves fields blank)

.PARAMETER ZipPlus4Probability
    Percentage chance of generating ZIP+4 codes when ZIP codes are included (default: 40)

.EXAMPLE
    .\New-RandomContactList.ps1 -Count 25 -OutputFormat csv

.EXAMPLE
    .\New-RandomContactList.ps1 -Count 50 -IncludeCityStateZip -OutputFormat json

.EXAMPLE
    .\New-RandomContactList.ps1 -Count 100 -IncludeCityStateZip -ZipPlus4Probability 75
#>

function New-RandomContactList {
    [CmdletBinding()]
    param(
        [int]$Count = 10,

        [Parameter(Mandatory = $false)]
        [ValidateSet("none", "csv", "json")]
        [string]$OutputFormat = "none",

        [string]$OutputPath = (Get-Location).Path,

        [switch]$IncludeCityStateZip,

        [ValidateRange(0, 100)]
        [int]$ZipPlus4Probability = 40
    )

    Write-Verbose "Generating $Count random contacts..."
    if ($IncludeCityStateZip) {
        Write-Verbose "Including city, state, and ZIP code information"
    }
    else {
        Write-Verbose "City, state, and ZIP fields will be left blank"
    }

    # Define realistic data arrays
    $EmailDomains = @("gmail.com", "outlook.com", "yahoo.com", "hotmail.com", "company.com", "business.org", "enterprise.net")

    # Generate contacts
    # Initialize as ArrayList
    $Contacts = [System.Collections.ArrayList]@()

    for ($i = 1; $i -le $Count; $i++) {
        Write-Progress -Activity "Generating Contacts" -Status "Creating contact $i of $Count" -PercentComplete (($i / $Count) * 100)

        try {
            # Generate person data
            $person = Get-RandomPerson

            # Ensure we have the required properties
            if (-not $person -or -not $person.FirstName -or -not $person.LastName) {
                throw "Failed to generate valid person data"
            }

            # Generate website (95% chance with multiple fallback options)
            $Website = $null
            $websiteChance = Get-Random -Maximum 100

            if ($websiteChance -lt 95) {
                # 95% chance of having a website
                try {
                    $Website = Get-RandomWebsite
                    if ($Website -and $Website -notmatch '^https?://') {
                        $Website = "https://$Website"
                    }
                }
                catch {
                    Write-Warning "Get-RandomWebsite failed for contact $i, using fallback"
                }

                # If still no website, create one from personal info
                if ([string]::IsNullOrWhiteSpace($Website)) {
                    $cleanFirstName = ($person.FirstName -replace '[^a-zA-Z]', '').ToLower()
                    $cleanLastName = ($person.LastName -replace '[^a-zA-Z]', '').ToLower()

                    # Various website patterns
                    $websitePatterns = @(
                        "$cleanFirstName$cleanLastName.com",
                        "$cleanFirstName-$cleanLastName.com",
                        "$cleanLastName.net",
                        "$cleanFirstName.org",
                        "$cleanFirstName$cleanLastName.biz"
                    )

                    $selectedPattern = Get-Random -InputObject $websitePatterns
                    $Website = "https://$selectedPattern"
                }
            }

            # Generate email based on the domain from the website
            $emailFirstName = $person.FirstName -replace '[^a-zA-Z]', ''
            $emailLastName = $person.LastName -replace '[^a-zA-Z]', ''
            $emailDomain = if ($Website) { $Website -replace 'https?://', '' -replace '/.*$', '' } else { Get-Random -InputObject $EmailDomains }
            $Email = "$($emailFirstName.ToLower()).$($emailLastName.ToLower())@$emailDomain"

            # Generate phone number
            $Phone = Get-RandomPhoneNumber

            # Generate street address
            $StreetAddress = Get-RandomAddress

            # Initialize city/state/ZIP variables
            $City = ""
            $State = ""
            $StateAbbr = ""
            $ZipCode = ""
            $ZipCodePlus4 = ""

            # Generate city/state/ZIP if requested
            if ($IncludeCityStateZip) {
                # Simple fallback approach since the original Get-RandomAddress parameters may not exist
                $states = @("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY")
                $cities = @("Springfield", "Franklin", "Georgetown", "Madison", "Arlington", "Centerville", "Lebanon", "Kingston", "Ashland", "Burlington", "Manchester", "Oxford", "Bristol", "Fairview", "Salem", "Riverside", "Greenville", "Mount Pleasant", "Hillcrest", "Oakwood")

                $StateAbbr = Get-Random -InputObject $states
                $City = Get-Random -InputObject $cities
                $State = $StateAbbr  # Simplified for this function

                # Generate ZIP code
                $ZipCode = "{0:D5}" -f (Get-Random -Minimum 10000 -Maximum 99999)

                # Generate ZIP+4 if requested
                if ((Get-Random -Maximum 100) -lt $ZipPlus4Probability) {
                    $ZipCodePlus4 = "{0:D4}" -f (Get-Random -Minimum 1000 -Maximum 9999)
                }
            }

            # Generate birthday
            $Birthday = Get-RandomDate

            # Create contact object with all fields
            $Contact = [PSCustomObject]@{
                ID            = $i
                FirstName     = $person.FirstName
                MiddleName    = if ($person.PSObject.Properties.Name -contains 'MiddleName' -and $person.MiddleName) { $person.MiddleName } else { "" }
                LastName      = $person.LastName
                FullName      = "$($person.FirstName) $($person.LastName)"
                Email         = $Email
                Phone         = $Phone
                StreetAddress = $StreetAddress
                City          = $City
                State         = $State
                StateAbbr     = $StateAbbr
                ZipCode       = $ZipCode
                ZipCodePlus4  = $ZipCodePlus4
                Website       = if ($Website) { $Website } else { "" }
                Birthday      = $Birthday.ToString("yyyy-MM-dd")
                Age           = [math]::Floor((New-TimeSpan -Start $Birthday -End (Get-Date)).Days / 365.25)
            }

            # Add items efficiently
            [void]$Contacts.Add($Contact)
        }
        catch {
            Write-Warning "Failed to generate contact $i`: $($_.Exception.Message)"
            continue
        }
    }

    Write-Progress -Activity "Generating Contacts" -Completed

    # Export based on output format
    switch ($OutputFormat) {
        "csv" {
            $csvPath = Join-Path $OutputPath "RandomContacts_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            $Contacts | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Host "Contacts exported to: $csvPath" -ForegroundColor Yellow
        }
        "json" {
            $jsonPath = Join-Path $OutputPath "RandomContacts_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
            $Contacts | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonPath
            Write-Host "Contacts exported to: $jsonPath" -ForegroundColor Yellow
        }
    }

    # Display summary if verbose
    if ($VerbosePreference -eq 'Continue' -or $OutputFormat -eq "none") {
        Write-Host "`nGenerated $($Contacts.Count) contacts" -ForegroundColor Green

        if ($Contacts.Count -gt 0) {
            Write-Host "Summary:" -ForegroundColor Green
            Write-Host "- Total contacts: $($Contacts.Count)"
            Write-Host "- Contacts with websites: $(($Contacts | Where-Object { $_.Website -and $_.Website -ne '' }).Count)"
            Write-Host "- Average age: $([math]::Round(($Contacts.Age | Measure-Object -Average).Average, 1)) years"

            if ($IncludeCityStateZip) {
                $statesUsed = $Contacts | Where-Object { $_.StateAbbr -ne "" } | Group-Object StateAbbr | Measure-Object
                $zipPlus4Count = ($Contacts | Where-Object { $_.ZipCodePlus4 -ne "" }).Count
                Write-Host "- States represented: $($statesUsed.Count)"
                Write-Host "- Contacts with ZIP+4: $zipPlus4Count"
            }
        }
    }

    # Return contacts
    return $Contacts
}