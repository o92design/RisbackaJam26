[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$BuildId,
    [string]$ArchiveRoot = $(if ($env:ARCHIVE_ROOT) { $env:ARCHIVE_ROOT } else { 'D:\RisbackaJam26' }),
    [string]$Target = 'kioskars/risbacka-jam-26',
    [string]$Channel = 'windows-dev',
    [switch]$PreserveDiagnostics
)

. (Join-Path $PSScriptRoot 'Common.ps1')

# Promotion jobs have their own Jenkins workspace. Clear only its transient CI
# diagnostics so each attempt is self-contained.
if (-not $PreserveDiagnostics) {
    foreach ($path in @($script:LogRoot, $script:MetadataRoot, $script:TestRoot)) {
        $resolved = [IO.Path]::GetFullPath($path)
        if (-not $resolved.StartsWith($script:RepositoryRoot, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to clean promotion state outside the repository: $resolved"
        }
        if (Test-Path -LiteralPath $resolved) {
            Remove-Item -LiteralPath $resolved -Recurse -Force
        }
    }
}
Initialize-CIDirectories

Invoke-CIStage -Name 'Promotion Context' -Body {
    if ($BuildId -notmatch '^[A-Za-z0-9][A-Za-z0-9_.-]*$') {
        throw "Build ID contains unsupported path characters: $BuildId"
    }
    if (-not [IO.Path]::IsPathRooted($ArchiveRoot)) {
        $ArchiveRoot = Join-Path $script:RepositoryRoot $ArchiveRoot
    }
    $ArchiveRoot = [IO.Path]::GetFullPath($ArchiveRoot)
    $testRoot = Get-RequiredPath -Path (Join-Path $ArchiveRoot 'Runs\Test') -Description 'Test archive root'
    $testRootPrefix = $testRoot.TrimEnd('\') + '\'
    $runPath = [IO.Path]::GetFullPath((Join-Path $testRoot $BuildId))
    if (-not $runPath.StartsWith($testRootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Resolved promotion path escaped the Test archive root: $runPath"
    }

    $manifestPath = Get-RequiredPath -Path (Join-Path $runPath 'manifest.json') -Description 'Selected Test build manifest'
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ([string]$manifest.buildId -ne $BuildId) {
        throw "Manifest build ID '$($manifest.buildId)' does not match selected '$BuildId'."
    }
    if ([string]$manifest.stream -ne 'Test') {
        throw "Only Test archives can be promoted to Development; selected stream is '$($manifest.stream)'."
    }
    if ([string]$manifest.result -ne 'Success') {
        throw "Only successful Test archives can be promoted; selected result is '$($manifest.result)'."
    }
    if ($manifest.PSObject.Properties['promotions']) {
        $existing = @($manifest.promotions | Where-Object { $_.channel -eq $Channel })
        if ($existing.Count -gt 0) {
            throw "Build $BuildId has already been promoted to $Channel."
        }
    }

    $packageDirectory = Get-RequiredPath -Path (Join-Path $runPath 'Package\Windows') -Description 'Archived Windows package'
    $checksumPath = Get-RequiredPath -Path (Join-Path $runPath 'SHA256SUMS.txt') -Description 'Archived SHA-256 manifest'
    $historyPath = Join-Path (Join-Path $ArchiveRoot 'History') "$BuildId.json"

    $context = [ordered]@{
        schemaVersion        = 1
        buildId              = $BuildId
        sourceRunPath        = $runPath
        sourceManifestPath   = $manifestPath
        historyManifestPath  = $historyPath
        packageDirectory     = $packageDirectory
        checksumPath         = $checksumPath
        sourceCommit         = $manifest.commit
        sourceBuildNumber    = $manifest.buildNumber
        sourceBuildComputer  = $manifest.buildComputer
        target               = $Target
        channel              = $Channel
        version              = $BuildId
        promotionJobName     = $(if ($env:JOB_NAME) { $env:JOB_NAME } else { 'local' })
        promotionBuildNumber = $(if ($env:BUILD_NUMBER) { $env:BUILD_NUMBER } else { 'local' })
        promotionBuildUrl    = $(if ($env:BUILD_URL) { $env:BUILD_URL } else { '' })
        promotionComputer    = [Environment]::MachineName
        startedUtc           = [DateTime]::UtcNow.ToString('o')
    }
    $contextPath = Join-Path $script:MetadataRoot 'PromotionContext.json'
    $context | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $contextPath -Encoding UTF8
    Write-CILog -Stage 'Promotion Context' -Message "Selected successful Test build $BuildId for $Target`:$Channel."
}
