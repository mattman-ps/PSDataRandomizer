<#
.SYNOPSIS
    Generates a random person with first name, middle name, last name, and full name.

.DESCRIPTION
    This function generates random person names using the NameIT module. It can generate names
    from various cultures or use a specific culture. The function returns a hashtable with
    individual name components and the full name.

.PARAMETER Culture
    Specify a specific culture for name generation. If not provided, a random culture will be selected.
    Examples: "en-US", "fr-FR", "de-DE", "es-ES"

.PARAMETER IncludeMiddleName
    Include a middle name in the generated person. If not specified, middle name will be included by default.

.PARAMETER IncludeCultureInfo
    Include culture information in the returned object (default: false)

.EXAMPLE
    Get-RandomPerson
    # Returns: @{FirstName="John"; LastName="Smith"; MiddleName="Michael"; FullName="John Michael Smith"}

.EXAMPLE
    Get-RandomPerson -Culture "en-US" -IncludeCultureInfo
    # Returns person with US English names and culture information

.EXAMPLE
    Get-RandomPerson -IncludeMiddleName:$false
    # Returns person without middle name

.NOTES
    Requires the NameIT PowerShell module to be installed.
    Install with: Install-Module -Name NameIT
#>

function Get-RandomPerson {
    [CmdletBinding()]
    param (
        [string]$Culture,

        [switch]$IncludeMiddleName,

        [switch]$IncludeCultureInfo
    )

    # Set default behavior for IncludeMiddleName if not explicitly specified
    if (-not $PSBoundParameters.ContainsKey('IncludeMiddleName')) {
        $IncludeMiddleName = $true  # Default to including middle names
    }

    # Determine culture to use
    if ($Culture) {
        try {
            $selectedCulture = Get-Culture -Name $Culture -ErrorAction Stop
        }
        catch {
            Write-Warning "Culture '$Culture' not found. Using random culture instead."
            $selectedCulture = Get-Random -InputObject (Get-Culture -ListAvailable)
        }
    }
    else {
        $selectedCulture = Get-Random -InputObject (Get-Culture -ListAvailable)
    }

    # Generate names using NameIT (module should already be loaded)
    try {
        $primaryName = Invoke-Generate "[person]" -Culture $selectedCulture

        if ($IncludeMiddleName) {
            $secondaryName = Invoke-Generate "[person]" -Culture $selectedCulture
        }
    }
    catch {
        Write-Error "Failed to generate names using NameIT module: $($_.Exception.Message)"
        return
    }

    # Parse name components
    $nameComponents = $primaryName -split " "
    $firstName = $nameComponents[0]
    $lastName = if ($nameComponents.Length -gt 1) { $nameComponents[1] } else { "Unknown" }

    $middleName = if ($IncludeMiddleName -and $secondaryName) {
        ($secondaryName -split " ")[0]
    }
    else {
        $null
    }

    # Build full name
    $fullName = if ($middleName) {
        "$firstName $middleName $lastName"
    }
    else {
        "$firstName $lastName"
    }

    # Create result object
    $result = @{
        FirstName  = $firstName
        LastName   = $lastName
        MiddleName = $middleName
        FullName   = $fullName
    }

    # Add middle name if included
    if ($IncludeMiddleName) {
        $result.MiddleName = $middleName
    }

    # Add culture information if requested
    if ($IncludeCultureInfo) {
        $result.Culture = $selectedCulture.Name
        $result.CultureDisplayName = $selectedCulture.DisplayName
    }

    return $result
}
