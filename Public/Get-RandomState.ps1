<#
.SYNOPSIS
    Generates a random US state name and/or abbreviation.

.DESCRIPTION
    This function generates random US state information including full state names,
    abbreviations, and ZIP code ranges. It can return data in different formats
    based on the specified parameters.

.PARAMETER IncludeAbbreviation
    Include state abbreviation with the state name (default: false)

.PARAMETER IncludeZipRange
    Include ZIP code range information for the state (default: false)

.PARAMETER Format
    Output format: "Full" (full state name), "Abbreviation" (state abbr only), "Both" (name and abbr)

.PARAMETER AddressStyle
    Output style: "SingleLine" (all on one line), "MultiLine" (separate components)

.EXAMPLE
    Get-RandomState
    # Returns: California (full state name only - default)

.EXAMPLE
    Get-RandomState -IncludeAbbreviation
    # Returns: California (CA)

.EXAMPLE
    Get-RandomState -Format "Abbreviation"
    # Returns: CA

.EXAMPLE
    Get-RandomState -Format "Both"
    # Returns: California (CA)

.EXAMPLE
    Get-RandomState -IncludeZipRange -AddressStyle "MultiLine"
    # Returns: @{ Name = "California"; Abbr = "CA"; ZipRanges = @(@{Start = 90000; End = 96699}) }

.NOTES
    Generates realistic US state information suitable for testing and data generation.
    Default behavior returns full state name only.
#>

function Get-RandomState {
    [CmdletBinding()]
    param (
        [switch]$IncludeAbbreviation,

        [switch]$IncludeZipRange,

        [ValidateSet("Full", "Abbreviation", "Both")]
        [string]$Format = "Full",

        [ValidateSet("SingleLine", "MultiLine")]
        [string]$AddressStyle = "SingleLine"
    )

    # Get a random state
    $selectedState = Get-Random -InputObject $Global:States

    # If ZIP range information is not requested and single line format
    if (-not $IncludeZipRange -and $AddressStyle -eq "SingleLine") {
        switch ($Format) {
            "Abbreviation" {
                return $selectedState.Abbr
            }
            "Both" {
                return "$($selectedState.Name) ($($selectedState.Abbr))"
            }
            "Full" {
                if ($IncludeAbbreviation) {
                    return "$($selectedState.Name) ($($selectedState.Abbr))"
                }
                else {
                    return $selectedState.Name
                }
            }
            default {
                if ($IncludeAbbreviation) {
                    return "$($selectedState.Name) ($($selectedState.Abbr))"
                }
                else {
                    return $selectedState.Name
                }
            }
        }
    }

    # Handle MultiLine format or when ZIP range is requested
    if ($AddressStyle -eq "MultiLine") {
        $result = @{
            Name = $selectedState.Name
            Abbr = $selectedState.Abbr
        }

        if ($IncludeZipRange) {
            $result.ZipRanges = $selectedState.ZipRanges
        }

        return $result
    }
    else {
        # SingleLine with ZIP range information
        $stateInfo = switch ($Format) {
            "Abbreviation" { $selectedState.Abbr }
            "Both" { "$($selectedState.Name) ($($selectedState.Abbr))" }
            "Full" {
                if ($IncludeAbbreviation) {
                    "$($selectedState.Name) ($($selectedState.Abbr))"
                }
                else {
                    $selectedState.Name
                }
            }
            default {
                if ($IncludeAbbreviation) {
                    "$($selectedState.Name) ($($selectedState.Abbr))"
                }
                else {
                    $selectedState.Name
                }
            }
        }

        if ($IncludeZipRange) {
            $zipRangeText = $selectedState.ZipRanges | ForEach-Object { "$($_.Start)-$($_.End)" }
            return "$stateInfo [ZIP: $($zipRangeText -join ', ')]"
        }
        else {
            return $stateInfo
        }
    }
}