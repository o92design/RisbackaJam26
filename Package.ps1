[CmdletBinding()]
param(
    [ValidateSet('Development', 'Shipping')][string]$Configuration = 'Development',
    [string]$UERoot = 'J:\dev\unreal\UE_5.8',
    [switch]$SkipTests,
    [switch]$SkipStartupSmoke
)

$ErrorActionPreference = 'Stop'
$channel = if ($Configuration -eq 'Shipping') { 'windows' } else { 'windows-dev' }
& (Join-Path $PSScriptRoot 'Scripts\CI\New-BuildContext.ps1') -Configuration $Configuration -Channel $channel
& (Join-Path $PSScriptRoot 'Scripts\CI\Test-Preflight.ps1') -UERoot $UERoot -SkipButlerCheck
& (Join-Path $PSScriptRoot 'Scripts\CI\Test-Project.ps1')
if (-not $SkipTests) {
    & (Join-Path $PSScriptRoot 'Scripts\CI\Run-UnrealTests.ps1') -UERoot $UERoot
}
& (Join-Path $PSScriptRoot 'Scripts\CI\Build-Package.ps1') -Configuration $Configuration -UERoot $UERoot
& (Join-Path $PSScriptRoot 'Scripts\CI\Verify-Package.ps1') -UERoot $UERoot -SkipStartupSmoke:$SkipStartupSmoke
