function Find-ObjectByProperty {
<#
.SYNOPSIS
    Retrieves one or more objects that match the provided property name and value. This is a 
    faster replacement for 'Where-Object {$_.Property -like $Value}' command.
    
.PARAMETER InputObject
    The object or objects to search.

.PARAMETER Property
    The name of the InputObject property to match.

.PARAMETER Value
    The value of the InputObject property to match. Wildcards are supported unless using StrictMode.

.PARAMETER FirstMatch
    Returns the first object matched.

.PARAMETER StrictMode
    Replaces the -like operator with -ceq for a case-sensitive match.
    
.EXAMPLE
    Find-ObjectByProperty -InputObject $processes -Property Name -Value 'notepad' 

    Find all objects that have a property called 'Name' and a value of 'notepad' and return those 
    that match.
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [object[]]
    $InputObject,

    [Parameter(Mandatory=$true)]
    [string]
    $Property,

    [Parameter(Mandatory=$true)]
    $Value,

    [Parameter(Mandatory=$false)]
    [switch]
    $FirstMatch,

    [Parameter(Mandatory=$false)]
    [switch]
    $StrictMode
)

    $results = New-Object -TypeName System.Collections.ArrayList

    foreach ($obj in $InputObject) {
        if ( ($StrictMode -and $obj.$Property -ceq $Value) -or (! $StrictMode -and $obj.$Property -like $Value) ) {
            if ($FirstMatch) {
                return $obj
            }
            $results += $obj
        }
    }

    return $results
}