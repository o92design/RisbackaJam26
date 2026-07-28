[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

if (-not (Test-Path -LiteralPath (Join-Path $root '.git'))) {
    & git init --initial-branch=master $root
    if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }
}

Push-Location $root
try {
    $safeOption = "safe.directory=$($root.Replace('\', '/'))"
    & git -c $safeOption branch -M master
    if ($LASTEXITCODE -ne 0) { throw 'Unable to set the master branch.' }
    & git -c $safeOption config --local core.longpaths true
    & git -c $safeOption lfs install --local
    if ($LASTEXITCODE -ne 0) { throw 'Git LFS setup failed.' }
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $root 'Scripts\CI\Test-Project.ps1')
    Write-Host 'Local repository setup is ready. Stage and review files before the first commit.'
}
finally {
    Pop-Location
}
