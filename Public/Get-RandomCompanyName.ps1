<#
.SYNOPSIS
    Generates a random realistic company name.
.DESCRIPTION
    This function generates random company names using realistic word combinations and business suffixes.
.PARAMETER IncludeSuffix
    Include a random business suffix in the company name (default: false)
.EXAMPLE
    Get-RandomCompanyName
    # Returns: Tech Solutions
.EXAMPLE
    Get-RandomCompanyName -IncludeSuffix
    # Returns: Tech Solutions LLC
#>

function Get-RandomCompanyName {
    [CmdletBinding()]
    param (
        [switch]$IncludeSuffix
    )

    $companyWords = @(
        "Tech", "Digital", "Solutions", "Systems", "Global", "International",
        "Enterprise", "Consulting", "Services", "Innovations", "Dynamics",
        "United", "Premier", "Advanced", "Smart", "Future", "Next", "Core",
        "Alpha", "Beta", "Gamma", "Delta", "Omega", "Prime", "Apex", "Peak",
        "Summit", "Bridge", "Connect", "Link", "Network", "Web", "Cloud",
        "Data", "Info", "Cyber", "Quantum", "Nano", "Micro", "Macro"
    )

    $businessTypes = @(
        "Corp", "Inc", "LLC", "Group", "Company", "Enterprises", "Industries",
        "Technologies", "Solutions", "Systems", "Consulting", "Services",
        "Partners", "Associates", "Ventures", "Holdings", "Dynamics",
        "Innovations", "Development", "Management", "Capital", "Resources"
    )

    $suffixes = @("Ltd.", "PLC", "LLP", "AG", "S.A.", "Pty Ltd", "GmbH")

    $word1 = Get-Random -InputObject $companyWords
    $word2 = Get-Random -InputObject $businessTypes
    $companyName = "$word1 $word2"

    if ($IncludeSuffix) {
        $suffix = Get-Random -InputObject $suffixes
        $companyName = "$companyName $suffix"
    }

    return $companyName
}
