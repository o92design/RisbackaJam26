[CmdletBinding()]
param(
    [string]$ArchiveRoot = $(if ($env:ARCHIVE_ROOT) { $env:ARCHIVE_ROOT } else { 'D:\RisbackaJam26' }),
    [string]$PublishRoot = $(if ($env:JENKINS_HOME) { Join-Path $env:JENKINS_HOME 'userContent\RisbackaJam26' } else { '' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

function ConvertTo-HtmlText([object]$value) {
    return [Net.WebUtility]::HtmlEncode([string]$value)
}

Invoke-CIStage -Name 'Dashboard' -Body {
    if (-not [IO.Path]::IsPathRooted($ArchiveRoot)) {
        $ArchiveRoot = Join-Path $script:RepositoryRoot $ArchiveRoot
    }
    $ArchiveRoot = [IO.Path]::GetFullPath($ArchiveRoot)
    $historyPath = Get-RequiredPath -Path (Join-Path $ArchiveRoot 'History') -Description 'Archive history'
    $dashboardPath = Join-Path $ArchiveRoot 'Dashboard'
    New-Item -ItemType Directory -Force -Path $dashboardPath | Out-Null

    $runs = @(Get-ChildItem -LiteralPath $historyPath -Filter '*.json' -File | ForEach-Object {
        try { Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json } catch { Write-CILog -Stage 'Dashboard' -Level WARN -Message "Skipping invalid manifest $($_.Name): $($_.Exception.Message)" }
    } | Sort-Object archivedUtc -Descending)

    $total = $runs.Count
    $successes = @($runs | Where-Object { $_.result -eq 'Success' }).Count
    $successRate = if ($total -gt 0) { [Math]::Round(($successes / $total) * 100, 1) } else { 0 }
    $latestDevelopment = $runs | Where-Object { $_.stream -eq 'Development' } | Select-Object -First 1
    $latestRelease = $runs | Where-Object { $_.stream -eq 'Release' } | Select-Object -First 1

    $rows = foreach ($run in ($runs | Select-Object -First 100)) {
        $class = if ($run.result -eq 'Success') { 'success' } elseif ($run.result -eq 'Unstable') { 'unstable' } else { 'failure' }
        $stockholm = try { [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Parse($run.archivedUtc), 'W. Europe Standard Time').ToString('yyyy-MM-dd HH:mm:ss') } catch { $run.archivedUtc }
        $duration = [Math]::Round((@($run.stages) | Measure-Object -Property elapsedSeconds -Sum).Sum, 1)
        $sizeMB = if ($run.package -and $run.package.sizeBytes) { [Math]::Round([double]$run.package.sizeBytes / 1MB, 1) } else { 0 }
        $jenkinsLink = if ($run.buildUrl) { "<a href='$(ConvertTo-HtmlText $run.buildUrl)'>Jenkins</a>" } else { 'local' }
        $tag = if ($run.tag) { ConvertTo-HtmlText $run.tag } else { '—' }
        @"
<tr class="$class">
  <td><span class="badge">$((ConvertTo-HtmlText $run.result))</span></td>
  <td>$((ConvertTo-HtmlText $run.stream))</td>
  <td>$((ConvertTo-HtmlText $stockholm))</td>
  <td>$((ConvertTo-HtmlText $run.buildNumber))</td>
  <td><code>$((ConvertTo-HtmlText $run.shortCommit))</code></td>
  <td>$tag</td>
  <td title="$((ConvertTo-HtmlText $run.subject))">$((ConvertTo-HtmlText $run.subject))</td>
  <td>$((ConvertTo-HtmlText $run.failureStage))</td>
  <td>$duration s</td>
  <td>$sizeMB MB</td>
  <td>$jenkinsLink · <a href="$((ConvertTo-HtmlText $run.itchPage))">itch.io</a></td>
</tr>
"@
    }

    $trendRuns = @($runs | Select-Object -First 20)
    [Array]::Reverse($trendRuns)
    $bars = ''
    for ($i = 0; $i -lt $trendRuns.Count; $i++) {
        $height = [Math]::Min(85, [Math]::Max(4, ((@($trendRuns[$i].stages) | Measure-Object -Property elapsedSeconds -Sum).Sum / 60)))
        $x = 8 + ($i * 24)
        $y = 92 - $height
        $color = if ($trendRuns[$i].result -eq 'Success') { '#50d890' } else { '#ff667d' }
        $bars += "<rect x='$x' y='$y' width='16' height='$height' rx='3' fill='$color'><title>$(ConvertTo-HtmlText $trendRuns[$i].runName)</title></rect>"
    }

    $latestDevText = if ($latestDevelopment) { "$($latestDevelopment.result) · #$($latestDevelopment.buildNumber) · $($latestDevelopment.shortCommit)" } else { 'No development builds yet' }
    $latestReleaseText = if ($latestRelease) { "$($latestRelease.result) · $($latestRelease.tag) · $($latestRelease.shortCommit)" } else { 'No releases yet' }
    $generated = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::UtcNow, 'W. Europe Standard Time').ToString('yyyy-MM-dd HH:mm:ss')

    $html = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta http-equiv="refresh" content="120">
<title>Risbacka Jam 26 · Build Dashboard</title>
<style>
:root{color-scheme:dark;--bg:#11151c;--panel:#1b2330;--ink:#edf3ff;--muted:#94a4ba;--line:#2c394b;--ok:#50d890;--bad:#ff667d;--warn:#ffca63}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(circle at top left,#243047 0,var(--bg) 38%);color:var(--ink);font:14px/1.45 system-ui,Segoe UI,sans-serif}
main{max-width:1500px;margin:auto;padding:30px}h1{margin:0;font-size:30px}header p{color:var(--muted);margin:.4rem 0 1.5rem}.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:12px}
.card,.chart,.table-wrap{background:rgba(27,35,48,.92);border:1px solid var(--line);border-radius:12px;padding:16px;box-shadow:0 16px 40px #0004}.label{color:var(--muted);font-size:12px;text-transform:uppercase;letter-spacing:.08em}.value{font-size:22px;margin-top:5px}
.chart{margin-top:12px}svg{width:100%;height:100px}.table-wrap{margin-top:12px;overflow:auto;padding:0}table{border-collapse:collapse;width:100%;white-space:nowrap}th,td{text-align:left;padding:10px 12px;border-bottom:1px solid var(--line);max-width:340px;overflow:hidden;text-overflow:ellipsis}th{position:sticky;top:0;background:#202a39;color:var(--muted)}code{color:#9ed4ff}
.badge{padding:3px 7px;border-radius:999px;background:#ffffff12}.success .badge{color:var(--ok)}.failure .badge{color:var(--bad)}.unstable .badge{color:var(--warn)}a{color:#8dc7ff}footer{color:var(--muted);margin-top:12px}
</style>
</head>
<body><main>
<header><h1>Risbacka Jam 26</h1><p>Jenkins build, test, package, archive, and itch.io history · Stockholm time</p></header>
<section class="cards">
  <div class="card"><div class="label">Build attempts</div><div class="value">$total</div></div>
  <div class="card"><div class="label">Success rate</div><div class="value">$successRate%</div></div>
  <div class="card"><div class="label">Latest development</div><div class="value">$(ConvertTo-HtmlText $latestDevText)</div></div>
  <div class="card"><div class="label">Latest release</div><div class="value">$(ConvertTo-HtmlText $latestReleaseText)</div></div>
</section>
<section class="chart"><div class="label">Recent duration trend (minutes; green success, red failure)</div><svg viewBox="0 0 500 100" preserveAspectRatio="none">$bars</svg></section>
<section class="table-wrap"><table><thead><tr><th>Result</th><th>Stream</th><th>Archived</th><th>Build</th><th>Commit</th><th>Tag</th><th>Subject</th><th>Failure stage</th><th>Duration</th><th>Package</th><th>Links</th></tr></thead><tbody>$($rows -join [Environment]::NewLine)</tbody></table></section>
<footer>Generated $generated · refreshes every two minutes · immutable data: $(ConvertTo-HtmlText $ArchiveRoot)</footer>
</main></body></html>
"@

    $dashboardFile = Join-Path $dashboardPath 'index.html'
    $html | Set-Content -LiteralPath $dashboardFile -Encoding UTF8
    $runs | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath (Join-Path $dashboardPath 'runs.json') -Encoding UTF8

    if ($PublishRoot) {
        New-Item -ItemType Directory -Force -Path $PublishRoot | Out-Null
        Invoke-LoggedProcess -Stage 'Dashboard' -FilePath 'robocopy.exe' -Arguments @(
            $dashboardPath, $PublishRoot, '/E', '/R:2', '/W:2', '/NFL', '/NDL', '/NP', '/NJH', '/NJS'
        ) -SuccessExitCodes @(0, 1, 2, 3, 4, 5, 6, 7) | Out-Null
        Write-CILog -Stage 'Dashboard' -Message "Published dashboard to $PublishRoot"
    }
}
