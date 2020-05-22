function Get-NCCustomer {
<#
.SYNOPSIS
    Retrieves one or more customers.    
    
.PARAMETER CustomerId
    The customer ID to retrieve.

.PARAMETER CustomerName
    Retrieve customers by name. Wildcards are supported.

.PARAMETER ListSOs
    Retrieve the service organizations only.

.PARAMETER ListChildren
    Retrieve all customers and/or sites with a parentid equal to the customer ID provided.

.PARAMETER NoCacheUpdate
    Do not update the cache with the results. This should be used if calling the Update-NCCache
    function from within an N-central module function (internal use). If you are using this 
    function to manually update the cache, do not use this switch.
    
.EXAMPLE
    

#>

[CmdletBinding(DefaultParameterSetName='Default')]
Param (
    [Parameter(Mandatory=$true, ParameterSetName='ListChildren')]
    [Parameter(Mandatory=$false, ParameterSetName='Search')]
    [ValidateNotNullOrEmpty()]
    [uint64]
    $CustomerId,

    [Parameter(Mandatory=$false, ParameterSetName='Search')]
    [ValidateNotNullOrEmpty()]
    [string]
    $CustomerName,

    [Parameter(Mandatory=$false, ParameterSetName='List')]
    [switch]
    $ListSOs,

    [Parameter(Mandatory=$true, ParameterSetName='ListChildren')]
    [switch]
    $ListChildren,

    [Parameter(Mandatory=$false)]
    [switch]
    $NoCacheUpdate
)

    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{}

    if ($ListChildren) {
        $rawSettings.Add('customerId', $CustomerId)
    } elseif ($ListSOs) {
        $rawSettings.Add('listSOs', $ListSOs)
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings

    if ($ListChildren) {
        $queryData = $Global:ncConnection.customerListChildren($username, $password, $settings)
    } else {
        $queryData = $Global:ncConnection.customerList($username, $password, $settings)
    }

    $result = Format-NCData -Data $queryData

    if ((! $NoCacheUpdate) -and (! $ListChildren) -and (! $ListSOs)) {
        Update-NCCache -Path $Global:ncCache -Property Customers -Value $result
    }

    if ($CustomerName) {
        $result = Find-ObjectByProperty -InputObject $result -Property customername -Value $CustomerName
    }
    if ( (! $ListChildren) -and $CustomerId ) {
        $result = Find-ObjectByProperty -InputObject $result -Property customerid -Value $CustomerId
    }
 
    return $result
}
