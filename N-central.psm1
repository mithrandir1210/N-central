[CmdletBinding()]

$publicFunctions  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue) 
$privateFunctions = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue) 

foreach ($import in @($publicFunctions + $privateFunctions))
{
    Write-Verbose "Importing $import"
    try {
        . $import.FullName
    }
    catch {
        throw "Could not import function $($import.FullName): $_"
    }
}

Export-ModuleMember -Function $publicFunctions.Basename