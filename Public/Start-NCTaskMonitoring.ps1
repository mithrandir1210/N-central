function Start-NCTaskMonitoring {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [int[]]
    $TaskId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $queryData = $Global:ncConnection.taskResumeMonitoring($username, $password, $TaskId)

    return (Format-NCData -Data $queryData)
}