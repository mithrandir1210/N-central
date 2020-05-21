function Get-NCActiveIssues {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [int[]]
    $CustomerId = 50,

    [Parameter(Mandatory=$false)]
    [string]
    $SearchBy,

    [Parameter(Mandatory=$false)]
    [ValidateSet("customername", "devicename", "servicename", "status", "transitiontime", "numberofacknoledgednotification",
            "serviceorganization", "deviceclass", "licensemode", "endpointsecurity")]
    [string]
    $OrderBy,

    [Parameter(Mandatory=$false)]
    [ValidateSet("no data", "stale", "normal", "warning", "failed", "misconfigured", "disconnected")]
    [string[]]
    $StatusFilter,

    [Parameter(Mandatory=$false)]
    [ValidateSet("Acknowledged", "Unacknowledged")]
    [string]
    $NotificationFilter,

    [Parameter(Mandatory=$false)]
    [switch]
    $ReverseOrder
)  

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $results = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {
        $rawSettings = @{
            'customerid' = $CustomerId;
        }
    
        if ($SearchBy) {
            $rawSettings.Add('searchBy', $SearchBy)
        }
    
        if ($OrderBy) {
            $rawSettings.Add('orderBy', $OrderBy)
        }
    
        if ($ReverseOrder) {
            $rawSettings.Add('reverseOrder', $ReverseOrder)
        }
    
        if ($StatusFilter) {
            foreach ($filter in $StatusFilter) {
                $rawSettings.Add('NOC_View_Status_Filter', $filter)
            }
        }
    
        if ($NotificationFilter) {
            $rawSettings.Add('NOC_View_Notification_Acknowledgement_Filter', $NotificationFilter)
        }
    
        $settings = ConvertTo-NCSettings -Settings $rawSettings
    
        $queryData = $Global:ncConnection.activeIssuesList($username, $password, $settings)
    
        $results += Format-NCData -Data $queryData
    }

    END {
        return $results
    }

}