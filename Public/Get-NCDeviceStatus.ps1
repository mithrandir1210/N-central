function Get-NCDeviceStatus {
<#
.SYNOPSIS
    Retrieves the status information of the components of a device that is displayed in the Status
    tab of the device in the N-central UI.  
    
.PARAMETER DeviceId
    One or more device IDs for which to retrieve the status.
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [uint64]
    $DeviceId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'deviceId' = $DeviceId;
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    $queryData = $Global:ncConnection.deviceGetStatus($username, $password, $settings)

    return (Format-NCData -Data $queryData)
}