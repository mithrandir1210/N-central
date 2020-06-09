function Get-NCUserRoleList {
<#
.SYNOPSIS
    Retrieves a list of the user roles based on the customer ID attribute.    

.PARAMETER CustomerId
    A valid customer or site ID.

.PARAMETER Offset
    Number determining first role that should be returned.

.PARAMETER Limit
    Number determining the number of results returned.

.PARAMETER OrderBy
    The sorting order the results are returned in.

.PARAMETER ReverseOrder
    Reverse the sorting order.
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [uint64]
    $CustomerId = 50,

    [Parameter(Mandatory=$false)]
    [uint64]
    $Offset = 0,

    [Parameter(Mandatory=$false)]
    [uint64]
    $Limit = 0,

    [Parameter(Mandatory=$false)]
    [ValidateSet('roleid','rolename','description','readonly','usernames','permissions')]
    [string]
    $OrderBy = 'rolename',

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

    $queryData = $Global:ncConnection.userRoleList($username, $password, $settings)

    if ($queryData) {
        $results = Format-NCData -Data $queryData
    }

    return $results
}