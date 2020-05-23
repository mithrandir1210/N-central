function Format-NCData {
<#
.SYNOPSIS
    Converts the array of objects returned by the N-central API into an array of PSObjects. 

.DESCRIPTION
    Parses the unmodified data returned by the API into a cleaner format by removing 
    extraneous text from the property names and grouping like properties (e.g. applications).
    The name of the original property is broken into tokens using "." as the delimiter different
    actions are taken based on the number of tokens and if they end in a number
    (e.g. asset.application.installdate.2). Properties that may contain date values are converted
    to PowerShell DateTime objects based on the name of the key. Boolean and integer values are
    also converted (e.g. 'true' to [bool] $true, '123' to [uint64] 123).

.PARAMETER Data
    The object or array of objects returned by the API call.

.EXAMPLE
    $formattedData = Format-NCData -Data $queryResult

    Process the object returned by the API call and save to the $formattedData variable.
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    $Data
)

    if ($arrayName = $Data | Get-Member -MemberType Property | Where-Object {$_.Definition -like "*.tKeyPair*"} | Select-Object -ExpandProperty Name) {
        Write-Verbose "Identified $property as the tKeyPair array"
    } elseif ($arrayName = $Data | Get-Member -MemberType Property | Where-Object {$_.Definition -like "*.tKeyValue*"} | Select-Object -ExpandProperty Name) {
        Write-Verbose "Identified $property as the tKeyValue array"
    } else {
        Write-Verbose "tKeyPair property not identified. Using unmodified tKeyValue property."
        return $Data
    }
    
    $results = New-Object -TypeName System.Collections.ArrayList

    foreach ($item in $Data) {

        $result = New-Object -TypeName psobject 

        $tracker = @{}

        foreach ($property in $item.$arrayName) {

            # Tokenize key name and remove prefix
            $tokens = ($property.Key).Split('.')

            # Remove prefix
            $tokens = $tokens[1..($tokens.Count - 1)]

            $categoryMultiple = $tokens[0] + '_list'
            $categorySingle = $tokens[0]
            $attribute = $tokens[1]
            $instanceNumber = $tokens[2]

            # Convert date values if key name appears to be a date -- may need to clean conditions up eventually???
            if ($property.Value -and ($property.Key -like "*date*" -or $property.Key -like "*time*" -or $property.Key -like "*createdon*")) {      
                try {
                    if ($property.Value -is [System.Array] -and ($property.Value).Count -eq 1) {
                        $newValue = Get-Date $property.Value[0]
                    } else {
                        $newValue = Get-Date $property.Value
                    }
                } catch {
                    $newValue = $property.Value
                }
            } elseif ($property.Value -like "true") {
                $newValue = $true
            } elseif ($property.Value -like "false") {
                $newValue = $false
            } else {
                # Convert arrays with one element to single object
                if ($property.Value -is [System.Array] -and ($property.Value).Count -eq 1) {
                    $newValue = $property.Value[0]
                } else {
                    $newValue = $property.Value
                }
                # Convert to int if all numbers
                if ($property.Value -match "^\d+$") {
                    $newValue = [uint64] $newValue
                }
            }

            # 1 TOKEN
            if ($tokens.Count -eq 1) {

                $result | Add-Member -MemberType NoteProperty -Name $tokens[0] -Value $newValue

            # LAST TOKEN ENDS IN A NUMBER
            } elseif ($tokens[($tokens.Count) - 1] -match '^\d+$') {
                # Last token contains a number -- must have multiples

                # Check existence of array name and init if needed
                if (! $tracker.ContainsKey($categoryMultiple)) {
                    # Update tracker
                    $tracker.Add($categoryMultiple, @())

                    # Add property to result object
                    $result | Add-Member -MemberType NoteProperty -Name $categoryMultiple -Value @()
                }      
                
                # Check existence of object number within array property and init if needed
                if ($tracker[$categoryMultiple] -contains $instanceNumber) {
                    
                    # Get position of matching object number
                    $index = $tracker[$categoryMultiple].IndexOf($instanceNumber)

                    # Get element based on index and add property to result object
                    $result.$categoryMultiple[$index] | Add-Member -MemberType NoteProperty -Name $attribute -Value $newValue
                    
                } else {
                    # Update tracker with array name and object number
                    $tracker[$categoryMultiple] += $instanceNumber

                    # Create new object
                    $nestedResult = New-Object -TypeName psobject

                    # Add property to new object
                    $nestedResult | Add-Member -MemberType NoteProperty -Name $attribute -Value $newValue

                    # Add object to array property of result object
                    $result.$categoryMultiple += $nestedResult
                }

            # 2 TOKENS
            } elseif ($tokens.Count -eq 2) {

                if ($tracker.ContainsKey($categorySingle)) {
                    # Add property to existing nested object
                    $result.$categorySingle | Add-Member -MemberType NoteProperty -Name $attribute -Value $newValue
                } else {

                    # Update tracker
                    $tracker.Add($categorySingle, $null)

                    # Create new object
                    $nestedResult = New-Object -TypeName psobject

                    # Add property to new object
                    $nestedResult | Add-Member -MemberType NoteProperty -Name $attribute -Value $newValue

                    # Add nested object to result object
                    $result | Add-Member -MemberType NoteProperty -Name $categorySingle -Value $nestedResult
                }

            }
        }

        $results += $result
    }    

    return $results
}
