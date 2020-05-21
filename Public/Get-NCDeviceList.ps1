function Get-NCDeviceList {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [int[]]
    $CustomerId = 50
)

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $results = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {
        foreach ($id in $CustomerId) {
            $rawSettings = @{
                'customerId' = $id;
            }

            $settings = ConvertTo-NCSettings -Settings $rawSettings
        
            $queryData = $Global:ncConnection.DeviceList($username, $password, $settings)
    
            $results += Format-NCData -Data $queryData
        }
    }

    END {
        return $results
    }

}