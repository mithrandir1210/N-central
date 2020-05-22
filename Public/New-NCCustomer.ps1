function New-NCCustomer {
<#
.SYNOPSIS
    Adds a new Customer or Site to the MSP N-central server.
    
.PARAMETER CustomerName
    Desired name for the new customer or site.

.PARAMETER ParentId
    The customer ID of the parent service organization or parent customer for the new customer/site.

.PARAMETER ZipCode
    Customer's zip/postal code.

.PARAMETER Street1
    Address line 1 for the customer.

.PARAMETER Street2
    Address line 2 for the customer.

.PARAMETER City
    Customer's city.

.PARAMETER State
    Customer's state/province.

.PARAMETER Phone
    Phone number of the customer.

.PARAMETER Country
    Customer's country.

.PARAMETER ExternalId
    An external reference id.

.PARAMETER ExternalId2
    A secondary external reference id.

.PARAMETER ContactFirstName
    Customer contact's first name.

.PARAMETER ContactLastName
    Customer contact's last name.

.PARAMETER ContactTitle
    Customer contact's title.

.PARAMETER ContactDepartment
    Customer contact's department.

.PARAMETER ContactPhone
    Customer contact's telephone number.

.PARAMETER ContactExtension
    Customer contact's telephone extension.

.PARAMETER ContactEmail
    Customer contact's email.

.PARAMETER LicenseType
    The default license type of new devices for the customer.
    
.OUTPUTS 
    The customer ID number of the new customer/site. 

.EXAMPLE
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [ValidateLength(1,120)]
    [string]
    $CustomerName,

    [Parameter(Mandatory=$true)]
    [uint64]
    $ParentId,

    [Parameter(Mandatory=$false)]
    [Alias('postalcode', 'zip/postalcode')]
    [string]
    $ZipCode,

    [Parameter(Mandatory=$false)]
    [ValidateLength(1,100)]
    [string]
    $Street1,

    [Parameter(Mandatory=$false)]
    [ValidateLength(1,100)]
    [string]
    $Street2,

    [Parameter(Mandatory=$false)]
    [string]
    $City,

    [Parameter(Mandatory=$false)]
    [Alias('stateprov', 'state/province')]
    [string]
    $State,

    [Parameter(Mandatory=$false)]
    [Alias('telephone')]
    [string]
    $Phone,

    [Parameter(Mandatory=$false)]
    [Alias('county')]
    [ValidateLength(2,2)]
    [string]
    $Country,

    [Parameter(Mandatory=$false)]
    [string]
    $ExternalId,

    [Parameter(Mandatory=$false)]
    [string]
    $ExternalId2,

    [Parameter(Mandatory=$false)]
    [Alias('firstname')]
    [string]
    $ContactFirstName,

    [Parameter(Mandatory=$false)]
    [Alias('lastname')]
    [string]
    $ContactLastName,

    [Parameter(Mandatory=$false)]
    [Alias('title')]
    [string]
    $ContactTitle,

    [Parameter(Mandatory=$false)]
    [Alias('department')]
    [string]
    $ContactDepartment,

    [Parameter(Mandatory=$false)]
    [Alias('contactphonenumber', 'contact_telephone')]
    [string]
    $ContactPhone,

    [Parameter(Mandatory=$false)]
    [Alias('ext', 'contactext')]
    [string]
    $ContactExtension,

    [Parameter(Mandatory=$false)]
    [Alias('email')]
    [ValidateLength(1, 100)]
    [string]
    $ContactEmail,

    [Parameter(Mandatory=$false)]
    [ValidateSet('Professional', 'Essential')]
    [string]
    $LicenseType
)

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password

        $successfulIds = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {

        # Add mandatory keys 
        $rawSettings = @{
            'customername' = $CustomerName;
            'parentid' = $ParentId
        }

        # Add optional keys

        if (! [string]::IsNullOrEmpty($ZipCode)) {
            $rawSettings.Add('zip/postalcode', $ZipCode)
        } 
    
        if (! [string]::IsNullOrEmpty($Street1)) {
            $rawSettings.Add('street1', $Street1)
        } 
    
        if (! [string]::IsNullOrEmpty($Street2)) {
            $rawSettings.Add('street2', $Street2)
        } 
    
        if (! [string]::IsNullOrEmpty($City)) {
            $rawSettings.Add('city', $City)
        } 
    
        if (! [string]::IsNullOrEmpty($State)) {
            $rawSettings.Add('state/province', $State)
        } 
    
        if (! [string]::IsNullOrEmpty($Phone)) {
            $rawSettings.Add('telephone', $Phone)
        } 
    
        if (! [string]::IsNullOrEmpty($Country)) {
            $rawSettings.Add('country', $Country)
        } 
    
        if (! [string]::IsNullOrEmpty($ExternalId)) {
            $rawSettings.Add('externalid', $ExternalId)
        } 
    
        if (! [string]::IsNullOrEmpty($ExternalId2)) {
            $rawSettings.Add('externalid2', $ExternalId2)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactFirstName)) {
            $rawSettings.Add('firstname', $ContactFirstName)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactLastName)) {
            $rawSettings.Add('lastname', $ContactLastName)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactTitle)) {
            $rawSettings.Add('title', $ContactTitle)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactDepartment)) {
            $rawSettings.Add('department', $ContactDepartment)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactPhone)) {
            $rawSettings.Add('contact_telephone', $ContactPhone)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactExtension)) {
            $rawSettings.Add('ext', $ContactExtension)
        } 
    
        if (! [string]::IsNullOrEmpty($ContactEmail)) {
            $rawSettings.Add('email', $ContactEmail)
        } 
    
        if (! [string]::IsNullOrEmpty($LicenseType)) {
            $rawSettings.Add('licensetype', $LicenseType)
        } 
    
        $settings = ConvertTo-NCSettings -Settings $rawSettings
    
        # Make API call to create the customer
        try {
            $successfulIds += $Global:ncConnection.customerAdd($username, $password, $settings)
        } catch {
            Write-Error $_.Exception.Message
        }
    }

    END {
        return $successfulIds
    }

}
