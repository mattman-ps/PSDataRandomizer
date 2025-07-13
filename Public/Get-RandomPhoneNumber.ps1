<#
.SYNOPSIS
    Generates a random NANP (North American Numbering Plan) phone number.

.DESCRIPTION
    This function generates random 10-digit phone numbers following the NANP format.
    It supports multiple output formats including standard, dashes, dots, spaces, and plain digits.

.PARAMETER Format
    The format for the phone number output:
    - Standard: (555) 123-4567
    - Dashes: 555-123-4567
    - Dots: 555.123.4567
    - Spaces: 555 123 4567
    - Plain: 5551234567

.EXAMPLE
    Get-RandomPhoneNumber
    # Returns: (555) 123-4567

.EXAMPLE
    Get-RandomPhoneNumber -Format "Dashes"
    # Returns: 555-123-4567

.EXAMPLE
    Get-RandomPhoneNumber -Format "Plain"
    # Returns: 5551234567
#>

function Get-RandomPhoneNumber {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("Standard", "Dashes", "Dots", "Spaces", "Plain")]
        [string]$Format = "Standard"
    )

    # Generate area code (200-999, excluding 800s, 900s for realism)
    do {
        $areaCode = Get-Random -Minimum 200 -Maximum 999
    } while ($areaCode -ge 800 -and $areaCode -le 899 -or $areaCode -ge 900 -and $areaCode -le 999)

    # Generate exchange code (200-999, first digit can't be 0 or 1)
    $exchangeCode = Get-Random -Minimum 200 -Maximum 999

    # Generate subscriber number (0000-9999)
    $subscriberNumber = Get-Random -Minimum 0 -Maximum 9999

    # Format the phone number based on the specified format
    switch ($Format) {
        "Standard" {
            return "($areaCode) $exchangeCode-$($subscriberNumber.ToString('0000'))"
        }
        "Dashes" {
            return "$areaCode-$exchangeCode-$($subscriberNumber.ToString('0000'))"
        }
        "Dots" {
            return "$areaCode.$exchangeCode.$($subscriberNumber.ToString('0000'))"
        }
        "Spaces" {
            return "$areaCode $exchangeCode $($subscriberNumber.ToString('0000'))"
        }
        "Plain" {
            return "$areaCode$exchangeCode$($subscriberNumber.ToString('0000'))"
        }
        default {
            return "($areaCode) $exchangeCode-$($subscriberNumber.ToString('0000'))"
        }
    }
}
