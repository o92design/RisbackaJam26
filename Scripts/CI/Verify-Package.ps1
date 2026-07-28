[CmdletBinding()]
param(
    [string]$UERoot = $(if ($env:UE_ROOT) { $env:UE_ROOT } else { 'C:\Epic\UE_5.8' }),
    [int]$StartupSeconds = 20,
    [switch]$SkipStartupSmoke
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Package Verification' -Body {
    $paths = Get-UEPaths -UERoot $UERoot
    $packageDirectory = Get-RequiredPath -Path $paths.PackageFolder -Description 'Packaged Windows directory'
    $exe = Get-ChildItem -LiteralPath $packageDirectory -Filter '*.exe' -File | Where-Object { $_.Name -eq 'RisbackaJam26Game.exe' } | Select-Object -First 1
    if (-not $exe) { throw "Top-level RisbackaJam26Game.exe is missing from $packageDirectory" }

    $files = @(Get-ChildItem -LiteralPath $packageDirectory -File -Recurse)
    if ($files.Count -lt 5) { throw "Packaged output is unexpectedly small ($($files.Count) files)." }
    $bytes = ($files | Measure-Object -Property Length -Sum).Sum
    if ($bytes -lt 1MB) { throw "Packaged output is unexpectedly small ($bytes bytes)." }

    & (Join-Path $PSScriptRoot 'Write-BuildInfo.ps1') -PackageDirectory $packageDirectory

    if (-not $SkipStartupSmoke) {
        Write-CILog -Stage 'Package Verification' -Message "Starting packaged executable for a $StartupSeconds-second smoke window."
        $process = Start-Process -FilePath $exe.FullName -ArgumentList @('-nullrhi', '-nosplash', '-unattended', '-NoSound') -PassThru
        try {
            $deadline = [DateTime]::UtcNow.AddSeconds($StartupSeconds)
            while (-not $process.HasExited -and [DateTime]::UtcNow -lt $deadline) {
                Start-Sleep -Milliseconds 250
            }

            if ($process.HasExited) {
                if ($process.ExitCode -ne 0) {
                    throw "Packaged executable exited early with code $($process.ExitCode)."
                }
                Write-CILog -Stage 'Package Verification' -Level WARN -Message 'Packaged executable exited cleanly before the smoke window ended.'
            }
            else {
                Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
                $process.WaitForExit()
                Write-CILog -Stage 'Package Verification' -Message 'Startup smoke window completed without an early crash.'
            }
        }
        finally {
            if (-not $process.HasExited) {
                Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
            }
        }
    }

    $summary = [ordered]@{
        executable = $exe.Name
        fileCount  = $files.Count
        sizeBytes  = [long]$bytes
        verifiedUtc = [DateTime]::UtcNow.ToString('o')
    }
    $summary | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $script:MetadataRoot 'PackageSummary.json') -Encoding UTF8
    Write-CILog -Stage 'Package Verification' -Message ("Verified {0} files ({1:n2} MB)." -f $files.Count, ($bytes / 1MB))
}
