<#
.SYNOPSIS
    Initializes the N-central API connection. This must be run before any other cmdlet.

.DESCRIPTION
    You will be prompted for credentials and the WSDL file's URI if no arguments are supplied. To
    execute this cmdlet in "quiet" mode, use -Credential and -Wsdl.

.PARAMETER Credential
    The N-central API credentials. The role assigned to this user in N-central will determine
    what cmdlets you can use. 

.PARAMETER Wsdl
    The WSDL file's URI.

.EXAMPLE
    Connect-NCApi

    You will be prompted for API credentials and the WSDL file's URI.

.EXAMPLE
    Connect-NCApi -Credential $myCreds -Wsdl "https://nc.mycompany.com/dms2/services2/ServerEI2?wsdl"

    You will not be prompted for credentials or the WSDL file's URI.

.EXAMPLE
    Connect-NCApi -Credential $myCreds

    You will be prompted for the Wsdl file's URI, but not the API credentials.
#>
function Connect-NCApi {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [pscredential]
    $Credential = (Get-Credential -Message 'N-central API Credentials'),

    [Parameter(Mandatory=$false)]
    [string]
    $Wsdl = (Read-Host -Prompt 'N-central WSDL Uri'),

    [Parameter(Mandatory=$false)]
    [string]
    $Cache = (Get-Module -Name 'N-central').ModuleBase + '\Private\NCCache.xml',

    [Parameter(Mandatory=$false)]
    [switch]
    $Force
)

    $Global:ncNamespace = "Ncentral" + ([guid]::NewGuid()).ToString().Substring(25)
    $Global:ncCache = $Cache
    
    # Setup new proxy object to use for later methods
    $Global:ncConnection = New-WebServiceProxy -Uri $Wsdl -Namespace ($Global:ncNamespace) -Credential $Credential
    
    # Test connection by querying customer list (SOs only for faster return)
    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'listSOs' = $true;
    }
    $settings = ConvertTo-NCSettings -Settings $rawSettings
    $queryData = $Global:ncConnection.customerList($username, $password, $settings)

    if ($queryData) {
        Write-Verbose "N-central API connected successfully"

        if (! (Test-Path -Path $Cache) -or $Force) {
            Write-Verbose "Updating cache..."
            Update-NCCache -Path $Cache
        }
    } else {
        Disconnect-NCAPI
        throw "Failed to connect to the N-central API"
    }
}
