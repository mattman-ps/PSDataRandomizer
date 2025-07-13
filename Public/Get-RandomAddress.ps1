<#
.SYNOPSIS
    Generates a random realistic address with optional city, state, and ZIP code components.

.DESCRIPTION
    This function generates random addresses using realistic street names, types, and numbers.
    By default, it returns only the street address. City, state, and ZIP code components
    are optional and must be explicitly requested.

.PARAMETER IncludeApartment
    Include apartment, suite, or unit numbers (default: 25% chance)

.PARAMETER IncludeDirection
    Include directional prefixes like N, S, E, W, NE, etc. (default: 30% chance)

.PARAMETER IncludeCity
    Include city name (default: false)

.PARAMETER IncludeState
    Include state name and abbreviation (default: false)

.PARAMETER IncludeZip
    Include ZIP code (default: false)

.PARAMETER IncludeZipPlus4
    Include ZIP+4 extension codes when ZIP is included (default: 40% chance when ZIP enabled)

.PARAMETER StreetNumberRange
    Range for street numbers. Options: "Low" (1-999), "Medium" (100-9999), "High" (1000-99999)

.PARAMETER Format
    Output format: "Full" (complete address), "StreetOnly" (no apt/suite), "Compact" (abbreviated)

.PARAMETER AddressStyle
    Address layout: "SingleLine" (all on one line), "MultiLine" (separate components)

.EXAMPLE
    Get-RandomAddress
    # Returns: 1847 Maple Street (street address only - default)

.EXAMPLE
    Get-RandomAddress -IncludeCity -IncludeState -IncludeZip
    # Returns: 1847 Maple Street, Springfield, IL 62701

.EXAMPLE
    Get-RandomAddress -IncludeApartment -IncludeDirection
    # Returns: 2156 N Oak Avenue, Apt 3B (street address with apartment and direction)

.EXAMPLE
    Get-RandomAddress -Format "Compact" -IncludeCity -IncludeState -IncludeZip
    # Returns: 15847 Pine St, Austin, TX 78701

.NOTES
    Generates realistic addresses suitable for testing and data generation.
    Default behavior returns street address only without city, state, or ZIP.
#>

function Get-RandomAddress {
    [CmdletBinding()]
    param (
        [switch]$IncludeApartment,

        [switch]$IncludeDirection,

        [switch]$IncludeCity,

        [switch]$IncludeState,

        [switch]$IncludeZip,

        [switch]$IncludeZipPlus4,

        [ValidateSet("Low", "Medium", "High")]
        [string]$StreetNumberRange = "Medium",

        [ValidateSet("Full", "StreetOnly", "Compact")]
        [string]$Format = "Full",

        [ValidateSet("SingleLine", "MultiLine")]
        [string]$AddressStyle = "SingleLine"
    )

    # Street number ranges
    $streetNumber = switch ($StreetNumberRange) {
        "Low" { Get-Random -Minimum 1 -Maximum 999 }
        "Medium" { Get-Random -Minimum 100 -Maximum 9999 }
        "High" { Get-Random -Minimum 1000 -Maximum 99999 }
        default { Get-Random -Minimum 100 -Maximum 9999 }
    }

    # Apartment/Suite types and numbers
    $unitTypes = @(
        @{ Type = "Apt"; Numbers = @(1..999) + @("A", "B", "C", "D", "1A", "1B", "2A", "2B", "3A", "3B") },
        @{ Type = "Suite"; Numbers = @(100..999) + @("A", "B", "C", "101A", "102B", "201A") },
        @{ Type = "Unit"; Numbers = @(1..500) + @("A", "B", "C", "D", "E") },
        @{ Type = "#"; Numbers = @(1..999) + @("A", "B", "C") }
    )

    # Generate basic address components
    $streetName = Get-Random -InputObject $$Global:StreetNames
    $streetType = Get-Random -InputObject $$Global:StreetTypes

    # Determine if we include direction (30% chance by default, 100% if forced)
    $includeDir = $IncludeDirection -or ((Get-Random -Maximum 100) -lt 30)
    $direction = if ($includeDir) { Get-Random -InputObject $Global:Directions } else { $null }

    # Determine if we include apartment (25% chance by default, 100% if forced)
    $includeApt = $IncludeApartment -or ((Get-Random -Maximum 100) -lt 25)
    $unitInfo = if ($includeApt) {
        $unitType = Get-Random -InputObject $unitTypes
        $unitNumber = Get-Random -InputObject $unitType.Numbers
        @{ Type = $unitType.Type; Number = $unitNumber }
    }
    else { $null }

    # Build the street address based on format
    $streetAddress = switch ($Format) {
        "Compact" {
            $typeText = $streetType.Abbr
            $dirText = if ($direction) { "$direction " } else { "" }
            $unitText = if ($unitInfo) { ", $($unitInfo.Type) $($unitInfo.Number)" } else { "" }
            "$streetNumber $dirText$streetName $typeText$unitText"
        }
        "StreetOnly" {
            $typeText = $streetType.Full
            $dirText = if ($direction) { "$direction " } else { "" }
            "$streetNumber $dirText$streetName $typeText"
        }
        "Full" {
            $typeText = $streetType.Full
            $dirText = if ($direction) { "$direction " } else { "" }
            $unitText = if ($unitInfo) { ", $($unitInfo.Type) $($unitInfo.Number)" } else { "" }
            "$streetNumber $dirText$streetName $typeText$unitText"
        }
        default {
            $typeText = $streetType.Full
            $dirText = if ($direction) { "$direction " } else { "" }
            $unitText = if ($unitInfo) { ", $($unitInfo.Type) $($unitInfo.Number)" } else { "" }
            "$streetNumber $dirText$streetName $typeText$unitText"
        }
    }

    # Only generate city/state/ZIP if explicitly requested
    if ($IncludeCity -or $IncludeState -or $IncludeZip) {

        $selectedState = Get-Random -InputObject $Global:States
        $city = Get-Random -InputObject $Global:CityNames

        # Generate ZIP code if requested
        $zipCode = if ($IncludeZip) {
            $zipRange = Get-Random -InputObject $selectedState.ZipRanges
            $zip = Get-Random -Minimum $zipRange.Start -Maximum $zipRange.End

            # Add ZIP+4 if requested
            if ($IncludeZipPlus4) {
                $plus4 = Get-Random -Minimum 1000 -Maximum 9999
                "$zip-$plus4"
            }
            else {
                "$zip"
            }
        }
        else { "" }

        # Build city, state, ZIP components
        $addressParts = @()
        if ($IncludeCity) { $addressParts += $city }
        if ($IncludeState) { $addressParts += $selectedState.Abbr }
        if ($IncludeZip -and $zipCode) { $addressParts += $zipCode }

        $cityStateZip = $addressParts -join ", "

        # Return based on address style
        if ($AddressStyle -eq "MultiLine") {
            $result = @{
                Street = $streetAddress.Trim()
            }
            if ($cityStateZip) { $result.CityStateZip = $cityStateZip }
            if ($IncludeCity) { $result.City = $city }
            if ($IncludeState) {
                $result.State = $selectedState.Name
                $result.StateAbbr = $selectedState.Abbr
            }
            if ($IncludeZip -and $zipCode) { $result.ZipCode = $zipCode }
            return $result
        }
        else {
            # Single line format
            if ($cityStateZip) {
                return "$($streetAddress.Trim()), $cityStateZip"
            }
            else {
                return $streetAddress.Trim()
            }
        }
    }
    else {
        # Return street address only (default behavior)
        if ($AddressStyle -eq "MultiLine") {
            return @{ Street = $streetAddress.Trim() }
        }
        else {
            return $streetAddress.Trim()
        }
    }
}
