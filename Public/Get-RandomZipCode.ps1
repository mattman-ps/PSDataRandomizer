<#
.SYNOPSIS
    Generates a random ZIP code with optional ZIP+4 extension and state information.

.DESCRIPTION
    This function generates random ZIP codes based on realistic US ZIP code ranges for each state.
    It can return basic 5-digit ZIP codes, ZIP+4 format, and optionally include state information.
    ZIP codes are generated within the actual ranges used by each US state.

.PARAMETER IncludeZipPlus4
    Include ZIP+4 extension codes (default: false)

.PARAMETER IncludeState
    Include state name and abbreviation with the ZIP code (default: false)

.PARAMETER Format
    Output format: "Standard" (5-digit ZIP), "Plus4" (ZIP+4), "StateFirst" (state then ZIP)

.PARAMETER AddressStyle
    Output style: "SingleLine" (ZIP only or with state), "MultiLine" (separate components)

.PARAMETER StateFilter
    Optional state abbreviation to generate ZIP codes only for that state (e.g., "CA", "TX")

.EXAMPLE
    Get-RandomZipCode
    # Returns: 90210 (5-digit ZIP code - default)

.EXAMPLE
    Get-RandomZipCode -IncludeZipPlus4
    # Returns: 90210-1234

.EXAMPLE
    Get-RandomZipCode -IncludeState
    # Returns: 90210, CA

.EXAMPLE
    Get-RandomZipCode -Format "StateFirst" -IncludeState
    # Returns: CA 90210

.EXAMPLE
    Get-RandomZipCode -StateFilter "TX" -IncludeZipPlus4
    # Returns: 75001-5678 (Texas ZIP code with extension)

.EXAMPLE
    Get-RandomZipCode -IncludeState -AddressStyle "MultiLine"
    # Returns: @{ ZipCode = "90210"; State = "California"; StateAbbr = "CA" }

.NOTES
    Generates realistic ZIP codes based on actual US Postal Service ranges for each state.
    Default behavior returns 5-digit ZIP code only.
#>

function Get-RandomZipCode {
    [CmdletBinding()]
    param (
        [switch]$IncludeZipPlus4,

        [switch]$IncludeState,

        [ValidateSet("Standard", "Plus4", "StateFirst")]
        [string]$Format = "Standard",

        [ValidateSet("SingleLine", "MultiLine")]
        [string]$AddressStyle = "SingleLine",

        [ValidatePattern("^[A-Z]{2}$")]
        [string]$StateFilter
    )

    # Get a random state (or filtered state if specified)
    if ($StateFilter) {
        $selectedState = $Global:States | Where-Object { $_.Abbr -eq $StateFilter }
        if (-not $selectedState) {
            throw "Invalid state abbreviation: $StateFilter. Use a valid 2-letter state code like 'CA' or 'TX'."
        }
    }
    else {
        $selectedState = Get-Random -InputObject $Global:States
    }

    # Generate ZIP code from the selected state's ranges
    $zipRange = Get-Random -InputObject $selectedState.ZipRanges
    $zip = Get-Random -Minimum $zipRange.Start -Maximum $zipRange.End

    # Format ZIP code as 5-digit string with leading zeros
    $zipFormatted = "{0:D5}" -f $zip

    # Generate ZIP+4 extension if requested
    $zipCode = if ($IncludeZipPlus4 -or $Format -eq "Plus4") {
        $plus4 = Get-Random -Minimum 1000 -Maximum 9999
        "$zipFormatted-$plus4"
    }
    else {
        $zipFormatted
    }

    # If state information is not requested and single line format
    if (-not $IncludeState -and $AddressStyle -eq "SingleLine") {
        return $zipCode
    }

    # Handle different formats and state inclusion
    if ($AddressStyle -eq "MultiLine") {
        $result = @{
            ZipCode = $zipCode
        }

        if ($IncludeState) {
            $result.State = $selectedState.Name
            $result.StateAbbr = $selectedState.Abbr
        }

        # Add ZIP format metadata
        $result.HasPlus4 = ($IncludeZipPlus4 -or $Format -eq "Plus4")
        $result.ZipRange = @{ Start = $zipRange.Start; End = $zipRange.End }

        return $result
    }
    else {
        # SingleLine format with state information
        if ($IncludeState) {
            switch ($Format) {
                "StateFirst" {
                    return "$($selectedState.Abbr) $zipCode"
                }
                "Plus4" {
                    if (-not $zipCode.Contains("-")) {
                        $plus4 = Get-Random -Minimum 1000 -Maximum 9999
                        $zipCode = "$zipCode-$plus4"
                    }
                    return "$zipCode, $($selectedState.Abbr)"
                }
                "Standard" {
                    return "$zipCode, $($selectedState.Abbr)"
                }
                default {
                    return "$zipCode, $($selectedState.Abbr)"
                }
            }
        }
        else {
            # ZIP code only, apply format
            switch ($Format) {
                "Plus4" {
                    if (-not $zipCode.Contains("-")) {
                        $plus4 = Get-Random -Minimum 1000 -Maximum 9999
                        $zipCode = "$zipCode-$plus4"
                    }
                    return $zipCode
                }
                "Standard" {
                    # Remove any plus4 extension for standard format
                    if ($zipCode.Contains("-")) {
                        $zipCode = $zipCode.Split("-")[0]
                    }
                    return $zipCode
                }
                "StateFirst" {
                    # StateFirst without IncludeState doesn't make sense, so return standard
                    if ($zipCode.Contains("-")) {
                        $zipCode = $zipCode.Split("-")[0]
                    }
                    return $zipCode
                }
                default {
                    return $zipCode
                }
            }
        }
    }
}
