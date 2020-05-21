function Get-NCCustomer {
[CmdletBinding(DefaultParameterSetName=' ')]
Param (
    [Parameter(Mandatory=$true, ParameterSetName='ListChildren')]
    [Parameter(Mandatory=$false, ParameterSetName='Search')]
    [int]
    $CustomerId,

    [Parameter(Mandatory=$false, ParameterSetName='Search')]
    [string]
    $CustomerName,

    [Parameter(Mandatory=$false, ParameterSetName='List')]
    [switch]
    $ListSOs,

    [Parameter(Mandatory=$true, ParameterSetName='ListChildren')]
    [switch]
    $ListChildren
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
    Update-NCCache -Path $Global:ncCache -Property Customers -Value $result

    if ($CustomerName) {
        $result = Find-ObjectByProperty -InputObject $result -Property customername -Value $CustomerName
    }
    if ( (! $ListChildren) -and $CustomerId ) {
        $result = Find-ObjectByProperty -InputObject $result -Property customerid -Value $CustomerId
    }
 
    return $result
}
