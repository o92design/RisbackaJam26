[CmdletBinding()]
param(
    [ValidateSet('Success', 'Failure', 'Unstable')][string]$Result,
    [string]$ArchiveRoot = $(if ($env:ARCHIVE_ROOT) { $env:ARCHIVE_ROOT } else { 'D:\RisbackaJam26' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

if (-not [IO.Path]::IsPathRooted($ArchiveRoot)) {
    $ArchiveRoot = Join-Path $script:RepositoryRoot $ArchiveRoot
}
$ArchiveRoot = [IO.Path]::GetFullPath($ArchiveRoot)

$marker = Join-Path $script:MetadataRoot 'ArchivedRunPath.txt'
if (-not (Test-Path -LiteralPath $marker)) {
    & (Join-Path $PSScriptRoot 'Publish-Archive.ps1') -Result $Result -ArchiveRoot $ArchiveRoot
}

$runPath = (Get-Content -Raw -LiteralPath $marker).Trim()
$manifestPath = Join-Path $runPath 'manifest.json'
Get-RequiredPath -Path $manifestPath -Description 'Archived run manifest' | Out-Null

# The package is already safely archived before upload. This final pass records the
# upload/final outcome and closes the manifest; package files remain untouched.
$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$stagesPath = Join-Path $script:MetadataRoot 'stages.ndjson'
$stages = @()
if (Test-Path -LiteralPath $stagesPath) {
    $stages = @(Get-Content -LiteralPath $stagesPath | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
}
$failed = @($stages | Where-Object { $_.result -eq 'Failed' } | Select-Object -Last 1)

$manifest.result = $Result
$manifest.stages = $stages
$manifest.failureStage = if ($failed.Count -gt 0) {
    $failed[0].name
}
elseif ($Result -eq 'Failure') {
    'Pipeline or external Jenkins step'
}
else {
    ''
}
$manifest | Add-Member -NotePropertyName finalizedUtc -NotePropertyValue ([DateTime]::UtcNow.ToString('o')) -Force

$nativeLog = Get-ChildItem -LiteralPath $script:LogRoot -Filter '*.native.log' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime | Select-Object -Last 1
if ($nativeLog) {
    $excerpt = (@(Get-Content -LiteralPath $nativeLog.FullName -Tail 30) -join [Environment]::NewLine)
    if ($excerpt.Length -gt 12000) { $excerpt = $excerpt.Substring($excerpt.Length - 12000) }
    $manifest.diagnosticExcerpt = $excerpt
}

$manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
$historyPath = Join-Path (Join-Path $ArchiveRoot 'History') "$($manifest.runName).json"
Copy-Item -LiteralPath $manifestPath -Destination $historyPath -Force

foreach ($pair in @(
    @{ Source = $script:LogRoot; Destination = (Join-Path $runPath 'Logs') },
    @{ Source = $script:MetadataRoot; Destination = (Join-Path $runPath 'Metadata') },
    @{ Source = $script:TestRoot; Destination = (Join-Path $runPath 'Tests') }
)) {
    if (Test-Path -LiteralPath $pair.Source) {
        New-Item -ItemType Directory -Force -Path $pair.Destination | Out-Null
        Invoke-LoggedProcess -Stage 'Archive Finalization' -FilePath 'robocopy.exe' -Arguments @(
            $pair.Source, $pair.Destination, '/E', '/R:2', '/W:2', '/NFL', '/NDL', '/NP', '/NJH', '/NJS'
        ) -SuccessExitCodes @(0, 1, 2, 3, 4, 5, 6, 7) | Out-Null
    }
}

Write-CILog -Stage 'Archive Finalization' -Message "Finalized run $($manifest.runName) as $Result."
