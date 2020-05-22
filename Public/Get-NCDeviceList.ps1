function Get-NCDeviceList {
<#
.SYNOPSIS
    Retrieves a list of the devices based on the customer ID attribute.
    
.PARAMETER CustomerId
    A valid customer or site ID.

.PARAMETER IncludeDevices
    Whether or not devices should be included.

.PARAMETER IncludeProbes
    Whether or not probes should be included.
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [uint64[]]
    $CustomerId = 50,

    [Parameter(Mandatory=$false)]
    [bool]
    $IncludeDevices = $true,

    [Parameter(Mandatory=$false)]
    [bool]
    $IncludeProbes = $false
)

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $results = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {
        foreach ($id in $CustomerId) {
            $rawSettings = @{
                'customerId' = $id;
            }

            if ($IncludeDevices) {
                $rawSettings.Add('devices', $true)
            } else {
                $rawSettings.Add('devices', $false)
            }

            if ($IncludeProbes) {
                $rawSettings.Add('probes', $true)
            } else {
                $rawSettings.Add('probes', $false)
            }

            $settings = ConvertTo-NCSettings -Settings $rawSettings
        
            $queryData = $Global:ncConnection.DeviceList($username, $password, $settings)
    
            $results += Format-NCData -Data $queryData
        }
    }

    END {
        return $results
    }

}