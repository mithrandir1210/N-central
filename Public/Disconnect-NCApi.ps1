<#
.SYNOPSIS
    Nullifies all global variables created by Connect-NCApi.

.EXAMPLE
    Disconnect-NCApi
#>
function Disconnect-NCApi {
[CmdletBinding()]

    $Global:ncConnection = $null
    $Global:ncNamespace = $null
}
