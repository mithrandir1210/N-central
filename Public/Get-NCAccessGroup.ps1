function Get-NCAccessGroup {
<#
.SYNOPSIS
    Retrieves the data for the specified access group.

.PARAMETER GroupId
    A group ID for which to retrieve data for.

.PARAMETER CustomerId
    A customer ID the request is made for.

.PARAMETER CustomerGroup
    Determine if the group retrieved is customer or device access group. 
    
.EXAMPLE
    

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [uint64]
    $GroupId,

    [Parameter(Mandatory=$false)]
    [uint64]
    $CustomerId = 50,

    [Parameter(Mandatory=$false)]
    [switch]
    $CustomerGroup
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'groupId' = $GroupId;
        'customerId' = $CustomerId;
        'customerGroup' = $CustomerGroup;
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    try {
        $queryData = $Global:ncConnection.accessGroupGet($username, $password, $settings)
    } catch {
        Write-Warning "CustomerGroup was initially set to $CustomerGroup and triggered an exception. Trying again with the opposite value."
        if ($CustomerGroup) {
            $rawSettings.customerGroup = $false
            $settings = ConvertTo-NCSettings -Settings $rawSettings
        } else {
            $rawSettings.customerGroup = $true
            $settings = ConvertTo-NCSettings -Settings $rawSettings
        }

        $queryData = $Global:ncConnection.accessGroupGet($username, $password, $settings)
    }
    
    return (Format-NCData -Data $queryData)
}