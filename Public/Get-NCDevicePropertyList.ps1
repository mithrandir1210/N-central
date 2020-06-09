function Get-NCDevicePropertyList {
<#
.SYNOPSIS
    Retrieves a list of the custom device properties for the specified devices.
    
.PARAMETER DeviceId
    One or more device IDs for which to retrieve custom device properties for.

.PARAMETER DeviceName
    One or more device names for which to retrieve custom device properties for.

.PARAMETER FilterId
    One or more filter IDs for which to retrieve custom device properties for.

.PARAMETER FilterName
    One or more filter names for which to retrieve custom device properties for.

.PARAMETER ReverseOrder
    Reverse the sorting order (alphabetically).
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [uint64[]]
    $DeviceId,

    [Parameter(Mandatory=$false)]
    [Alias('longname')]
    [string[]]
    $DeviceName,

    [Parameter(Mandatory=$false)]
    [uint64[]]
    $FilterId,

    [Parameter(Mandatory=$false)]
    [string[]]
    $FilterName,

    [Parameter(Mandatory=$false)]
    [switch]
    $ReverseOrder
)
    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password
        
        $results = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {

        foreach ($id in $DeviceId) {
            $queryData = $Global:ncConnection.devicePropertyList($username, $password, $id, $DeviceName, $FilterId, $FilterName, $ReverseOrder)
            if ($queryData) {
                $results += Format-NCData -Data $queryData
            }
        }
        
    }

    END {
        if ( ($results | Measure-Object).Count -gt 0) {
            return $results
        }
        
        return
    }

}