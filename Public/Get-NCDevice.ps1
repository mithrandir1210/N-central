function Get-NCDevice {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [int[]]
    $DeviceId,
    
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [int[]]
    $ApplianceId
)

    BEGIN {
        Confirm-NCConnection

        $argumentCount = $DeviceId.Count + $ApplianceId.Count
        if ($argumentCount -lt 1 -and (! $MyInvocation.ExpectingInput) ) {
            throw (New-Object -TypeName System.ArgumentException -ArgumentList "No arguments specified.")
        }
    
        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $rawSettings = @()
    }

    PROCESS {

        foreach ($id in $DeviceId) {
            $rawSettings += @{ 'deviceId' = $id; }
        }
    
        foreach ($id in $ApplianceId) {
            $rawSettings += @{ 'applianceId' = $id; }
        }
    }

    END {
        $settings = ConvertTo-NCSettings -Settings $rawSettings
        $queryData = $Global:ncConnection.deviceGet($username, $password, $settings)
    
        return (Format-NCData -Data $queryData)
    }

}