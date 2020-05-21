function Import-NCCache {
<#
.SYNOPSIS
    Imports the data within the cahce file  
    
.DESCRIPTION
    Retrieve the 
    
.PARAMETER
    
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [string]
    $Path,

    [Parameter(Mandatory=$false)]
    [string[]]
    $Property,

    [Parameter(Mandatory=$false)]
    [uint64]
    # Hours
    $Age = 24
)

    $expiration = (Get-Date).AddHours($AgeInHours)

    $cache = Import-Clixml -Path $Path -ErrorAction Stop

    if ($Property) {
        if ($cache.$Property.LastUpdate -lt $expiration) {
            return $cache.$Property.Value
        }
    } elseif ($cache.LastUpdate -lt $expiration) {
        return $cache
    }

    Write-Verbose "Cache age exceeds expiration date: [$expiration]"
    return $null
}
