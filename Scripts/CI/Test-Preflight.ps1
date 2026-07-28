[CmdletBinding()]
param(
    [string]$UERoot = $(if ($env:UE_ROOT) { $env:UE_ROOT } else { 'C:\Epic\UE_5.8' }),
    [string]$ButlerPath = $(if ($env:BUTLER_PATH) { $env:BUTLER_PATH } else { 'C:\Tools\butler\butler.exe' }),
    [switch]$SkipButlerCheck,
    [int]$MinimumWorkspaceFreeGB = 50
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Preflight' -Body {
    $paths = Get-UEPaths -UERoot $UERoot
    Get-RequiredPath -Path $paths.Project -Description 'Unreal project' | Out-Null
    Get-RequiredPath -Path $paths.RunUAT -Description 'Unreal Automation Tool' | Out-Null
    Get-RequiredPath -Path $paths.EditorCmd -Description 'Unreal command-line editor' | Out-Null
    if (-not $SkipButlerCheck) {
        Get-RequiredPath -Path $ButlerPath -Description 'itch.io Butler' | Out-Null
    }

    foreach ($command in @('git', 'git-lfs')) {
        if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
            throw "Required command is unavailable: $command"
        }
    }

    $driveRoot = [IO.Path]::GetPathRoot($script:RepositoryRoot)
    $driveName = $driveRoot.TrimEnd('\').TrimEnd(':')
    $drive = [IO.DriveInfo]::new($driveRoot)
    $freeGB = [Math]::Round($drive.AvailableFreeSpace / 1GB, 2)
    if ($freeGB -lt $MinimumWorkspaceFreeGB) {
        throw "Workspace drive $driveName`: has only $freeGB GB free; at least $MinimumWorkspaceFreeGB GB is required."
    }
    Write-CILog -Stage 'Preflight' -Message "Workspace drive free space: $freeGB GB."
}
