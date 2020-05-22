function Get-NCDeviceAssetInfo {
<#
.SYNOPSIS
    Retrieves asset information about all of the devices that are associated with a PSA or an 
    MSP N-central sign-in.
    
.PARAMETER Version
    The type of PSA credentials are to be used (PSA or N-central).

.PARAMETER TargetByDeviceId
    Retrieve asset data by device ID.

.PARAMETER TargetByDeviceName
    Retrieve asset data by device name (longname).

.PARAMETER TargetByFilterId
    Retrieve asset data by filter ID.

.PARAMETER TargetByFilterName
    Retrieve asset data by filter name.

.PARAMETER TargetByTimestamp
    Retrieve asset data by timestamp.

.PARAMETER Include
    Categories of asset information to include.

.PARAMETER Exclude
    Categories of asset information to exclude.

.PARAMETER ReturnAsLinkToFile
    Request asset data as link to a file to download.

.EXAMPLE


#>

[CmdletBinding(DefaultParameterSetName='Optional1')]
Param (
    [Parameter(Mandatory=$false)]
    [ValidateSet('N-central', 'ConnectWise', 'Autotask', 'Tigerpaw')]
    [string]
    $Version = 'N-central',

    [Parameter(Mandatory=$true, ParameterSetName='Optional1', ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [Alias('deviceid')]
    [uint64[]]
    $TargetByDeviceId,

    [Parameter(Mandatory=$true, ParameterSetName='Optional2', ValueFromPipelineByPropertyName=$true)]
    [Alias('longname')]
    [string[]]
    $TargetByDeviceName,

    [Parameter(Mandatory=$true, ParameterSetName='Optional3')]
    [uint64[]]
    $TargetByFilterId,

    [Parameter(Mandatory=$true, ParameterSetName='Optional4')]
    [string[]]
    $TargetByFilterName,

    [Parameter(Mandatory=$false)]
    [datetime]
    $TargetByTimestamp,

    [Parameter(Mandatory=$false)]
    [ValidateSet("asset.device", "asset.os", "asset.computersystem", "asset.processor", "asset.motherboard", "asset.raidcontroller", "asset.memory", 
            "asset.videocontroller", "asset.logicaldevice", "asset.physicaldrive", "asset.mappeddrive", "asset.mediaaccessdevice", "asset.networkadapter", 
            "asset.usbdevice", "asset.printer", "asset.port", "asset.service", "asset.application", "asset.patch", "asset.customer", "asset.socustomer")]
    [string[]]
    $Include,

    [Parameter(Mandatory=$false)]
    [ValidateSet("asset.device", "asset.os", "asset.computersystem", "asset.processor", "asset.motherboard", "asset.raidcontroller", "asset.memory", 
            "asset.videocontroller", "asset.logicaldevice", "asset.physicaldrive", "asset.mappeddrive", "asset.mediaaccessdevice", "asset.networkadapter", 
            "asset.usbdevice", "asset.printer", "asset.port", "asset.service", "asset.application", "asset.patch", "asset.customer", "asset.socustomer")]
    [string[]]
    $Exclude,

    [Parameter(Mandatory=$false)]
    [switch]
    $ReturnAsLinkToFile
)

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password
    
        switch ($Version) {
            'N-central' {
                $versionId = '0.0'
                break
            }
            'ConnectWise' {
                $versionId = '1.0'
                break
            }
            'Autotask' {
                $versionId = '2.0'
                break
            }
            'Tigerpaw' {
                $versionId = '3.0'
                break
            }
            Default {
                $versionId = '0.0'
                break
            }
        }

        $targetList = @()
    }

    PROCESS {

        if ($TargetByDeviceId) {
            foreach ($id in $TargetByDeviceId) {
                $targetList += $id
            }
        } elseif ($TargetByDeviceName) {
            foreach ($name in $TargetByDeviceName) {
                $targetList += $name
            }
        } elseif ($TargetByFilterId) {
            foreach ($id in $TargetByFilterId) {
                $targetList += $id
            }
        } elseif ($TargetByFilterName) {
            foreach ($name in $TargetByFilterName) {
                $targetList += $name
            }
        } 
    }

    END {
        $rawSettings = @{}

        if ($TargetByDeviceId) {
            $rawSettings = @{'TargetByDeviceID' = $targetList}
        } elseif ($TargetByDeviceName) {
            $rawSettings = @{'TargetByDeviceName' = $targetList}
        } elseif ($TargetByFilterId) {
            $rawSettings = @{'TargetByFilterID' = $targetList}
        } elseif ($TargetByFilterName) {
            $rawSettings = @{'TargetByFilterName' = $targetList}
        } 
        
        if ($TargetByTimestamp) {
            $formattedDate = Get-Date -Date $date -Format 'yyyy-MM-dd hh:mm:ss'
            $rawSettings = @{'TargetByTimestamp' = $formattedDate}
        }

        if ($Include) {
            $rawSettings.Add("InformationCategoriesInclusion", $Include)
        } elseif ($Exclude) {
            $rawSettings.Add("InformationCategoriesExclusion", $Exclude)
        }
    
        if ($ReturnAsLinkToFile) {
            $rawSettings.Add("ReturnAsLinkToFile", $true)
        }
    
        $settings = ConvertTo-NCSettings -Settings $rawSettings -Type "tKeyValue"
    
        $queryData = $Global:ncConnection.deviceAssetInfoExportDeviceWithSettings($versionId, $username, $password, $settings)
    
        return (Format-NCData -Data $queryData)
    }

}