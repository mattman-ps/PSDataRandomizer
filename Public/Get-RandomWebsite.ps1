<#
.SYNOPSIS
    Generates a random realistic website URL.

.DESCRIPTION
    This function generates random website URLs using realistic domain names,
    top-level domains, and optional paths. The generated URLs follow common
    web naming conventions.

.PARAMETER IncludePath
    Include a random path in the URL (default: false)

.PARAMETER IncludeSubdomain
    Include a random subdomain in the URL (default: false)

.PARAMETER Protocol
    The protocol to use (http, https, or none for domain only)

.EXAMPLE
    Get-RandomWebsite
    # Returns: example-company.com

.EXAMPLE
    Get-RandomWebsite -IncludePath -Protocol "https"
    # Returns: https://example-company.com/products

.EXAMPLE
    Get-RandomWebsite -IncludeSubdomain -Protocol "https"
    # Returns: https://www.example-company.com
#>

function Get-RandomWebsite {
    [CmdletBinding()]
    param (
        [switch]$IncludePath,

        [switch]$IncludeSubdomain,

        [ValidateSet("http", "https", "none")]
        [string]$Protocol = "none"
    )

    # Domain name components
    $companyWords = @(
        "tech", "digital", "solutions", "systems", "global", "international",
        "enterprise", "consulting", "services", "innovations", "dynamics",
        "united", "premier", "advanced", "smart", "future", "next", "core",
        "alpha", "beta", "gamma", "delta", "omega", "prime", "apex", "peak",
        "summit", "bridge", "connect", "link", "network", "web", "cloud",
        "data", "info", "cyber", "quantum", "nano", "micro", "macro"
    )

    $businessTypes = @(
        "corp", "inc", "llc", "group", "company", "enterprises", "industries",
        "technologies", "solutions", "systems", "consulting", "services",
        "partners", "associates", "ventures", "holdings", "dynamics",
        "innovations", "development", "management", "capital", "resources"
    )

    $tlds = @("com", "org", "net", "biz", "info", "co", "io", "tech", "online", "site")

    # Generate domain components
    $word1 = Get-Random -InputObject $companyWords
    $word2 = Get-Random -InputObject $businessTypes
    $tld = Get-Random -InputObject $tlds

    # Create domain name
    $domain = "$word1$word2.$tld"

    # Add subdomain if requested
    if ($IncludeSubdomain) {
        $subdomains = @("www", "app", "api", "blog", "shop", "store", "portal", "admin")
        $subdomain = Get-Random -InputObject $subdomains
        $domain = "$subdomain.$domain"
    }

    # Add protocol if specified
    $url = switch ($Protocol) {
        "http" { "http://$domain" }
        "https" { "https://$domain" }
        "none" { $domain }
        default { $domain }
    }

    # Add path if requested
    if ($IncludePath) {
        $paths = @(
            "products", "services", "about", "contact", "home", "blog",
            "news", "support", "help", "solutions", "resources", "pricing",
            "features", "downloads", "documentation", "api", "portal"
        )
        $path = Get-Random -InputObject $paths
        $url = "$url/$path"
    }

    # Ensure we always return a valid URL
    if ([string]::IsNullOrWhiteSpace($url)) {
        # Fallback website if generation fails
        $url = "example.com"
        if ($Protocol -eq "https") { $url = "https://$url" }
        if ($Protocol -eq "http") { $url = "http://$url" }
    }

    return $url
}
