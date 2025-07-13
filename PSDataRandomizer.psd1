@{
    # Script module or binary module file associated with this manifest.
    RootModule           = 'PSDataRandomizer.psm1'

    # Version number of this module.
    ModuleVersion        = '1.0.0'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID                 = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'

    # Author of this module
    Author               = 'Matt Hilbert'

    # Company or vendor of this module
    CompanyName          = 'None'

    # Copyright statement for this module
    Copyright            = '(c) 2025. All rights reserved.'

    # Description of the functionality provided by this module
    Description          = 'PowerShell module for generating random data including addresses, dates, people, phone numbers, websites, and contact lists.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion    = '5.1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport    = @(
        'Get-RandomAddress',
        'Get-RandomDate',
        'Get-RandomPerson',
        'Get-RandomPhoneNumber',
        'Get-RandomWebsite',
        'New-RandomContactList'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport      = @()

    # Variables to export from this module
    VariablesToExport    = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport      = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData          = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Random', 'Data', 'Generator', 'Testing', 'Mock')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''
        }
    }

    # Required modules for this module to function
    RequiredModules      = @(
        @{ModuleName = 'NameIT'; ModuleVersion = '2.3.5' }
    )
}