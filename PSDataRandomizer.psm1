# Get public and private function definition files
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

$Global:StreetNames = @(
    # Color names
    "Blue", "Brown", "Golden", "Gray", "Green", "Red", "Rose", "Silver", "Violet", "White",

    # Common descriptive names
    "Central", "Church", "Eighth", "Fifth", "First", "Fourth", "Main", "Ninth", "Park", "School",
    "Second", "Seventh", "Sixth", "Tenth", "Third",

    "Brook", "Creek", "Dale", "Field", "Forest", "Garden", "Glen", "Hill", "Highland", "Hillside",
    "Lake", "Lakeside", "Meadow", "Mill", "Ridge", "River", "Riverside", "Spring", "Sunrise",
    "Sunset", "Summit", "Valley", "View", "Woodland",

    # Geographic features
    "Bay", "Beach", "Bluff", "Canyon", "Cliff", "Coast", "Desert", "Dune", "Harbor", "Island",
    "Mesa", "Mountain", "Peninsula", "Plains", "Point", "Prairie", "Rock", "Shore", "Stone",

    # Presidential/Historical
    "Adams", "Clay", "Franklin", "Grant", "Hamilton", "Jackson", "Jefferson", "Kennedy", "Lee",
    "Lincoln", "Madison", "Monroe", "Roosevelt", "Washington", "Webster", "Wilson",

    # Common tree names
    "Ash", "Beech", "Birch", "Cedar", "Cherry", "Chestnut", "Cottonwood", "Cypress", "Dogwood",
    "Elm", "Fir", "Hawthorn", "Hickory", "Juniper", "Magnolia", "Maple", "Mulberry", "Oak",
    "Pine", "Poplar", "Redwood", "Spruce", "Sycamore", "Walnut", "Willow"
)

# Street types with full and abbreviated forms (USPS Standard)
$Global:StreetTypes = @(
    @{ Full = "ALLEY"; Abbr = "ALY" },
    @{ Full = "ANEX"; Abbr = "ANX" },
    @{ Full = "ARCADE"; Abbr = "ARC" },
    @{ Full = "AVENUE"; Abbr = "AVE" },
    @{ Full = "BAYOU"; Abbr = "BYU" },
    @{ Full = "BEACH"; Abbr = "BCH" },
    @{ Full = "BEND"; Abbr = "BND" },
    @{ Full = "BLUFF"; Abbr = "BLF" },
    @{ Full = "BLUFFS"; Abbr = "BLFS" },
    @{ Full = "BOTTOM"; Abbr = "BTM" },
    @{ Full = "BOULEVARD"; Abbr = "BLVD" },
    @{ Full = "BRANCH"; Abbr = "BR" },
    @{ Full = "BRIDGE"; Abbr = "BRG" },
    @{ Full = "BROOK"; Abbr = "BRK" },
    @{ Full = "BROOKS"; Abbr = "BRKS" },
    @{ Full = "BURG"; Abbr = "BG" },
    @{ Full = "BURGS"; Abbr = "BGS" },
    @{ Full = "BYPASS"; Abbr = "BYP" },
    @{ Full = "CAMP"; Abbr = "CP" },
    @{ Full = "CANYON"; Abbr = "CYN" },
    @{ Full = "CAPE"; Abbr = "CPE" },
    @{ Full = "CAUSEWAY"; Abbr = "CSWY" },
    @{ Full = "CENTER"; Abbr = "CTR" },
    @{ Full = "CENTERS"; Abbr = "CTRS" },
    @{ Full = "CIRCLE"; Abbr = "CIR" },
    @{ Full = "CIRCLES"; Abbr = "CIRS" },
    @{ Full = "CLIFF"; Abbr = "CLF" },
    @{ Full = "CLIFFS"; Abbr = "CLFS" },
    @{ Full = "CLUB"; Abbr = "CLB" },
    @{ Full = "COMMON"; Abbr = "CMN" },
    @{ Full = "COMMONS"; Abbr = "CMNS" },
    @{ Full = "CORNER"; Abbr = "COR" },
    @{ Full = "CORNERS"; Abbr = "CORS" },
    @{ Full = "COURSE"; Abbr = "CRSE" },
    @{ Full = "COURT"; Abbr = "CT" },
    @{ Full = "COURTS"; Abbr = "CTS" },
    @{ Full = "COVE"; Abbr = "CV" },
    @{ Full = "COVES"; Abbr = "CVS" },
    @{ Full = "CREEK"; Abbr = "CRK" },
    @{ Full = "CRESCENT"; Abbr = "CRES" },
    @{ Full = "CREST"; Abbr = "CRST" },
    @{ Full = "CROSSING"; Abbr = "XING" },
    @{ Full = "CROSSROAD"; Abbr = "XRD" },
    @{ Full = "CROSSROADS"; Abbr = "XRDS" },
    @{ Full = "CURVE"; Abbr = "CURV" },
    @{ Full = "DALE"; Abbr = "DL" },
    @{ Full = "DAM"; Abbr = "DM" },
    @{ Full = "DIVIDE"; Abbr = "DV" },
    @{ Full = "DRIVE"; Abbr = "DR" },
    @{ Full = "DRIVES"; Abbr = "DRS" },
    @{ Full = "ESTATE"; Abbr = "EST" },
    @{ Full = "ESTATES"; Abbr = "ESTS" },
    @{ Full = "EXPRESSWAY"; Abbr = "EXPY" },
    @{ Full = "EXTENSION"; Abbr = "EXT" },
    @{ Full = "EXTENSIONS"; Abbr = "EXTS" },
    @{ Full = "FALL"; Abbr = "FALL" },
    @{ Full = "FALLS"; Abbr = "FLS" },
    @{ Full = "FERRY"; Abbr = "FRY" },
    @{ Full = "FIELD"; Abbr = "FLD" },
    @{ Full = "FIELDS"; Abbr = "FLDS" },
    @{ Full = "FLAT"; Abbr = "FLT" },
    @{ Full = "FLATS"; Abbr = "FLTS" },
    @{ Full = "FORD"; Abbr = "FRD" },
    @{ Full = "FORDS"; Abbr = "FRDS" },
    @{ Full = "FOREST"; Abbr = "FRST" },
    @{ Full = "FORGE"; Abbr = "FRG" },
    @{ Full = "FORGES"; Abbr = "FRGS" },
    @{ Full = "FORK"; Abbr = "FRK" },
    @{ Full = "FORKS"; Abbr = "FRKS" },
    @{ Full = "FORT"; Abbr = "FT" },
    @{ Full = "FREEWAY"; Abbr = "FWY" },
    @{ Full = "GARDEN"; Abbr = "GDN" },
    @{ Full = "GARDENS"; Abbr = "GDNS" },
    @{ Full = "GATEWAY"; Abbr = "GTWY" },
    @{ Full = "GLEN"; Abbr = "GLN" },
    @{ Full = "GLENS"; Abbr = "GLNS" },
    @{ Full = "GREEN"; Abbr = "GRN" },
    @{ Full = "GREENS"; Abbr = "GRNS" },
    @{ Full = "GROVE"; Abbr = "GRV" },
    @{ Full = "GROVES"; Abbr = "GRVS" },
    @{ Full = "HARBOR"; Abbr = "HBR" },
    @{ Full = "HARBORS"; Abbr = "HBRS" },
    @{ Full = "HAVEN"; Abbr = "HVN" },
    @{ Full = "HEIGHTS"; Abbr = "HTS" },
    @{ Full = "HIGHWAY"; Abbr = "HWY" },
    @{ Full = "HILL"; Abbr = "HL" },
    @{ Full = "HILLS"; Abbr = "HLS" },
    @{ Full = "HOLLOW"; Abbr = "HOLW" },
    @{ Full = "INLET"; Abbr = "INLT" },
    @{ Full = "ISLAND"; Abbr = "IS" },
    @{ Full = "ISLANDS"; Abbr = "ISS" },
    @{ Full = "ISLE"; Abbr = "ISLE" },
    @{ Full = "JUNCTION"; Abbr = "JCT" },
    @{ Full = "JUNCTIONS"; Abbr = "JCTS" },
    @{ Full = "KEY"; Abbr = "KY" },
    @{ Full = "KEYS"; Abbr = "KYS" },
    @{ Full = "KNOLL"; Abbr = "KNL" },
    @{ Full = "KNOLLS"; Abbr = "KNLS" },
    @{ Full = "LAKE"; Abbr = "LK" },
    @{ Full = "LAKES"; Abbr = "LKS" },
    @{ Full = "LAND"; Abbr = "LAND" },
    @{ Full = "LANDING"; Abbr = "LNDG" },
    @{ Full = "LANE"; Abbr = "LN" },
    @{ Full = "LIGHT"; Abbr = "LGT" },
    @{ Full = "LIGHTS"; Abbr = "LGTS" },
    @{ Full = "LOAF"; Abbr = "LF" },
    @{ Full = "LOCK"; Abbr = "LCK" },
    @{ Full = "LOCKS"; Abbr = "LCKS" },
    @{ Full = "LODGE"; Abbr = "LDG" },
    @{ Full = "LOOP"; Abbr = "LOOP" },
    @{ Full = "MALL"; Abbr = "MALL" },
    @{ Full = "MANOR"; Abbr = "MNR" },
    @{ Full = "MANORS"; Abbr = "MNRS" },
    @{ Full = "MEADOW"; Abbr = "MDW" },
    @{ Full = "MEADOWS"; Abbr = "MDWS" },
    @{ Full = "MEWS"; Abbr = "MEWS" },
    @{ Full = "MILL"; Abbr = "ML" },
    @{ Full = "MILLS"; Abbr = "MLS" },
    @{ Full = "MISSION"; Abbr = "MSN" },
    @{ Full = "MOTORWAY"; Abbr = "MTWY" },
    @{ Full = "MOUNT"; Abbr = "MT" },
    @{ Full = "MOUNTAIN"; Abbr = "MTN" },
    @{ Full = "MOUNTAINS"; Abbr = "MTNS" },
    @{ Full = "NECK"; Abbr = "NCK" },
    @{ Full = "ORCHARD"; Abbr = "ORCH" },
    @{ Full = "OVAL"; Abbr = "OVAL" },
    @{ Full = "OVERPASS"; Abbr = "OPAS" },
    @{ Full = "PARK"; Abbr = "PARK" },
    @{ Full = "PARKWAY"; Abbr = "PKWY" },
    @{ Full = "PARKWAYS"; Abbr = "PKWY" },
    @{ Full = "PASS"; Abbr = "PASS" },
    @{ Full = "PASSAGE"; Abbr = "PSGE" },
    @{ Full = "PATH"; Abbr = "PATH" },
    @{ Full = "PIKE"; Abbr = "PIKE" },
    @{ Full = "PINE"; Abbr = "PNE" },
    @{ Full = "PINES"; Abbr = "PNES" },
    @{ Full = "PLACE"; Abbr = "PL" },
    @{ Full = "PLAIN"; Abbr = "PLN" },
    @{ Full = "PLAINS"; Abbr = "PLNS" },
    @{ Full = "PLAZA"; Abbr = "PLZ" },
    @{ Full = "POINT"; Abbr = "PT" },
    @{ Full = "POINTS"; Abbr = "PTS" },
    @{ Full = "PORT"; Abbr = "PRT" },
    @{ Full = "PORTS"; Abbr = "PRTS" },
    @{ Full = "PRAIRIE"; Abbr = "PR" },
    @{ Full = "RADIAL"; Abbr = "RADL" },
    @{ Full = "RAMP"; Abbr = "RAMP" },
    @{ Full = "RANCH"; Abbr = "RNCH" },
    @{ Full = "RAPID"; Abbr = "RPD" },
    @{ Full = "RAPIDS"; Abbr = "RPDS" },
    @{ Full = "REST"; Abbr = "RST" },
    @{ Full = "RIDGE"; Abbr = "RDG" },
    @{ Full = "RIDGES"; Abbr = "RDGS" },
    @{ Full = "RIVER"; Abbr = "RIV" },
    @{ Full = "ROAD"; Abbr = "RD" },
    @{ Full = "ROADS"; Abbr = "RDS" },
    @{ Full = "ROUTE"; Abbr = "RTE" },
    @{ Full = "ROW"; Abbr = "ROW" },
    @{ Full = "RUE"; Abbr = "RUE" },
    @{ Full = "RUN"; Abbr = "RUN" },
    @{ Full = "SHOAL"; Abbr = "SHL" },
    @{ Full = "SHOALS"; Abbr = "SHLS" },
    @{ Full = "SHORE"; Abbr = "SHR" },
    @{ Full = "SHORES"; Abbr = "SHRS" },
    @{ Full = "SKYWAY"; Abbr = "SKWY" },
    @{ Full = "SPRING"; Abbr = "SPG" },
    @{ Full = "SPRINGS"; Abbr = "SPGS" },
    @{ Full = "SPUR"; Abbr = "SPUR" },
    @{ Full = "SPURS"; Abbr = "SPUR" },
    @{ Full = "SQUARE"; Abbr = "SQ" },
    @{ Full = "SQUARES"; Abbr = "SQS" },
    @{ Full = "STATION"; Abbr = "STA" },
    @{ Full = "STRAVENUE"; Abbr = "STRA" },
    @{ Full = "STREAM"; Abbr = "STRM" },
    @{ Full = "STREET"; Abbr = "ST" },
    @{ Full = "STREETS"; Abbr = "STS" },
    @{ Full = "SUMMIT"; Abbr = "SMT" },
    @{ Full = "TERRACE"; Abbr = "TER" },
    @{ Full = "THROUGHWAY"; Abbr = "TRWY" },
    @{ Full = "TRACE"; Abbr = "TRCE" },
    @{ Full = "TRACK"; Abbr = "TRAK" },
    @{ Full = "TRAFFICWAY"; Abbr = "TRFY" },
    @{ Full = "TRAIL"; Abbr = "TRL" },
    @{ Full = "TRAILER"; Abbr = "TRLR" },
    @{ Full = "TUNNEL"; Abbr = "TUNL" },
    @{ Full = "TURNPIKE"; Abbr = "TPKE" },
    @{ Full = "UNDERPASS"; Abbr = "UPAS" },
    @{ Full = "UNION"; Abbr = "UN" },
    @{ Full = "UNIONS"; Abbr = "UNS" },
    @{ Full = "VALLEY"; Abbr = "VLY" },
    @{ Full = "VALLEYS"; Abbr = "VLYS" },
    @{ Full = "VIADUCT"; Abbr = "VIA" },
    @{ Full = "VIEW"; Abbr = "VW" },
    @{ Full = "VIEWS"; Abbr = "VWS" },
    @{ Full = "VILLAGE"; Abbr = "VLG" },
    @{ Full = "VILLAGES"; Abbr = "VLGS" },
    @{ Full = "VILLE"; Abbr = "VL" },
    @{ Full = "VISTA"; Abbr = "VIS" },
    @{ Full = "WALK"; Abbr = "WALK" },
    @{ Full = "WALKS"; Abbr = "WALK" },
    @{ Full = "WALL"; Abbr = "WALL" },
    @{ Full = "WAY"; Abbr = "WAY" },
    @{ Full = "WAYS"; Abbr = "WAYS" },
    @{ Full = "WELL"; Abbr = "WL" },
    @{ Full = "WELLS"; Abbr = "WLS" }
)

$Global:Directions = @("N", "S", "E", "W", "NE", "NW", "SE", "SW", "North", "South", "East", "West")

$Global:States = @(
    @{ Name = "Alabama"; Abbr = "AL"; ZipRanges = @(@{Start = 35000; End = 36999 }) },
    @{ Name = "Alaska"; Abbr = "AK"; ZipRanges = @(@{Start = 99500; End = 99999 }) },
    @{ Name = "Arizona"; Abbr = "AZ"; ZipRanges = @(@{Start = 85000; End = 86999 }) },
    @{ Name = "Arkansas"; Abbr = "AR"; ZipRanges = @(@{Start = 71600; End = 72999 }) },
    @{ Name = "California"; Abbr = "CA"; ZipRanges = @(@{Start = 90000; End = 96699 }) },
    @{ Name = "Colorado"; Abbr = "CO"; ZipRanges = @(@{Start = 80000; End = 81999 }) },
    @{ Name = "Connecticut"; Abbr = "CT"; ZipRanges = @(@{Start = 6000; End = 6999 }) },
    @{ Name = "Delaware"; Abbr = "DE"; ZipRanges = @(@{Start = 19700; End = 19999 }) },
    @{ Name = "Florida"; Abbr = "FL"; ZipRanges = @(@{Start = 32000; End = 34999 }) },
    @{ Name = "Georgia"; Abbr = "GA"; ZipRanges = @(@{Start = 30000; End = 31999 }) },
    @{ Name = "Hawaii"; Abbr = "HI"; ZipRanges = @(@{Start = 96700; End = 96999 }) },
    @{ Name = "Idaho"; Abbr = "ID"; ZipRanges = @(@{Start = 83200; End = 83999 }) },
    @{ Name = "Illinois"; Abbr = "IL"; ZipRanges = @(@{Start = 60000; End = 62999 }) },
    @{ Name = "Indiana"; Abbr = "IN"; ZipRanges = @(@{Start = 46000; End = 47999 }) },
    @{ Name = "Iowa"; Abbr = "IA"; ZipRanges = @(@{Start = 50000; End = 52999 }) },
    @{ Name = "Kansas"; Abbr = "KS"; ZipRanges = @(@{Start = 66000; End = 67999 }) },
    @{ Name = "Kentucky"; Abbr = "KY"; ZipRanges = @(@{Start = 40000; End = 42999 }) },
    @{ Name = "Louisiana"; Abbr = "LA"; ZipRanges = @(@{Start = 70000; End = 71599 }) },
    @{ Name = "Maine"; Abbr = "ME"; ZipRanges = @(@{Start = 3900; End = 4999 }) },
    @{ Name = "Maryland"; Abbr = "MD"; ZipRanges = @(@{Start = 20600; End = 21999 }) },
    @{ Name = "Massachusetts"; Abbr = "MA"; ZipRanges = @(@{Start = 1000; End = 2799 }) },
    @{ Name = "Michigan"; Abbr = "MI"; ZipRanges = @(@{Start = 48000; End = 49999 }) },
    @{ Name = "Minnesota"; Abbr = "MN"; ZipRanges = @(@{Start = 55000; End = 56999 }) },
    @{ Name = "Mississippi"; Abbr = "MS"; ZipRanges = @(@{Start = 38600; End = 39999 }) },
    @{ Name = "Missouri"; Abbr = "MO"; ZipRanges = @(@{Start = 63000; End = 65999 }) },
    @{ Name = "Montana"; Abbr = "MT"; ZipRanges = @(@{Start = 59000; End = 59999 }) },
    @{ Name = "Nebraska"; Abbr = "NE"; ZipRanges = @(@{Start = 68000; End = 69999 }) },
    @{ Name = "Nevada"; Abbr = "NV"; ZipRanges = @(@{Start = 89000; End = 89999 }) },
    @{ Name = "New Hampshire"; Abbr = "NH"; ZipRanges = @(@{Start = 3000; End = 3899 }) },
    @{ Name = "New Jersey"; Abbr = "NJ"; ZipRanges = @(@{Start = 7000; End = 8999 }) },
    @{ Name = "New Mexico"; Abbr = "NM"; ZipRanges = @(@{Start = 87000; End = 88999 }) },
    @{ Name = "New York"; Abbr = "NY"; ZipRanges = @(@{Start = 10000; End = 14999 }) },
    @{ Name = "North Carolina"; Abbr = "NC"; ZipRanges = @(@{Start = 27000; End = 28999 }) },
    @{ Name = "North Dakota"; Abbr = "ND"; ZipRanges = @(@{Start = 58000; End = 58999 }) },
    @{ Name = "Ohio"; Abbr = "OH"; ZipRanges = @(@{Start = 43000; End = 45999 }) },
    @{ Name = "Oklahoma"; Abbr = "OK"; ZipRanges = @(@{Start = 73000; End = 74999 }) },
    @{ Name = "Oregon"; Abbr = "OR"; ZipRanges = @(@{Start = 97000; End = 97999 }) },
    @{ Name = "Pennsylvania"; Abbr = "PA"; ZipRanges = @(@{Start = 15000; End = 19699 }) },
    @{ Name = "Rhode Island"; Abbr = "RI"; ZipRanges = @(@{Start = 2800; End = 2999 }) },
    @{ Name = "South Carolina"; Abbr = "SC"; ZipRanges = @(@{Start = 29000; End = 29999 }) },
    @{ Name = "South Dakota"; Abbr = "SD"; ZipRanges = @(@{Start = 57000; End = 57999 }) },
    @{ Name = "Tennessee"; Abbr = "TN"; ZipRanges = @(@{Start = 37000; End = 38599 }) },
    @{ Name = "Texas"; Abbr = "TX"; ZipRanges = @(@{Start = 75000; End = 79999 }) },
    @{ Name = "Utah"; Abbr = "UT"; ZipRanges = @(@{Start = 84000; End = 84999 }) },
    @{ Name = "Vermont"; Abbr = "VT"; ZipRanges = @(@{Start = 5000; End = 5999 }) },
    @{ Name = "Virginia"; Abbr = "VA"; ZipRanges = @(@{Start = 22000; End = 24699 }) },
    @{ Name = "Washington"; Abbr = "WA"; ZipRanges = @(@{Start = 98000; End = 99499 }) },
    @{ Name = "West Virginia"; Abbr = "WV"; ZipRanges = @(@{Start = 24700; End = 26999 }) },
    @{ Name = "Wisconsin"; Abbr = "WI"; ZipRanges = @(@{Start = 53000; End = 54999 }) },
    @{ Name = "Wyoming"; Abbr = "WY"; ZipRanges = @(@{Start = 82000; End = 83199 }) }
)

# Common city names
$Global:CommonCities = @(
    "Arlington", "Ashland", "Auburn", "Bakersfield", "Bristol", "Brooklyn", "Burlington",
    "Canton", "Centerville", "Chester", "Clayton", "Cleveland", "Clinton", "Columbia",
    "Concord", "Dayton", "Dover", "Escondido", "Fairfield", "Fairview", "Farmington",
    "Five Points", "Franklin", "Garden Grove", "Georgetown", "Greenville", "Hamilton",
    "Harrison", "Hayward", "Highland", "Hudson", "Jackson", "Kingston", "Lakewood",
    "Lebanon", "Lexington", "Lincoln", "Madison", "Manchester", "Marion", "Milford",
    "Milton", "Monroe", "Mount Pleasant", "Newton", "Oak Grove", "Oxford", "Pasadena",
    "Pleasant Valley", "Plymouth", "Pomona", "Portland", "Richmond", "Riverside",
    "Roseville", "Salinas", "Salem", "Santa Clara", "Santa Monica", "Santa Rosa",
    "Springfield", "Springdale", "Sunnyvale", "Torrance", "Troy", "Washington", "Wayne"
)

# PSDataRandomizer.psm1
# Check for required modules at module load time
$RequiredModules = @('NameIT')

foreach ($Module in $RequiredModules) {
    if (-not (Get-Module -ListAvailable -Name $Module)) {
        Write-Warning "Required module '$Module' is not installed. Install with: Install-Module -Name $Module"
        throw "Missing required module: $Module"
    }

    # Import the module if not already loaded
    if (-not (Get-Module -Name $Module)) {
        try {
            Import-Module -Name $Module -Force -ErrorAction Stop
            Write-Verbose "Successfully imported module: $Module"
        }
        catch {
            throw "Failed to import required module '$Module': $($_.Exception.Message)"
        }
    }
}

# Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    }
    catch {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
}

# Export public functions
Export-ModuleMember -Function $Public.BaseName