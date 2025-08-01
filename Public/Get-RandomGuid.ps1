<#
.SYNOPSIS
    Generates a random GUID (Globally Unique Identifier).

.DESCRIPTION
    This function generates random GUIDs in various formats. It can return standard
    GUIDs, uppercase/lowercase variants, with or without hyphens, and in different
    bracket styles commonly used in programming and configuration files.

.PARAMETER Format
    Output format: "Standard" (lowercase with hyphens), "Upper" (uppercase with hyphens),
    "Lower" (lowercase with hyphens), "NoHyphens" (no hyphens), "Brackets" (with curly brackets),
    "Parentheses" (with parentheses)

.PARAMETER IncludeBraces
    Include curly braces around the GUID (default: false)

.PARAMETER IncludeParentheses
    Include parentheses around the GUID (default: false)

.PARAMETER RemoveHyphens
    Remove hyphens from the GUID (default: false)

.PARAMETER AddressStyle
    Output style: "SingleLine" (GUID only), "MultiLine" (GUID with metadata)

.EXAMPLE
    Get-RandomGuid
    # Returns: a1b2c3d4-e5f6-7890-abcd-ef1234567890 (standard format - default)

.EXAMPLE
    Get-RandomGuid -Format "Upper"
    # Returns: A1B2C3D4-E5F6-7890-ABCD-EF1234567890

.EXAMPLE
    Get-RandomGuid -IncludeBraces
    # Returns: {a1b2c3d4-e5f6-7890-abcd-ef1234567890}

.EXAMPLE
    Get-RandomGuid -Format "NoHyphens"
    # Returns: a1b2c3d4e5f67890abcdef1234567890

.EXAMPLE
    Get-RandomGuid -AddressStyle "MultiLine"
    # Returns: @{ Guid = "a1b2c3d4-e5f6-7890-abcd-ef1234567890"; Format = "Standard"; Timestamp = [DateTime] }

.NOTES
    Generates cryptographically secure GUIDs suitable for unique identifiers.
    Default behavior returns standard lowercase GUID with hyphens.
#>

function Get-RandomGuid {
    [CmdletBinding()]
    param (
        [ValidateSet("Standard", "Upper", "Lower", "NoHyphens", "Brackets", "Parentheses")]
        [string]$Format = "Standard",

        [switch]$IncludeBraces,

        [switch]$IncludeParentheses,

        [switch]$RemoveHyphens,

        [ValidateSet("SingleLine", "MultiLine")]
        [string]$AddressStyle = "SingleLine"
    )

    # Generate a new GUID
    $guid = [System.Guid]::NewGuid()

    # Convert to string and apply initial formatting
    $guidString = switch ($Format) {
        "Upper" { $guid.ToString().ToUpper() }
        "Lower" { $guid.ToString().ToLower() }
        "NoHyphens" { $guid.ToString("N").ToLower() }
        "Brackets" { "{$($guid.ToString().ToLower())}" }
        "Parentheses" { "($($guid.ToString().ToLower()))" }
        "Standard" { $guid.ToString().ToLower() }
        default { $guid.ToString().ToLower() }
    }

    # Apply additional formatting based on switches
    if ($RemoveHyphens -and $Format -notin @("NoHyphens", "Brackets", "Parentheses")) {
        $guidString = $guidString.Replace("-", "")
    }

    if ($IncludeBraces -and $Format -notin @("Brackets")) {
        $guidString = "{$guidString}"
    }

    if ($IncludeParentheses -and $Format -notin @("Parentheses", "Brackets")) {
        $guidString = "($guidString)"
    }

    # Return based on address style
    if ($AddressStyle -eq "MultiLine") {
        $result = @{
            Guid = $guidString
            Format = $Format
            Timestamp = Get-Date
            OriginalGuid = $guid
        }

        # Add format-specific metadata
        if ($RemoveHyphens -or $Format -eq "NoHyphens") {
            $result.HasHyphens = $false
        } else {
            $result.HasHyphens = $true
        }

        if ($IncludeBraces -or $Format -eq "Brackets") {
            $result.HasBraces = $true
        } else {
            $result.HasBraces = $false
        }

        if ($IncludeParentheses -or $Format -eq "Parentheses") {
            $result.HasParentheses = $true
        } else {
            $result.HasParentheses = $false
        }

        return $result
    }
    else {
        return $guidString
    }
}
