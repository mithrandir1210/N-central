function Set-NCDeviceProperty {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true, ParameterSetName='Set1')]
    [uint64[]]
    $DeviceId,

    [Parameter(Mandatory=$true, ParameterSetName='Set2')]
    [string[]]
    $DeviceName,

    [Parameter(Mandatory=$true, ParameterSetName='Set3')]
    [uint64[]]
    $FilterId,

    [Parameter(Mandatory=$true, ParameterSetName='Set4')]
    [string[]]
    $FilterName,

    [Parameter(Mandatory=$true)]
    $Label,

    [Parameter(Mandatory=$true)]
    $Value
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    # Get current device properties
    $deviceList = $Global:ncConnection.devicePropertyList($username, $password, $DeviceId, $DeviceName, $FilterId, $FilterName, $false)

    # Iterate through devices in list (could be more than one in list)
    foreach ($device in $deviceList) {

        # Iterate through properties, find the correct label, and set the related value
        foreach ($prop in $device.properties) {
            if ($prop.label -like $Label) {
                $prop.value = $Value
                break
            }
        }

    }

    # Make API call to set the value
    $Global:ncConnection.devicePropertyModify($username, $password, $deviceList)
}