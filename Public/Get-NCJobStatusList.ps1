function Get-NCJobStatusList {
<#
.SYNOPSIS
    Retrieves the data about job statuses based on the customer ID attribute.
    
.PARAMETER CustomerId
    A valid customer or site ID.
    
.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [uint64]
    $CustomerId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'customerId' = $CustomerId;
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    $queryData = $Global:ncConnection.jobStatusList($username, $password, $settings)

    return (Format-NCData -Data $queryData)
}