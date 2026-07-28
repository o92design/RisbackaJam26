[CmdletBinding()]
param(
    [ValidateSet('Development', 'Shipping')][string]$Configuration = 'Development',
    [string]$Channel = 'windows-dev',
    [string]$Version
)

. (Join-Path $PSScriptRoot 'Common.ps1')

# Jenkins intentionally preserves Unreal caches, but run diagnostics must be isolated.
foreach ($path in @($script:LogRoot, $script:MetadataRoot, $script:TestRoot)) {
    $resolved = [IO.Path]::GetFullPath($path)
    if (-not $resolved.StartsWith($script:RepositoryRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to clean CI state outside the repository: $resolved"
    }
    if (Test-Path -LiteralPath $resolved) {
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
Initialize-CIDirectories

Invoke-CIStage -Name 'Build Context' -Body {
    $sha = Get-GitText -Arguments @('rev-parse', 'HEAD')
    $branch = Get-GitText -Arguments @('rev-parse', '--abbrev-ref', 'HEAD')
    $exactTag = Get-GitText -Arguments @('describe', '--tags', '--exact-match', 'HEAD') -AllowFailure
    $author = Get-GitText -Arguments @('show', '-s', '--format=%an <%ae>', 'HEAD')
    $subject = Get-GitText -Arguments @('show', '-s', '--format=%s', 'HEAD')
    $shortCommit = $sha.Substring(0, [Math]::Min(12, $sha.Length))
    $buildNumber = if ($env:BUILD_NUMBER) { $env:BUILD_NUMBER } else { 'local' }
    $buildComputer = [Environment]::MachineName
    $startedUtc = [DateTime]::UtcNow
    $stream = if ($Configuration -eq 'Shipping') { 'Release' } else { 'Development' }

    $safeComputer = $buildComputer -replace '[^A-Za-z0-9_.-]', '-'
    $safeBuildNumber = ([string]$buildNumber) -replace '[^A-Za-z0-9_.-]', '-'
    $buildIdParts = @(
        'Build',
        $safeComputer,
        $startedUtc.ToString("yyyyMMdd-HHmmss'Z'"),
        $stream
    )
    if ($stream -eq 'Release' -and $exactTag) {
        $buildIdParts += ($exactTag -replace '[^A-Za-z0-9_.-]', '-')
    }
    $buildIdParts += @('Build', $safeBuildNumber, $shortCommit)
    $buildId = $buildIdParts -join '-'

    if (-not $Version) {
        $Version = $buildId
    }

    $context = [ordered]@{
        schemaVersion  = 2
        project        = 'RisbackaJam26Game'
        displayName    = 'Risbacka Jam 26'
        jobName        = $(if ($env:JOB_NAME) { $env:JOB_NAME } else { 'local' })
        buildNumber    = $buildNumber
        buildComputer  = $buildComputer
        buildId        = $buildId
        buildUrl       = $(if ($env:BUILD_URL) { $env:BUILD_URL } else { '' })
        branch         = $branch
        tag            = $exactTag
        commit         = $sha
        shortCommit    = $shortCommit
        author         = $author
        subject        = $subject
        configuration  = $Configuration
        platform       = 'Win64'
        channel        = $Channel
        version        = $Version
        engineVersion  = '5.8'
        startedUtc     = $startedUtc.ToString('o')
        workspace      = $script:RepositoryRoot
    }

    $path = Join-Path $script:MetadataRoot 'BuildContext.json'
    $context | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $path -Encoding UTF8
    Write-CILog -Stage 'Build Context' -Message "Build ID $buildId; $Configuration, $Channel, version $Version."
}
