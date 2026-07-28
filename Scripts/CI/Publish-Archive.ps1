[CmdletBinding()]
param(
    [ValidateSet('Success', 'Failure', 'Unstable')][string]$Result,
    [string]$ArchiveRoot = $(if ($env:ARCHIVE_ROOT) { $env:ARCHIVE_ROOT } else { 'D:\RisbackaJam26' }),
    [int]$WarningFreeGB = 150,
    [int]$StopFreeGB = 50
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Immutable Archive' -Body {
    $context = Read-BuildContext
    if (-not [IO.Path]::IsPathRooted($ArchiveRoot)) {
        $ArchiveRoot = Join-Path $script:RepositoryRoot $ArchiveRoot
    }
    $ArchiveRoot = [IO.Path]::GetFullPath($ArchiveRoot)
    New-Item -ItemType Directory -Force -Path $ArchiveRoot | Out-Null
    $archiveDriveRoot = [IO.Path]::GetPathRoot($ArchiveRoot)
    $archiveDrive = [IO.DriveInfo]::new($archiveDriveRoot)
    $freeGBBefore = [Math]::Round($archiveDrive.AvailableFreeSpace / 1GB, 2)
    if ($freeGBBefore -lt $StopFreeGB) {
        throw "Archive drive has only $freeGBBefore GB free; archival stops below $StopFreeGB GB."
    }
    if ($freeGBBefore -lt $WarningFreeGB) {
        Write-CILog -Stage 'Immutable Archive' -Level WARN -Message "Archive drive has $freeGBBefore GB free (warning threshold: $WarningFreeGB GB)."
    }

    foreach ($directory in @('Runs\Test', 'Runs\Development', 'Runs\Release', 'History', 'Promotions', 'Dashboard', 'Staging')) {
        New-Item -ItemType Directory -Force -Path (Join-Path $ArchiveRoot $directory) | Out-Null
    }

    $stream = [string]$context.stream
    if ($stream -notin @('Test', 'Development', 'Release')) {
        throw "Unsupported archive stream in build context: $stream"
    }
    $runName = [string]$context.buildId
    if (-not $runName) { throw 'Build context does not contain a build ID.' }
    $stagingPath = Join-Path (Join-Path $ArchiveRoot 'Staging') $runName
    $finalPath = Join-Path (Join-Path (Join-Path $ArchiveRoot 'Runs') $stream) $runName

    if (Test-Path -LiteralPath $stagingPath) { throw "Archive staging path already exists: $stagingPath" }
    if (Test-Path -LiteralPath $finalPath) { throw "Immutable archive path already exists: $finalPath" }
    New-Item -ItemType Directory -Path $stagingPath | Out-Null

    function Copy-ArchiveTree {
        param([string]$Source, [string]$Destination)
        if (-not (Test-Path -LiteralPath $Source)) { return }
        New-Item -ItemType Directory -Force -Path $Destination | Out-Null
        Invoke-LoggedProcess -Stage 'Immutable Archive' -FilePath 'robocopy.exe' -Arguments @(
            $Source, $Destination, '/E', '/R:2', '/W:2', '/NFL', '/NDL', '/NP', '/NJH', '/NJS'
        ) -SuccessExitCodes @(0, 1, 2, 3, 4, 5, 6, 7) | Out-Null
    }

    Copy-ArchiveTree -Source $script:LogRoot -Destination (Join-Path $stagingPath 'Logs')
    Copy-ArchiveTree -Source $script:MetadataRoot -Destination (Join-Path $stagingPath 'Metadata')
    Copy-ArchiveTree -Source $script:TestRoot -Destination (Join-Path $stagingPath 'Tests')
    if ($Result -eq 'Success') {
        $packagePath = Get-RequiredPath -Path (Join-Path $script:OutputRoot 'Windows') -Description 'Verified package required for a successful archive'
        Copy-ArchiveTree -Source $packagePath -Destination (Join-Path $stagingPath 'Package\Windows')
    }

    $packageSummary = $null
    $packageSummaryPath = Join-Path $script:MetadataRoot 'PackageSummary.json'
    if (Test-Path -LiteralPath $packageSummaryPath) {
        $packageSummary = Get-Content -Raw -LiteralPath $packageSummaryPath | ConvertFrom-Json
    }

    $stages = @()
    $stagesPath = Join-Path $script:MetadataRoot 'stages.ndjson'
    if (Test-Path -LiteralPath $stagesPath) {
        $stages = @(Get-Content -LiteralPath $stagesPath | Where-Object { $_ } | ForEach-Object { $_ | ConvertFrom-Json })
    }
    $failureStage = @($stages | Where-Object { $_.result -eq 'Failed' } | Select-Object -Last 1)

    $testSummary = [ordered]@{ tests = 0; failures = 0; skipped = 0 }
    $junitPath = Join-Path $script:TestRoot 'junit.xml'
    if (Test-Path -LiteralPath $junitPath) {
        [xml]$junit = Get-Content -Raw -LiteralPath $junitPath
        $testSummary.tests = [int]$junit.testsuite.tests
        $testSummary.failures = [int]$junit.testsuite.failures
        $testSummary.skipped = [int]$junit.testsuite.skipped
    }

    $changelog = @()
    $rawLog = Get-GitText -Arguments @('log', '-20', '--pretty=format:%H%x1f%an%x1f%ad%x1f%s', '--date=iso-strict') -AllowFailure
    $logLines = @($rawLog -split "`r?`n")
    foreach ($line in $logLines) {
        $parts = $line -split [char]0x1f, 4
        if ($parts.Count -eq 4) {
            $changelog += [ordered]@{ commit = $parts[0]; author = $parts[1]; date = $parts[2]; subject = $parts[3] }
        }
    }

    $diagnostic = ''
    $failedLog = Get-ChildItem -LiteralPath $script:LogRoot -Filter '*.native.log' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime | Select-Object -Last 1
    if ($failedLog) {
        $diagnostic = (@(Get-Content -LiteralPath $failedLog.FullName -Tail 30) -join [Environment]::NewLine)
        if ($diagnostic.Length -gt 12000) { $diagnostic = $diagnostic.Substring($diagnostic.Length - 12000) }
    }

    $manifest = [ordered]@{
        schemaVersion     = 2
        runName           = $runName
        buildId           = $context.buildId
        buildComputer     = $context.buildComputer
        result            = $Result
        stream            = $stream
        startedUtc        = $context.startedUtc
        archivedUtc       = [DateTime]::UtcNow.ToString('o')
        project           = $context.project
        jobName           = $context.jobName
        buildNumber       = $context.buildNumber
        buildUrl          = $context.buildUrl
        commit            = $context.commit
        shortCommit       = $context.shortCommit
        tag               = $context.tag
        branch            = $context.branch
        author            = $context.author
        subject           = $context.subject
        configuration     = $context.configuration
        platform          = $context.platform
        engineVersion     = $context.engineVersion
        itchTarget        = 'kioskars/risbacka-jam-26'
        itchPage          = 'https://kioskars.itch.io/risbacka-jam-26'
        itchChannel       = $context.channel
        itchVersion       = $context.version
        failureStage      = $(if ($failureStage.Count -gt 0) { $failureStage[0].name } else { '' })
        diagnosticExcerpt = $diagnostic
        tests             = $testSummary
        stages            = $stages
        package           = $packageSummary
        promotions        = @()
        changelog         = $changelog
        archivePath       = $finalPath
        diskFreeGBBefore  = $freeGBBefore
    }

    $manifestPath = Join-Path $stagingPath 'manifest.json'
    $manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    if ($Result -eq 'Success') {
        $checksumRoot = Join-Path $stagingPath 'Package\Windows'
        $checksumLines = Get-ChildItem -LiteralPath $checksumRoot -File -Recurse | Sort-Object FullName | ForEach-Object {
            $hash = Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName
            $relative = $_.FullName.Substring($checksumRoot.Length).TrimStart('\').Replace('\', '/')
            "$($hash.Hash.ToLowerInvariant())  $relative"
        }
        $checksumLines | Set-Content -LiteralPath (Join-Path $stagingPath 'SHA256SUMS.txt') -Encoding ASCII
    }

    Move-Item -LiteralPath $stagingPath -Destination $finalPath
    Copy-Item -LiteralPath (Join-Path $finalPath 'manifest.json') -Destination (Join-Path (Join-Path $ArchiveRoot 'History') "$runName.json")
    Set-Content -LiteralPath (Join-Path $script:MetadataRoot 'ArchivedRunPath.txt') -Value $finalPath -Encoding UTF8
    Write-CILog -Stage 'Immutable Archive' -Message "Published immutable $Result archive: $finalPath"
}
