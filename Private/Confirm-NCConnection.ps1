function Confirm-NCConnection {
<#
.SYNOPSIS
    Helper function to verify Connect-NCApi was run successfully before calling other functions.    
#>

    if (! $Global:ncConnection) {
        throw 'Not connected to N-central API. Run Connect-NCApi first.'
    } 
}