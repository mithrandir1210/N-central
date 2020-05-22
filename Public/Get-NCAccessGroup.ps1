function Get-NCAccessGroup {
<#
.SYNOPSIS
    Retrieves the access groups created at the specified customer level.
    
.DESCRIPTION
    
    
.PARAMETER
    
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [int]
    $GroupId,

    [Parameter(Mandatory=$false)]
    [int]
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