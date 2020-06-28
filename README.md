# N-central

A PowerShell wrapper for the N-central SOAP API. 

## Installation

To install the module, copy the 'N-central' module folder to one of the following locations:

Current User:
```
C:\Users\%username%\Documents\WindowsPowerShell\Modules
```

All Users:
```
C:\Program Files\WindowsPowerShell\Modules
```

## Usage

### Initial Connection

Import the module:
```
Import-Module -Name N-central
```

Before you can run the cmdlets in the module, you must connect to the N-central API. To do so, run:
```
Connect-NCApi
```

To connect to the API in quiet mode, you can pass a credential object and the WSDL URI to Connect-NCApi:
```
$creds = Get-Credential
$wsdl = 'https://myncentralserver/dms2/services2/ServerEI2?wsdl'
Connect-NCApi -Credential $creds -Wsdl $wsdl
```

### Help

To view all functions available in the module, import the module and run:
```
Get-Command -Module N-central
```

To view the help file for a specific function (e.g. Connect-NCApi):
```
Get-Help -Name Connect-NCApi -Full
```

## Built Against

* PowerShell 5.1
* Solarwinds N-central 12.2.1.280

## Authors

* **mithrandir1210**

## Release Notes

### Version 1.0 (Beta)

* Initial beta release