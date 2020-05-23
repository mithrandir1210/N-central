function Stop-NCTaskMonitoring {
<#
.SYNOPSIS
    Pauses tasks with the specified task IDs.
    
.PARAMETER TaskId
    One or more task IDs to stop/pause.
    
.EXAMPLE
    
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [uint64[]]
    $TaskId
)
    Confirm-NCConnection

    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $queryData = $Global:ncConnection.taskPauseMonitoring($username, $password, $TaskId)

    return (Format-NCData -Data $queryData)
}