function Get-NCAccessGroupList {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [int]
    $CustomerId = 50,

    [Parameter(Mandatory=$false)]
    [int]
    $Offset,

    [Parameter(Mandatory=$false)]
    [int]
    $Limit,

    [Parameter(Mandatory=$false)]
    [ValidateSet('groupname','groupid','grouptype','customerid','description','readonly','usernames')]
    [string]
    $OrderBy,

    [Parameter(Mandatory=$false)]
    [switch]
    $ReverseOrder
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'customerId' = $CustomerId;
    }

    if ($Offset) {
        $rawSettings.Add('offset', $Offset)
    }

    if ($Limit) {
        $rawSettings.Add('limit', $Limit)
    }

    if ($ReverseOrder) {
        $rawSettings.Add('reverseOrder', $ReverseOrder)
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    $queryData = $Global:ncConnection.accessGroupList($username, $password, $settings)

    return (Format-NCData -Data $queryData)
}