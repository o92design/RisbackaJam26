[CmdletBinding()]
param(
    [string]$UERoot = 'J:\dev\unreal\UE_5.8',
    [switch]$AllowNoTests
)

$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'Scripts\CI\Test-Project.ps1')
& (Join-Path $PSScriptRoot 'Scripts\CI\Run-UnrealTests.ps1') -UERoot $UERoot -AllowNoTests:$AllowNoTests
