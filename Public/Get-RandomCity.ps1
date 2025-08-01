
<#
.SYNOPSIS
    Generates a random city name.

.DESCRIPTION
    This function generates a random city name from a predefined list of realistic city names.
    It can optionally include state information and return the data in different formats.

.PARAMETER IncludeState
    Include state name and abbreviation with the city (default: false)

.PARAMETER Format
    Output format: "Full" (city name), "WithState" (city, state), "Compact" (city, ST)

.PARAMETER AddressStyle
    Output style: "SingleLine" (all on one line), "MultiLine" (separate components)

.EXAMPLE
    Get-RandomCity
    # Returns: Springfield (city name only - default)

.EXAMPLE
    Get-RandomCity -IncludeState
    # Returns: Springfield, Illinois

.EXAMPLE
    Get-RandomCity -IncludeState -Format "Compact"
    # Returns: Springfield, IL

.EXAMPLE
    Get-RandomCity -IncludeState -AddressStyle "MultiLine"
    # Returns: @{ City = "Springfield"; State = "Illinois"; StateAbbr = "IL" }

.NOTES
    Generates realistic city names suitable for testing and data generation.
    Default behavior returns city name only without state information.
#>

function Get-RandomCity {
    [CmdletBinding()]
    param (
        [switch]$IncludeState,

        [ValidateSet("Full", "WithState", "Compact")]
        [string]$Format = "Full",

        [ValidateSet("SingleLine", "MultiLine")]
        [string]$AddressStyle = "SingleLine"
    )

    # Get a random city name
    $randomCity = Get-Random -InputObject $Global:CommonCities

    # If state information is not requested, return city only
    if (-not $IncludeState) {
        if ($AddressStyle -eq "MultiLine") {
            return @{ City = $randomCity }
        }
        else {
            return $randomCity
        }
    }

    # If state is requested, get a random state
    $selectedState = Get-Random -InputObject $Global:States

    # Build the result based on format
    switch ($Format) {
        "Compact" {
            $result = "$randomCity, $($selectedState.Abbr)"
        }
        "WithState" {
            $result = "$randomCity, $($selectedState.Name)"
        }
        "Full" {
            if ($IncludeState) {
                $result = "$randomCity, $($selectedState.Name)"
            }
            else {
                $result = $randomCity
            }
        }
        default {
            if ($IncludeState) {
                $result = "$randomCity, $($selectedState.Name)"
            }
            else {
                $result = $randomCity
            }
        }
    }

    # Return based on address style
    if ($AddressStyle -eq "MultiLine") {
        $multiLineResult = @{ City = $randomCity }
        if ($IncludeState) {
            $multiLineResult.State = $selectedState.Name
            $multiLineResult.StateAbbr = $selectedState.Abbr
        }
        return $multiLineResult
    }
    else {
        return $result
    }
}