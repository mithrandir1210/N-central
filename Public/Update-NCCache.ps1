function Update-NCCache {
<#
.SYNOPSIS
    Updates the entire cache file or a property within the cache file depending on the parameters
    used.
    
.PARAMETER Path
    The full path to the cache file. If Connect-NCApi has already been run successfully, you can use
    $Global:ncCache for the path.

.PARAMETER Property
    A specific property to update or add to the cache file.

.PARAMETER Value
    A specific property value to update or add to the cache file.

.PARAMETER Force
    Forces a full refresh of the cache file.
    
.EXAMPLE
    
#>

[CmdletBinding(DefaultParameterSetName='UpdateAll')]
Param (
    [Parameter(Mandatory=$true, ParameterSetName='UpdateAll')]
    [Parameter(Mandatory=$true, ParameterSetName='UpdateProperty')]
    [string]
    $Path,

    [Parameter(Mandatory=$true, ParameterSetName='UpdateProperty')]
    [string]
    $Property,
    
    [Parameter(Mandatory=$true, ParameterSetName='UpdateProperty')]
    $Value,

    [Parameter(Mandatory=$false)]
    [switch]
    $Force
)

    $today = Get-Date

    # Create new cache if it doesn't exist or if a specific property is not requested (update all)
    if ($Force -or (! (Test-Path -Path $Path)) -or (! $Property)) {
        Write-Verbose 'Creating new cache object'
        $cache = New-Object -TypeName psobject -Property @{
            LastUpdate = $today;
            Customers = New-Object -TypeName psobject -Property @{
                LastUpdate = $today;
                Value = ((Get-NCCustomer -NoCacheUpdate) | Sort-Object -Property customerid);
            }
        }
    }

    if ($Property) {    
        # Import existing cache
        Write-Verbose "Importing existing cache from: [$Path]"
        $cache = Import-Clixml -Path $Path -ErrorAction Stop
    
        # If property exists, update. Add member otherwise
        if ($cache.$Property.Value) {
            Write-Verbose 'Updating existing cache property'
            $cache.$Property.Value = $Value
        } else {
            Write-Verbose "Cache property [$Property] not found. Adding property to cache object."
            $cache | Add-Member -MemberType NoteProperty -Name $Property -Value (New-Object -TypeName psobject -Property @{
                LastUpdate = $today;
                Value = $Value;
            }) -Force
        }
    } 

    # Export to file
    Write-Verbose "Exporting cache to: [$Path]"
    $cache | Export-Clixml -Path $Path -Force
}
