function Stop-NCTaskMonitoring {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [int[]]
    $TaskId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $queryData = $Global:ncConnection.taskPauseMonitoring($username, $password, $TaskId)

    return (Format-NCData -Data $queryData)
}