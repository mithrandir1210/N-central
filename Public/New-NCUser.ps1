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

<#
Mandatory - (Key) email - (Value) Login email for the new user. Maximum of 100 characters.
Mandatory - (Key) password - (Value) Password for the new user. Must meet configured password complexity level.
Mandatory - (Key) customerID - (Value) The customerID of the site/customer/SO that the user is associated with.
Mandatory - (Key) firstname - (Value) User's first name.
Mandatory - (Key) lastname - (Value) User's last name.
(Key) username - (Value) The username the user will use to log into MSP N-central. If it is blank, the email field will be used to populate this field.
(Key) country - (Value) User's country. Two character country code, see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 for a list of country codes.
(Key) zip/postalcode - (Value) User's zip/ postal code.
(Key) street1 - (Value) User's Address line 1. Maximum of 100 characters.
(Key) street2 - (Value) User's address line 2.
(Key) city - (Value) User's city.
(Key) state/province - (Value) User's state/ province.
(Key) telephone - (Value) User's telephone number.
(Key) ext - (Value) User's telephone extension.
(Key) department - (Value) User's department.
(Key) notificationemail - (Value) Email address for notifications to be sent to if different than the login email.
(Key) status - (Value) Determines whether the user account is enabled or disabled. Must be "enabled" or "disabled". Default is enabled.
(Key) userroleID - (Value) The UserRoleID of the role the user is associated with.
(Key) accessgroupID - (Value) The AccessGroupID of the group the user is associated with.

#>
}