function Get-NCDevicePropertyList {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [Alias('deviceid')]
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
            $results += Format-NCData -Data $queryData
        }
        
    }

    END {
        return $results
    }

}