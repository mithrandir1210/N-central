function Update-NCCache {
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [string]
    $Path,

    [Parameter(Mandatory=$true, ParameterSetName='UpdateProperty')]
    [string]
    $Property,
    
    [Parameter(Mandatory=$true, ParameterSetName='UpdateProperty')]
    $Value,

    [Parameter(Mandatory=$false)]
    [switch]
    $Force
)

    $today = Get-Date

    # Create new cache if it doesn't exist or if a specific property is not requested (update all)
    if ($Force -or (! (Test-Path -Path $Path) -or ! $Property)) {
        Write-Verbose 'Creating new cache object'
        $cache = New-Object -TypeName psobject -Property @{
            LastUpdate = $today;
            Customers = New-Object -TypeName psobject -Property @{
                LastUpdate = $today;
                Value = ((Get-NCCustomer) | Sort-Object -Property customerid);
            }
        }
    }

    if ($Property) {
        # Import existing cache if not in memory already from update above
        if (! $cache) {
            Write-Verbose "Importing existing cache from: [$Path]"
            $cache = Import-Clixml -Path $Path -ErrorAction Stop
        }
        
        # If property exists, update. Add member otherwise
        if ($cache.$Property.Value) {
            Write-Verbose 'Updating existing cache property'
            $cache.$Property.Value = $Value
        } else {
            Write-Verbose "Cache property [$Property] not found. Adding property to cache object."
            $cache | Add-Member -MemberType NoteProperty -Name $Property -Value (New-Object -TypeName psobject -Property @{
                LastUpdate = $today;
                Value = $Value;
            }) -Force
        }
    } 

    # Export to file
    Write-Verbose "Exporting cache to: [$Path]"
    $cache | Export-Clixml -Path $Path -Force
}
