function Import-NCCache {
<#
.SYNOPSIS
    Retrieves some or all of the data within the cache file.
    
.DESCRIPTION
    Retrieves some or all of the data within the cache file. 
    
.PARAMETER Path
    The full path to the XML cache file.

.PARAMETER Property
    Only retrieve the data within the specified property from the cache.

.PARAMETER Age
    The age in hours for which to retrieve data from the cache. If the data you are trying to 
    retrieve has not been updated in the amount of time specified, no data will be returned.
    
.EXAMPLE
    $cacheData = Import-NCCache -Path $Global:ncCache -Age 12

    Save the entire cache to the $cacheData variable if the entire cache has been updated in the 
    last 12 hours.

.EXAMPLE 
    $cacheData = Import-NCCache -Path $Global:ncCache -Property Customers -Age 24

    Save the Customers property of the cache to the $cacheData variable if it has been updated in 
    the last 24 hours.
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path = $Global:ncCache,

    [Parameter(Mandatory=$false)]
    [string]
    $Property,

    [Parameter(Mandatory=$false)]
    [int]
    $Age = 24
)

    if (! $Global:ncCacheEnabled) {
        Write-Verbose 'Cache is disabled.'
        return
    }

    $expiration = (Get-Date).AddHours($AgeInHours)

    $cache = Import-Clixml -Path $Path -ErrorAction Stop

    if ($Property) {
        if ($cache.$Property.LastUpdate -lt $expiration) {
            return $Property
        }
    } elseif ($cache.LastUpdate -lt $expiration) {
        return $cache
    }

    Write-Verbose "Cache age exceeds expiration date: [$expiration]"
    return $null
}
