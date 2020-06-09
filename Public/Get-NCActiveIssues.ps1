function Get-NCActiveIssues {
<#
.SYNOPSIS
    Retrieves a list of all active issues and related information associated with the specified 
    Site, Customer, SO, or the entire system.
    
.PARAMETER CustomerId
    The ID of the Site, Customer, or SO for which to retrieve active issues for. Use 1 to return
    active issues for every SO, customer, and site.

.PARAMETER SearchBy
    A value to search the SO, site, device, deviceClass, service, transitionTime, notification, 
    features, deviceID, or ip address.

.PARAMETER OrderBy
    The column of the Active Issues table to order the results by.

.PARAMETER StatusFilter
    Filter by the monitoring status of the active issue.

.PARAMETER NotificationFilter
    Filter by the notification status of the active issue.

.PARAMETER ReverseOrder
    Reverse the sorting order.
    
.EXAMPLE
    

#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [uint64[]]
    $CustomerId = 1,

    [Parameter(Mandatory=$false)]
    [string]
    $SearchBy,

    [Parameter(Mandatory=$false)]
    [ValidateSet('customername', 'devicename', 'servicename', 'status', 'transitiontime', 'numberofacknoledgednotification',
            'serviceorganization', 'deviceclass', 'licensemode', 'endpointsecurity')]
    [string]
    $OrderBy = 'customername',

    [Parameter(Mandatory=$false)]
    [ValidateSet('no data', 'stale', 'normal', 'warning', 'failed', 'misconfigured', 'disconnected')]
    [string[]]
    $StatusFilter,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Acknowledged', 'Unacknowledged')]
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
    
        if ($queryData) {
            $results += Format-NCData -Data $queryData
        }
    }

    END {
        if ( ($results | Measure-Object).Count -gt 0 ) {
            return $results
        }
        
        return
    }

}