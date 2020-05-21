function Get-NCJobStatusList {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [int]
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