function Connect-NCApi {
<#
.SYNOPSIS
    Initializes the N-central API connection. This must be run before any other cmdlet.

.DESCRIPTION
    Initializes the N-central API connection. This must be run before any other cmdlet. You will be
    prompted for credentials and the WSDL file's URI if no arguments are supplied. To execute this 
    cmdlet in "quiet" mode, use -Credential and -Wsdl.

.PARAMETER Credential
    The N-central API credentials. The role assigned to this user in N-central will determine
    what actions you can take (read/write) and what customer data you can access.

.PARAMETER Wsdl
    The URI of the WSDL file. To find this, browse to the root address of your N-central server 
    (https://nc.mycompany.com) and add "/dms" to the end of the URI. From there, click on 
    "External API's WSDL" and copy/paste that URI.

.PARAMETER Cache    
    The full path to the XML cache file. Data will be cached to it as you use the module to speed up 
    certain cmdlets.

.PARAMETER Force
    The cache file will be overwritten and regenerated.

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

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [pscredential]
    $Credential,

    [Parameter(Mandatory=$false)]
    [string]
    $Wsdl,

    [Parameter(Mandatory=$false)]
    [string]
    $Cache = (Get-Module -Name 'N-central').ModuleBase + '\Private\NCCache.xml',

    [Parameter(Mandatory=$false)]
    [switch]
    $ReuseConnection,

    [Parameter(Mandatory=$false)]
    [switch]
    $NoCache,

    [Parameter(Mandatory=$false, HelpMessage = 'The timeout in minutes.')]
    [uint64]
    $Timeout = 5,

    [Parameter(Mandatory=$false)]
    [switch]
    $Force
)

    if ($ReuseConnection -and $Global:ncConnection) {
        Write-Verbose 'Attempting to reuse the connection'
    } else {
        if (! $Credential) {
            $Credential = Get-Credential -Message 'N-central API Credentials'
        }
        if (! $Wsdl) {
            $Wsdl = Read-Host -Prompt 'N-central WSDL URI'
        }
        
        Write-Verbose 'Creating new connection'

        $Global:ncNamespace = 'Ncentral' + ([guid]::NewGuid()).ToString().Substring(25)
        $Global:ncCache = $Cache
        $Global:ncCacheEnabled = (! $NoCache)
        
        $timeoutMS = $Timeout * 60 * 1000

        # Setup new proxy object to use for later methods
        $Global:ncConnection = New-WebServiceProxy -Uri $Wsdl -Namespace ($Global:ncNamespace) -Credential $Credential 

        # Set timeout. Cmdlet default is normally 100000 ms (1.67 min)
        $Global:ncConnection.Timeout = $timeoutMS
    }

    # Test connection by querying customer list (SOs only for faster return)
    $username = $Global:ncConnection.Credentials.Username
    $password = $Global:ncConnection.Credentials.Password

    $rawSettings = @{
        'listSOs' = $true;
    }
    $settings = ConvertTo-NCSettings -Settings $rawSettings
    $queryData = $Global:ncConnection.customerList($username, $password, $settings)

    if ($queryData) {
        Write-Verbose 'N-central API connected successfully'

        if (! (Test-Path -Path $Cache) -or $Force) {
            Write-Verbose 'Updating cache...'
            Update-NCCache -Path $Cache
        }
    } else {
        Disconnect-NCAPI
        throw 'Failed to connect to the N-central API'
    }
}
