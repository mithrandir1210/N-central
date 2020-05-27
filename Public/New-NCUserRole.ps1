function New-NCUserRole {
<#
.SYNOPSIS
    Adds a new user role to MSP N-central.

.PARAMETER Name


.PARAMETER Description


.PARAMETER CustomerId


.PARAMETER PermissionId
    

.PARAMETER UserId
    

.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [ValidateLength(1,256)]
    [string]
    $Name,

    [Parameter(Mandatory=$true)]
    [string]
    $Description,

    [Parameter(Mandatory=$true)]
    [string]
    $CustomerId,

    [Parameter(Mandatory=$true)]
    [string]
    $PermissionId,

    [Parameter(Mandatory=$false)]
    [string]
    $UserId
)


}