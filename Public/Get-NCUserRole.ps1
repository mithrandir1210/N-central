function Get-NCUserRole {
<#
.SYNOPSIS
    Retrieves the data for a specified user role.
    
.PARAMETER UserRoleId
    The role ID for which to retrieve data for.

.PARAMETER CustomerId
    A customer ID for which role is retrieved. The customer ID is used to determine if role is 
    modifiable at this level or not.
    
.EXAMPLE
    
#>

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