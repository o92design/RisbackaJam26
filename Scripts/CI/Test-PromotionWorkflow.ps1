[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Promotion Workflow Self-Test' -Body {
    $stamp = [DateTime]::UtcNow.ToString('yyyyMMdd-HHmmssfff')
    $buildId = "Build-SELFTEST-$stamp`Z-Test-Build-42-0123456789ab"
    $validationRoot = Join-Path $script:RepositoryRoot ".cache\PromotionWorkflowValidation\$stamp"
    $archiveRoot = Join-Path $validationRoot 'Archive'
    $runPath = Join-Path (Join-Path $archiveRoot 'Runs\Test') $buildId
    $packageDirectory = Join-Path $runPath 'Package\Windows'
    $historyRoot = Join-Path $archiveRoot 'History'
    New-Item -ItemType Directory -Force -Path $packageDirectory, $historyRoot | Out-Null

    Set-Content -LiteralPath (Join-Path $packageDirectory 'RisbackaJam26Game.exe') -Value 'promotion self-test executable' -Encoding ASCII
    New-Item -ItemType Directory -Force -Path (Join-Path $packageDirectory 'Content') | Out-Null
    Set-Content -LiteralPath (Join-Path $packageDirectory 'Content\fixture.pak') -Value 'promotion self-test package' -Encoding ASCII

    $checksumLines = Get-ChildItem -LiteralPath $packageDirectory -File -Recurse | Sort-Object FullName | ForEach-Object {
        $hash = Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName
        $relative = $_.FullName.Substring($packageDirectory.Length).TrimStart('\').Replace('\', '/')
        "$($hash.Hash.ToLowerInvariant())  $relative"
    }
    $checksumLines | Set-Content -LiteralPath (Join-Path $runPath 'SHA256SUMS.txt') -Encoding ASCII

    $manifest = [ordered]@{
        schemaVersion  = 2
        runName        = $buildId
        buildId        = $buildId
        buildComputer  = 'SELFTEST'
        result         = 'Success'
        stream         = 'Test'
        startedUtc     = [DateTime]::UtcNow.AddMinutes(-1).ToString('o')
        archivedUtc    = [DateTime]::UtcNow.ToString('o')
        project        = 'RisbackaJam26Game'
        jobName        = 'self-test'
        buildNumber    = '42'
        buildUrl       = ''
        commit         = '0123456789abcdef0123456789abcdef01234567'
        shortCommit    = '0123456789ab'
        tag            = ''
        branch         = 'master'
        author         = 'Promotion Self-Test'
        subject        = 'Validate promotion workflow'
        configuration  = 'Development'
        platform       = 'Win64'
        engineVersion  = '5.8'
        itchTarget     = 'kioskars/risbacka-jam-26'
        itchPage       = 'https://kioskars.itch.io/risbacka-jam-26'
        itchChannel    = 'windows-test'
        itchVersion    = $buildId
        failureStage   = ''
        tests          = [ordered]@{ tests = 1; failures = 0; skipped = 0 }
        stages         = @([ordered]@{ name = 'Self-Test'; result = 'Success'; elapsedSeconds = 1 })
        package        = [ordered]@{ sizeBytes = 64; fileCount = 2 }
        promotions     = @()
        changelog      = @()
        archivePath    = $runPath
    }
    $manifestPath = Join-Path $runPath 'manifest.json'
    $manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $historyRoot "$buildId.json")

    & (Join-Path $PSScriptRoot 'New-PromotionContext.ps1') `
        -BuildId $buildId `
        -ArchiveRoot $archiveRoot `
        -Target 'kioskars/risbacka-jam-26' `
        -Channel 'windows-dev' `
        -PreserveDiagnostics
    & (Join-Path $PSScriptRoot 'Test-ArchivedPackage.ps1')

    $fixturePath = Join-Path $packageDirectory 'Content\fixture.pak'
    Set-Content -LiteralPath $fixturePath -Value 'tampered promotion package' -Encoding ASCII
    $tamperRejected = $false
    try {
        & (Join-Path $PSScriptRoot 'Test-ArchivedPackage.ps1')
    }
    catch {
        if ($_.Exception.Message -match 'SHA-256 mismatch') {
            $tamperRejected = $true
        }
        else {
            throw
        }
    }
    if (-not $tamperRejected) {
        throw 'Checksum validation accepted a tampered archived package.'
    }
    Set-Content -LiteralPath $fixturePath -Value 'promotion self-test package' -Encoding ASCII
    & (Join-Path $PSScriptRoot 'Test-ArchivedPackage.ps1')

    & (Join-Path $PSScriptRoot 'Finalize-Promotion.ps1') -ArchiveRoot $archiveRoot
    & (Join-Path $PSScriptRoot 'Update-Dashboard.ps1') -ArchiveRoot $archiveRoot -PublishRoot ''

    $finalManifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if (@($finalManifest.promotions).Count -ne 1 -or $finalManifest.promotions[0].channel -ne 'windows-dev') {
        throw 'Promotion was not recorded in the source manifest.'
    }
    $promotionRecords = @(Get-ChildItem -LiteralPath (Join-Path $archiveRoot 'Promotions') -Filter '*.json' -File)
    if ($promotionRecords.Count -ne 1) {
        throw "Expected one promotion record, found $($promotionRecords.Count)."
    }
    $dashboard = Get-Content -Raw -LiteralPath (Join-Path $archiveRoot 'Dashboard\index.html')
    if (-not $dashboard.Contains('windows-dev') -or -not $dashboard.Contains($buildId)) {
        throw 'Promotion dashboard does not contain the promoted channel and Build ID.'
    }
    Write-CILog -Stage 'Promotion Workflow Self-Test' -Message "Validated archive selection, checksums, promotion recording, and dashboard under $validationRoot."
}
