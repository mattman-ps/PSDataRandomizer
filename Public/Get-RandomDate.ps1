<#
.SYNOPSIS
    Generates a random date based on specified age categories or custom date ranges.

.DESCRIPTION
    This function generates random dates for different purposes:
    - Adult dates: People aged 18-85 years (default when no parameters specified)
    - Child dates: People aged 0-17 years
    - Custom: User-defined date range

.PARAMETER AdultDate
    Generate a date for an adult (18-85 years old)

.PARAMETER ChildDate
    Generate a date for a child (0-17 years old)

.PARAMETER CustomStartDate
    The earliest date in a custom range

.PARAMETER CustomEndDate
    The latest date in a custom range

.EXAMPLE
    Get-RandomDate
    # Returns a random date for an adult (18-85 years old) - default behavior

.EXAMPLE
    Get-RandomDate -AdultDate
    # Returns a random date for someone 18-85 years old

.EXAMPLE
    Get-RandomDate -ChildDate
    # Returns a random date for someone 0-17 years old

.EXAMPLE
    Get-RandomDate -CustomStartDate "1990-01-01" -CustomEndDate "2000-12-31"
    # Returns a random date between specified dates
#>

function Get-RandomDate {
    [CmdletBinding(DefaultParameterSetName = "Adult")]
    param (
        [Parameter(ParameterSetName = "Adult")]
        [switch]$AdultDate,

        [Parameter(ParameterSetName = "Child")]
        [switch]$ChildDate,

        [Parameter(ParameterSetName = "Custom", Mandatory = $true)]
        [datetime]$CustomStartDate,

        [Parameter(ParameterSetName = "Custom", Mandatory = $true)]
        [datetime]$CustomEndDate
    )

    # Determine date range based on parameters
    switch ($PSCmdlet.ParameterSetName) {
        "Custom" {
            # Use custom date range
            $startDate = $CustomStartDate
            $endDate = $CustomEndDate
        }
        "Adult" {
            # Adult: 18-85 years old (this is the default behavior)
            $StartYear = 85
            $EndYear = 18
            $startDate = (Get-Date).AddYears(-$StartYear)
            $endDate = (Get-Date).AddYears(-$EndYear)
        }
        "Child" {
            # Child: 0-17 years old
            $StartYear = 17
            $EndYear = 0
            $startDate = (Get-Date).AddYears(-$StartYear)
            $endDate = (Get-Date).AddYears(-$EndYear)
        }
    }

    # Validate date range
    if ($startDate -gt $endDate) {
        Write-Error "Start date cannot be later than end date"
        return
    }

    # Calculate random date
    $timeSpan = $endDate - $startDate
    $totalDays = $timeSpan.TotalDays

    $randomDays = Get-Random -Minimum 0 -Maximum $totalDays

    # Return the random date
    $randomDate = $startDate.AddDays($randomDays)
    return $randomDate
}
