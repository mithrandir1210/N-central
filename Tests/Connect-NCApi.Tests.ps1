﻿[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [pscredential]
    $Credential,

    [Parameter(Mandatory=$true)]
    [string]
    $Wsdl
)

# Import module
$rootPath = Split-Path -Parent -Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Path)
$modulePath = "$rootPath\N-central"

Remove-Module -Name $modulePath -ErrorAction Ignore
Import-Module -Name $modulePath -Force
Import-Module -Name Pester

InModuleScope {
    Describe -Name "Sample Test" {
        $actual = 'test'
    
        It -Name "same case" -Test {
            $expected = 'TEST'
            $actual | Should BeExactly $expected
        }
    }
}

