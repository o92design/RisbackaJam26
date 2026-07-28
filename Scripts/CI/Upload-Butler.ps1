[CmdletBinding()]
param(
    [string]$Target = 'kioskars/risbacka-jam-26',
    [Parameter(Mandatory)][string]$Channel,
    [string]$Version,
    [string]$PackageDirectory,
    [string]$ButlerPath = $(if ($env:BUTLER_PATH) { $env:BUTLER_PATH } else { 'C:\Tools\butler\butler.exe' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'itch.io Upload' -Body {
    if (-not $env:BUTLER_API_KEY) { throw 'BUTLER_API_KEY is unavailable. Configure Jenkins Secret Text credential itch-butler-api-key.' }
    if (-not $Version) {
        $context = Read-BuildContext
        $Version = [string]$context.version
    }
    if (-not $Version) { throw 'itch.io user version is unavailable from both the command and build context.' }
    if (-not $PackageDirectory) {
        $paths = Get-UEPaths
        $PackageDirectory = $paths.PackageFolder
    }
    $PackageDirectory = Get-RequiredPath -Path $PackageDirectory -Description 'Verified package'
    Get-RequiredPath -Path $ButlerPath -Description 'itch.io Butler' | Out-Null
    Invoke-LoggedProcess -Stage 'itch.io Upload' -FilePath $ButlerPath -Arguments @(
        'push', '--verbose', '--assume-yes', $PackageDirectory, "$Target`:$Channel", '--userversion', $Version
    ) -EchoToConsole | Out-Null
}
