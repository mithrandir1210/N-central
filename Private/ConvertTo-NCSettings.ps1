function ConvertTo-NCSettings {
<#
.SYNOPSIS
    Converts a hashtable or array of hashtables to an array containing objects of type "tKeyPair" 
    or "tKeyValue".
    
.DESCRIPTION
    Retrieves the current API connection's namespace, creates a new tKeyPair or tKeyValue object
    for each key in the Settings hashtable, and adds them to a new array for use in API calls.
    
.PARAMETER Settings
    A hashtable or array of hashtables containing the key/value pairs to pass to the API method.

.PARAMETER Type
    The object type to append to the namespace. Some API methods require settings to be provided
    as tKeyPair and some require tKeyValue, although tKeyPair is the most common.
    
.EXAMPLE
    $rawSettings = @{
        'customerID' = 50;
    }
    $settings = ConvertTo-NCSettings -Settings $rawSettings -Type tKeyPair

    Creates an array with one tKeyPair object containing the key "customerID" and the value 50.
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [hashtable[]]
    $Settings,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("tKeyPair", "tKeyValue")]
    [string]
    $Type = 'tKeyPair'
)
    $results = @()

    foreach ($hashtable in $Settings) {
        foreach ($pair in $hashtable.GetEnumerator()) {
            $newPair = New-Object -TypeName "$Global:ncNamespace.$Type"
            $newPair.Key = $pair.Name
            $newPair.Value = $pair.Value
            $results += $newPair
        }
    }

    return $results
}