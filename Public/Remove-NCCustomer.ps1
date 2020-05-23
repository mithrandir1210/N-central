function Remove-NCCustomer {
<#
.SYNOPSIS
    Deletes an existing Customer from MSP N-central.
    
.PARAMETER CustomerId
    The customer ID to delete.
    
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
        'customerid' = $CustomerId;
    }

    $settings = ConvertTo-NCSettings -Settings $rawSettings
    
    # Make API call to delete the customer
    try {
        $result = $Global:ncConnection.customerDelete($username, $password, $settings)
    } catch {
        Write-Error $_.Exception.Message
    }

    return $result
}