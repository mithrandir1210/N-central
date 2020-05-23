function Start-NCTaskMonitoring {
<#
.SYNOPSIS
    Resumes paused tasks with the specified task IDs.  
    
.PARAMETER TaskId
    One or more task IDs to start/resume.
    
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

    $queryData = $Global:ncConnection.taskResumeMonitoring($username, $password, $TaskId)

    return (Format-NCData -Data $queryData)
}