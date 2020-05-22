function Get-NCDevice {
<#
.SYNOPSIS  
    Retrieves a one or more user-specified devices.

.PARAMETER DeviceId
    One or more device IDs for which to retrieve data for.

.PARAMETER ApplianceId
    One or more appliance IDs for which to retrieve data for.
    
.EXAMPLE
    

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [uint64[]]
    $DeviceId,
    
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [uint64[]]
    $ApplianceId
)

    BEGIN {
        Confirm-NCConnection

        $argumentCount = $DeviceId.Count + $ApplianceId.Count
        if ($argumentCount -lt 1 -and (! $MyInvocation.ExpectingInput) ) {
            throw (New-Object -TypeName System.ArgumentException -ArgumentList "No arguments specified.")
        }
    
        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $rawSettings = @()
    }

    PROCESS {

        foreach ($id in $DeviceId) {
            $rawSettings += @{ 'deviceId' = $id; }
        }
    
        foreach ($id in $ApplianceId) {
            $rawSettings += @{ 'applianceId' = $id; }
        }
    }

    END {
        $settings = ConvertTo-NCSettings -Settings $rawSettings
        $queryData = $Global:ncConnection.deviceGet($username, $password, $settings)
    
        return (Format-NCData -Data $queryData)
    }

}