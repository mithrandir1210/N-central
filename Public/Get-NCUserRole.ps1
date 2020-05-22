function Get-NCUserRole {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [uint64]
    $UserRoleId,

    [Parameter(Mandatory=$false)]
    [uint64]
    $CustomerId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'userRoleId' = $UserRoleId;
    }

    if ($CustomerId) {
        $rawSettings.Add('customerId', $CustomerId)
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    $queryData = $Global:ncConnection.userRoleGet($username, $password, $settings)

    return (Format-NCData -Data $queryData)
}