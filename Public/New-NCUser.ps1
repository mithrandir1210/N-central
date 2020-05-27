function New-NCUser {
<#
.SYNOPSIS
    Adds a new user to MSP N-central.
    
.PARAMETER Email
    

.PARAMETER Password


.PARAMETER CustomerId


.PARAMETER FirstName


.PARAMETER LastName


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email


.PARAMETER Email
    

.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [string]
    $Email,

    [Parameter(Mandatory=$true)]
    [securestring]
    $Password,

    [Parameter(Mandatory=$false)]
    [uint64]
    $CustomerId = 50,

    [Parameter(Mandatory=$true)]
    [string]
    $FirstName,

    [Parameter(Mandatory=$true)]
    [string]
    $LastName,

    [Parameter(Mandatory=$false)]
    [string]
    $Username

    # more
)
}