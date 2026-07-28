[CmdletBinding()]
param(
    [string]$Target = 'kioskars/risbacka-jam-26',
    [Parameter(Mandatory)][string]$Channel,
    [Parameter(Mandatory)][string]$Version,
    [string]$ButlerPath = $(if ($env:BUTLER_PATH) { $env:BUTLER_PATH } else { 'C:\Tools\butler\butler.exe' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'itch.io Upload' -Body {
    if (-not $env:BUTLER_API_KEY) { throw 'BUTLER_API_KEY is unavailable. Configure Jenkins Secret Text credential itch-butler-api-key.' }
    $paths = Get-UEPaths
    $packageDirectory = Get-RequiredPath -Path $paths.PackageFolder -Description 'Verified package'
    Get-RequiredPath -Path $ButlerPath -Description 'itch.io Butler' | Out-Null
    Invoke-LoggedProcess -Stage 'itch.io Upload' -FilePath $ButlerPath -Arguments @(
        'push', $packageDirectory, "$Target`:$Channel", '--userversion', $Version
    ) | Out-Null
}
