function Get-NCAccessGroupList {
<#
.SYNOPSIS
    Retrieves a list of the access groups based on the customerID attribute.
    
.PARAMETER CustomerId
    

.PARAMETER Offset
    Number determining first group that should be displayed. 

.PARAMETER Limit
    Number determining the number of results returned.

.PARAMETER OrderBy
    The sorting order the results are returned in.

.PARAMETER ReverseOrder
    Reverse the sorting order
    
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
    [ValidateSet('groupname','groupid','grouptype','customerid','description','readonly','usernames')]
    [string]
    $OrderBy = 'groupname',

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

    if ($queryData) {
        $results = Format-NCData -Data $queryData
    }

    return $results
}