[CmdletBinding()]
param(
    [string]$ArchiveRoot = $(if ($env:ARCHIVE_ROOT) { $env:ARCHIVE_ROOT } else { 'D:\RisbackaJam26' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Promotion Finalization' -Body {
    $context = Read-PromotionContext
    if (-not [IO.Path]::IsPathRooted($ArchiveRoot)) {
        $ArchiveRoot = Join-Path $script:RepositoryRoot $ArchiveRoot
    }
    $ArchiveRoot = [IO.Path]::GetFullPath($ArchiveRoot)
    $manifestPath = Get-RequiredPath -Path $context.sourceManifestPath -Description 'Promoted Test build manifest'
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ([string]$manifest.buildId -ne [string]$context.buildId) {
        throw 'Promotion source manifest changed after validation.'
    }

    $promotedUtc = [DateTime]::UtcNow.ToString('o')
    $record = [ordered]@{
        schemaVersion        = 1
        buildId              = $context.buildId
        sourceCommit         = $context.sourceCommit
        sourceBuildNumber    = $context.sourceBuildNumber
        target               = $context.target
        channel              = $context.channel
        version              = $context.version
        promotedUtc          = $promotedUtc
        promotionJobName     = $context.promotionJobName
        promotionBuildNumber = $context.promotionBuildNumber
        promotionBuildUrl    = $context.promotionBuildUrl
        promotionComputer    = $context.promotionComputer
    }

    $promotions = @()
    if ($manifest.PSObject.Properties['promotions']) {
        $promotions = @($manifest.promotions)
    }
    if (@($promotions | Where-Object { $_.channel -eq $context.channel }).Count -gt 0) {
        throw "Build $($context.buildId) is already recorded as promoted to $($context.channel)."
    }
    $promotions += [pscustomobject]$record
    $manifest | Add-Member -NotePropertyName promotions -NotePropertyValue $promotions -Force
    $manifest | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    $historyRoot = Join-Path $ArchiveRoot 'History'
    $promotionsRoot = Join-Path $ArchiveRoot 'Promotions'
    New-Item -ItemType Directory -Force -Path $historyRoot, $promotionsRoot | Out-Null
    Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $historyRoot "$($context.buildId).json") -Force
    $recordName = '{0}-{1}-{2}.json' -f ([DateTime]::UtcNow.ToString('yyyyMMdd-HHmmssZ')), $context.buildId, $context.channel
    $recordPath = Join-Path $promotionsRoot $recordName
    $record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $recordPath -Encoding UTF8
    $record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $script:MetadataRoot 'Promotion.json') -Encoding UTF8
    Write-CILog -Stage 'Promotion Finalization' -Message "Recorded promotion of $($context.buildId) to $($context.channel)."
}
