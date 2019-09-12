# Generate various strings based on input
function Get-Typos()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Package,

        [Parameter(Mandatory=$true)]
        [ValidateSet("All", "CharacterSwapping","Omissions")]
        [string[]] $Types = "All"
    )

    write-verbose "Generate Typos with types: $Types"

    $Typos = @()

    #Permutations - character swapping
    if ($Types -contains "All" -or $Types -contains "CharacterSwapping")
    {
        $Typos += $Package[1]+$Package[0]+$($Package[2..$Package.Length] -join '')

        for ($i=0; $i -lt $Package.Length; $i++)
        {
            $Typos += $($Package[0..($i)] -join '') + $Package[$i+2]+$Package[$i+1] + $($Package[($i+3)..$Package.Length] -join '')
        }

        $Typos += $($Package[0..($Package.Length-3)] -join '')+$Package[$Package.Length-1]+$Package[($Package.Length)-2]
    }

    #Omissions
    if ($Types -contains "All" -or $Types -contains "Omissions")
    {
        $Typos += $($Package[1..$Package.Length] -join '')

        for ($i=0; $i -lt $Package.Length-2; $i++)
        {
            $Typos += $($Package[0..($i)] -join '') + $($Package[($i+2)..$Package.Length] -join '')
        }

        $Typos += $Package[0..($Package.Length-2)] -join ''
    }

    # XXX Double characters

    # XXX Similar looking

    # XXX Typos, e.g. r instead of e etc -> keyboard layout dependent

    $Typos = $Typos | Where-Object { $_ -ne $Package }
    $Typos | sort -u
}

function Find-TypoModule()
{

    [CmdletBinding(SupportsShouldProcess=$True,DefaultParameterSetName="Package")]
    param (
        [Parameter(ParameterSetName="File",Mandatory=$true)]
        [string]$Path,
        [Parameter(ParameterSetName="Package",Mandatory=$true)]
        [string]$Package
    )

    $Result = ""

    if ($Path -and !(Test-Path $Path))
    {
        write-error "Path $Path not found."
        Return
    }
    elseif ($Path)
    {
        $Packages = gc $Path
    }
    elseif ($Package)
    {
        $Packages = $Package
    }

    foreach ($Package in $Packages)
    {
        write-output "Check Package `"$Package`""

        $PackageTypos = Get-Typos $Package -Types All

        foreach ($PackageTypo in $PackageTypos)
        {
            # Check each typo name
            if ($pscmdlet.ShouldProcess($PackageTypo, "Check PowerShell gallery"))
            {
                write-output "   Check $PackageTypo"

                try {
                    Find-Module -Name "$PackageTypo" -erroraction stop
                    write-output "$PackageTypo found on PowerShell Gallery"
                }
                catch {}

            } # whatif
        } # foreach typo

        write-output "Checked $($PackageTypos.count) packages"

    } # foreach package
} # Find-TypoModule
