# PSDataRandomizer

A PowerShell module for generating realistic random data for testing, development, and demonstration purposes.

## Installation

1. Install required dependencies:

   ```powershell
   Install-Module -Name NameIT -Scope CurrentUser
   ```

2. Install PSDataRandomizer:

   ```powershell
   Install-Module -Name PSDataRandomizer -Scope CurrentUser
   ```

## Requirements

- PowerShell 5.1 or later
- [NameIT](https://github.com/dfinke/NameIT) module (automatically checked at import)

## Notes

- All functions generate realistic data suitable for testing and demonstrations
- Phone numbers follow NANP format and avoid reserved ranges
- Addresses use USPS-standard street types and realistic naming patterns
- Names support multiple cultures via the [NameIT](https://github.com/dfinke/NameIT) module
- Data is randomly generated and not based on real individuals

## Functions

### Get-RandomAddress

Generates realistic random addresses with optional city, state, and ZIP code components.

**Parameters:**

- `IncludeApartment` - Include apartment/suite numbers (25% chance by default)
- `IncludeDirection` - Include directional prefixes (N, S, E, W, etc.) (30% chance by default)
- `IncludeCity` - Include city name (false by default)
- `IncludeState` - Include state name and abbreviation (false by default)
- `IncludeZip` - Include ZIP code (false by default)
- `IncludeZipPlus4` - Include ZIP+4 extension when ZIP enabled (40% chance by default)
- `StreetNumberRange` - "Low" (1-999), "Medium" (100-9999), "High" (1000-99999)
- `Format` - "Full", "StreetOnly", "Compact"
- `AddressStyle` - "SingleLine", "MultiLine"

**Examples:**

```powershell
Get-RandomAddress
# Returns: 1847 Maple Street

Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
# Returns: 1847 Maple Street, Springfield, IL 62701

Get-RandomAddress -IncludeApartment -IncludeDirection
# Returns: 2156 N Oak Avenue, Apt 3B
```

### Get-RandomCity

Generates random city names with optional state information.

**Parameters:**

- `IncludeState` - Include state name and abbreviation (false by default)
- `Format` - "Full" (city name), "WithState" (city, state), "Compact" (city, ST)
- `AddressStyle` - "SingleLine" (all on one line), "MultiLine" (separate components)

**Examples:**

```powershell
Get-RandomCity
# Returns: Springfield

Get-RandomCity -IncludeState
# Returns: Springfield, Illinois

Get-RandomCity -IncludeState -Format "Compact"
# Returns: Springfield, IL

Get-RandomCity -IncludeState -AddressStyle "MultiLine"
# Returns: @{ City = "Springfield"; State = "Illinois"; StateAbbr = "IL" }
```

### Get-RandomCompanyName

Generates realistic company names with optional business suffixes.

**Parameters:**

- `IncludeSuffix` - Include business suffix like LLC, Corp, etc. (false by default)

**Examples:**

```powershell
Get-RandomCompanyName
# Returns: Tech Solutions

Get-RandomCompanyName -IncludeSuffix
# Returns: Digital Innovations LLC
```

### Get-RandomDate

Generates random dates for different age categories or custom date ranges.

**Parameters:**

- `AdultDate` - Generate date for adults (18-85 years old) - default behavior
- `ChildDate` - Generate date for children (0-17 years old)
- `CustomStartDate` - Earliest date in custom range
- `CustomEndDate` - Latest date in custom range

**Examples:**

```powershell
Get-RandomDate
# Returns: Random date for adult (18-85 years old)

Get-RandomDate -ChildDate
# Returns: Random date for child (0-17 years old)

Get-RandomDate -CustomStartDate "1990-01-01" -CustomEndDate "2000-12-31"
# Returns: Random date between 1990-2000
```

### Get-RandomGuid

Generates random GUIDs (Globally Unique Identifiers) in various formats.

**Parameters:**

- `Format` - "Standard" (lowercase with hyphens), "Upper" (uppercase), "Lower" (lowercase), "NoHyphens", "Brackets", "Parentheses"
- `IncludeBraces` - Include curly braces around the GUID (false by default)
- `IncludeParentheses` - Include parentheses around the GUID (false by default)
- `RemoveHyphens` - Remove hyphens from the GUID (false by default)
- `AddressStyle` - "SingleLine" (GUID only), "MultiLine" (GUID with metadata)

**Examples:**

```powershell
Get-RandomGuid
# Returns: a1b2c3d4-e5f6-7890-abcd-ef1234567890

Get-RandomGuid -Format "Upper"
# Returns: A1B2C3D4-E5F6-7890-ABCD-EF1234567890

Get-RandomGuid -IncludeBraces
# Returns: {a1b2c3d4-e5f6-7890-abcd-ef1234567890}

Get-RandomGuid -Format "NoHyphens"
# Returns: a1b2c3d4e5f67890abcdef1234567890

Get-RandomGuid -AddressStyle "MultiLine"
# Returns: @{ Guid = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"; Format = "Standard"; Timestamp = [DateTime] }
```

### Get-RandomPerson

Generates random person names using various cultures with configurable components.

**Parameters:**

- `Culture` - Specific culture for names ("en-US", "fr-FR", etc.)
- `IncludeMiddleName` - Include middle name (true by default)
- `IncludeCultureInfo` - Include culture information in output

**Examples:**

```powershell
Get-RandomPerson
# Returns: @{FirstName="John"; LastName="Smith"; MiddleName="Michael"; FullName="John Michael Smith"}

Get-RandomPerson -Culture "en-US" -IncludeCultureInfo
# Returns: Person with US English names and culture details

Get-RandomPerson -IncludeMiddleName:$false
# Returns: Person without middle name
```

### Get-RandomPhoneNumber

Generates realistic NANP (North American Numbering Plan) phone numbers in various formats.

**Parameters:**

- `Format` - "Standard", "Dashes", "Dots", "Spaces", "Plain"

**Examples:**

```powershell
Get-RandomPhoneNumber
# Returns: (555) 123-4567

Get-RandomPhoneNumber -Format "Dashes"
# Returns: 555-123-4567

Get-RandomPhoneNumber -Format "Plain"
# Returns: 5551234567
```

### Get-RandomState

Generates random US state names and/or abbreviations with optional ZIP code ranges.

**Parameters:**

- `IncludeAbbreviation` - Include state abbreviation with the state name (false by default)
- `IncludeZipRange` - Include ZIP code range information (false by default)
- `Format` - "Full" (full state name), "Abbreviation" (state abbr only), "Both" (name and abbr)
- `AddressStyle` - "SingleLine" (all on one line), "MultiLine" (separate components)

**Examples:**

```powershell
Get-RandomState
# Returns: California

Get-RandomState -IncludeAbbreviation
# Returns: California (CA)

Get-RandomState -Format "Abbreviation"
# Returns: CA

Get-RandomState -IncludeZipRange
# Returns: California [ZIP: 90000-96699]

Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
# Returns: @{ Name = "California"; Abbr = "CA"; ZipRanges = @(@{Start = 90000; End = 96699}) }
```

### Get-RandomWebsite

Generates realistic website URLs with configurable components.

**Parameters:**

- `IncludePath` - Include random path in URL (false by default)
- `IncludeSubdomain` - Include subdomain (false by default)
- `Protocol` - "http", "https", or "none" for domain only

**Examples:**

```powershell
Get-RandomWebsite
# Returns: example-company.com

Get-RandomWebsite -IncludePath -Protocol "https"
# Returns: https://example-company.com/products

Get-RandomWebsite -IncludeSubdomain -Protocol "https"
# Returns: https://www.example-company.com
```

### Get-RandomZipCode

Generates random ZIP codes with optional ZIP+4 extension and state information.

**Parameters:**

- `IncludeZipPlus4` - Include ZIP+4 extension codes (false by default)
- `IncludeState` - Include state name and abbreviation (false by default)
- `Format` - "Standard" (5-digit ZIP), "Plus4" (ZIP+4), "StateFirst" (state then ZIP)
- `AddressStyle` - "SingleLine" (ZIP only or with state), "MultiLine" (separate components)
- `StateFilter` - Optional state abbreviation to generate ZIP codes for that state only

**Examples:**

```powershell
Get-RandomZipCode
# Returns: 90210

Get-RandomZipCode -IncludeZipPlus4
# Returns: 90210-1234

Get-RandomZipCode -IncludeState
# Returns: 90210, CA

Get-RandomZipCode -Format "StateFirst" -IncludeState
# Returns: CA 90210

Get-RandomZipCode -StateFilter "TX" -IncludeZipPlus4
# Returns: 75001-5678

Get-RandomZipCode -IncludeState -AddressStyle "MultiLine"
# Returns: @{ ZipCode = "90210"; State = "California"; StateAbbr = "CA" }
```

### New-RandomContactList

Generates a complete list of random contacts combining all data types.

**Parameters:**

- `Count` - Number of contacts to generate (default: 10)
- `OutputFormat` - "none", "csv", "json" (default: "none")
- `OutputPath` - Custom output path for files
- `IncludeCityStateZip` - Include city, state, ZIP information
- `ZipPlus4Probability` - Chance of ZIP+4 codes (default: 40%)

**Examples:**

```powershell
New-RandomContactList -Count 25 -OutputFormat csv
# Generates 25 contacts and exports to CSV

New-RandomContactList -Count 50 -IncludeCityStateZip -OutputFormat json
# Generates 50 contacts with full address info as JSON

New-RandomContactList -Count 100 -IncludeCityStateZip -ZipPlus4Probability 75
# Generates 100 contacts with 75% chance of ZIP+4 codes
```

## Generated Contact Fields

When using `New-RandomContactList`, each contact includes:

- **ID** - Sequential contact number
- **FirstName, MiddleName, LastName** - Individual name components
- **FullName** - Complete formatted name
- **Email** - Realistic email address
- **Phone** - Formatted phone number
- **StreetAddress** - Street address
- **City, State, StateAbbr** - Location info (if enabled)
- **ZipCode, ZipCodePlus4** - Postal codes (if enabled)
- **Website** - Random website URL
- **Birthday** - Date of birth (YYYY-MM-DD format)
- **Age** - Calculated age in years

## Usage Examples

### Quick Contact Generation

```powershell
# Generate 10 basic contacts
$contacts = New-RandomContactList

# Generate 50 contacts with full address info
$contacts = New-RandomContactList -Count 50 -IncludeCityStateZip

# Export to CSV with timestamp
New-RandomContactList -Count 100 -OutputFormat csv -IncludeCityStateZip
```

### Individual Data Generation

```powershell
# Generate individual components
$name = Get-RandomPerson
$address = Get-RandomAddress -IncludeApartment
$city = Get-RandomCity -IncludeState
$state = Get-RandomState -Format "Abbreviation"
$zipCode = Get-RandomZipCode -IncludeZipPlus4
$phone = Get-RandomPhoneNumber -Format "Standard"
$website = Get-RandomWebsite -Protocol "https"
$birthday = Get-RandomDate -AdultDate
$companyName = Get-RandomCompanyName -IncludeSuffix
$guid = Get-RandomGuid -Format "Upper"

# Combine into custom object
$contact = [PSCustomObject]@{
    ID = $guid
    Name = $name.FullName
    Company = $companyName
    Address = $address
    City = $city
    ZipCode = $zipCode
    Phone = $phone
    Website = $website
    Birthday = $birthday.ToString("yyyy-MM-dd")
}
```

## Special Thanks

- [dfinke](https://github.com/dfinke) for putting together the [NameIT](https://github.com/dfinke/NameIT) repo!
