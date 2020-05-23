function Set-NCCustomer {
<#
.SYNOPSIS
    Updates a Customer or Site in the MSP N-central server.
    
.PARAMETER CustomerId
    The customer ID to update.

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
    [Parameter(Mandatory=$false)]
    [ValidateLength(1,120)]
    [string]
    $CustomerName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [uint64[]]
    $CustomerId,

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [uint64]
    $ParentId,

    [Parameter(Mandatory=$false)]
    [Alias('postalcode', 'zip/postalcode')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ZipCode,

    [Parameter(Mandatory=$false)]
    [ValidateLength(1,100)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Street1,

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1,100)]
    [string]
    $Street2,

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]
    $City,

    [Parameter(Mandatory=$false)]
    [Alias('stateprov', 'state/province')]
    [ValidateNotNullOrEmpty()]
    [string]
    $State,

    [Parameter(Mandatory=$false)]
    [Alias('telephone')]
    [ValidateNotNullOrEmpty()]
    [string]
    $Phone,

    [Parameter(Mandatory=$false)]
    [Alias('county')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(2,2)]
    [string]
    $Country,

    [Parameter(Mandatory=$false)]
    [ValidateLength(1,100)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ExternalId,

    [Parameter(Mandatory=$false)]
    [ValidateLength(1,100)]
    [ValidateNotNullOrEmpty()]
    [string]
    $ExternalId2,

    [Parameter(Mandatory=$false)]
    [Alias('firstname')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactFirstName,

    [Parameter(Mandatory=$false)]
    [Alias('lastname')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactLastName,

    [Parameter(Mandatory=$false)]
    [Alias('title')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactTitle,

    [Parameter(Mandatory=$false)]
    [Alias('department')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactDepartment,

    [Parameter(Mandatory=$false)]
    [Alias('contactphonenumber', 'contact_telephone')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactPhone,

    [Parameter(Mandatory=$false)]
    [Alias('ext', 'contactext')]
    [ValidateNotNullOrEmpty()]
    [string]
    $ContactExtension,

    [Parameter(Mandatory=$false)]
    [Alias('email')]
    [ValidateNotNullOrEmpty()]
    [ValidateLength(1, 100)]
    [string]
    $ContactEmail,

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('Professional', 'Essential')]
    [string]
    $LicenseType
)

    BEGIN {
        Confirm-NCConnection

        $username = $Global:ncConnection.Credentials.Username
        $password = $Global:ncConnection.Credentials.Password
        
        $isNewCustomerData = $false

        if (! ($allCustomers = Import-NCCache -Property Customers) ) {
            Write-Verbose "Customers not found in cache. Retrieving customers."
            $allCustomers = Get-NCCustomer
            $isNewCustomerData = $true
        }
     
        $successfulIds = New-Object -TypeName System.Collections.ArrayList
    }

    PROCESS {

        foreach ($id in $CustomerId) {
            Write-Verbose "Processing CustomerID: $id"

            for ($i=0; $i -lt 2; $i++) {
                $currentCustomer = Find-ObjectByProperty -InputObject $allCustomers -Property customerid -Value $id -FirstMatch
                if ($currentCustomer) {
                    Write-Verbose "$id found"
                   break
                } elseif (! $currentCustomer -and ! $isNewCustomerData) {
                    Write-Verbose "$id not found in cache. Retrieving customers and trying again."
                    $allCustomers = Get-NCCustomer
                } else {
                    throw "CustomerId not found: $id"
                }
            }
    
            $rawSettings = @{
                'customerid' = $id;
            }
    
            # Add mandatory keys. Get from existing customer if not provided
            
            if ($PSBoundParameters.ContainsKey('ParentId')) {
                $rawSettings.Add('customername', $CustomerName)
            } else {
                $rawSettings.Add('customername', $currentCustomer.customername)
            }

            if ($PSBoundParameters.ContainsKey('ParentId')) {
                $rawSettings.Add('parentid', $ParentId)
            } else {
                $rawSettings.Add('parentid', $currentCustomer.parentid)
            }
    
            # Add optional keys. Get from existing customer if not provided (or they will be nulled out)
    
            if ($PSBoundParameters.ContainsKey('ZipCode')) {
                $rawSettings.Add('zip/postalcode', $ZipCode)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.postalcode)) {
                $rawSettings.Add('zip/postalcode', $currentCustomer.postalcode)
            }
        
            if ($PSBoundParameters.ContainsKey('Street1')) {
                $rawSettings.Add('street1', $Street1)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.street1)) {
                $rawSettings.Add('street1', $currentCustomer.street1)
            }
        
            if ($PSBoundParameters.ContainsKey('Street2')) {
                $rawSettings.Add('street2', $Street2)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.street2)) {
                $rawSettings.Add('street2', $currentCustomer.street2)
            }
        
            if ($PSBoundParameters.ContainsKey('City')) {
                $rawSettings.Add('city', $City)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.city)) {
                $rawSettings.Add('city', $currentCustomer.city)
            }
        
            if ($PSBoundParameters.ContainsKey('State')) {
                $rawSettings.Add('state/province', $State)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.stateprov)) {
                $rawSettings.Add('state/province', $currentCustomer.stateprov)
            }
        
            if ($PSBoundParameters.ContainsKey('Phone')) {
                $rawSettings.Add('telephone', $Phone)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.phone)) {
                $rawSettings.Add('telephone', $currentCustomer.phone)
            }
        
            if ($PSBoundParameters.ContainsKey('Country')) {
                $rawSettings.Add('country', $Country)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.county)) {
                $rawSettings.Add('country', $currentCustomer.county) # yes, that's a typo in the API
            }
        
            if ($PSBoundParameters.ContainsKey('ExternalId')) {
                $rawSettings.Add('externalid', $ExternalId)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.externalid)) {
                $rawSettings.Add('externalid', $currentCustomer.externalid)
            }
        
            if ($PSBoundParameters.ContainsKey('ExternalId2')) {
                $rawSettings.Add('externalid2', $ExternalId2)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.externalid2)) {
                $rawSettings.Add('externalid2', $currentCustomer.externalid2)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactFirstName')) {
                $rawSettings.Add('firstname', $ContactFirstName)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactfirstname)) {
                $rawSettings.Add('firstname', $currentCustomer.contactfirstname)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactLastName')) {
                $rawSettings.Add('lastname', $ContactLastName)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactlastname)) {
                $rawSettings.Add('lastname', $currentCustomer.contactlastname)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactTitle')) {
                $rawSettings.Add('title', $ContactTitle)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contacttitle)) {
                $rawSettings.Add('title', $currentCustomer.contacttitle)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactDepartment')) {
                $rawSettings.Add('department', $ContactDepartment)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactdepartment)) {
                $rawSettings.Add('department', $currentCustomer.contactdepartment)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactPhone')) {
                $rawSettings.Add('contact_telephone', $ContactPhone)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactphonenumber)) {
                $rawSettings.Add('contact_telephone', $currentCustomer.contactphonenumber)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactExtension')) {
                $rawSettings.Add('ext', $ContactExtension)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactext)) {
                $rawSettings.Add('ext', $currentCustomer.contactext)
            }
        
            if ($PSBoundParameters.ContainsKey('ContactEmail')) {
                $rawSettings.Add('email', $ContactEmail)
            } elseif (! [string]::IsNullOrEmpty($currentCustomer.contactemail)) {
                $rawSettings.Add('email', $currentCustomer.contactemail)
            }
        
            if ($PSBoundParameters.ContainsKey('LicenseType')) {
                $rawSettings.Add('licensetype', $LicenseType)
            } 
        
            foreach ($item in $rawSettings.GetEnumerator()) {
                Write-Verbose "$($item.Name) --> $($item.Value)"
            }

            $settings = ConvertTo-NCSettings -Settings $rawSettings
    
            # Make API call to set the values
            try {
                Write-Verbose "Executing API call: customerModify"
                Write-Debug "Executing API call: customerModify"
                $successfulIds += $Global:ncConnection.customerModify($username, $password, $settings)
            } catch {
                Write-Error $_.Exception.Message
            }
        }

    }

    END {
        return $successfulIds
    }

}
