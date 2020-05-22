function Get-NCDeviceStatus {
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