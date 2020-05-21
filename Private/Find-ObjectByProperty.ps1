function Find-ObjectByProperty {

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