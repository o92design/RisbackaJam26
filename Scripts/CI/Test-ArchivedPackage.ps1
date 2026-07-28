[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Archived Package Verification' -Body {
    $context = Read-PromotionContext
    $packageDirectory = Get-RequiredPath -Path $context.packageDirectory -Description 'Archived Windows package'
    $checksumPath = Get-RequiredPath -Path $context.checksumPath -Description 'Archived SHA-256 manifest'
    Get-RequiredPath -Path (Join-Path $packageDirectory 'RisbackaJam26Game.exe') -Description 'Archived top-level game executable' | Out-Null

    $packagePrefix = $packageDirectory.TrimEnd('\') + '\'
    $verified = 0
    foreach ($line in Get-Content -LiteralPath $checksumPath) {
        if (-not $line) { continue }
        if ($line -notmatch '^(?<Hash>[0-9a-fA-F]{64})  (?<Path>.+)$') {
            throw "Invalid SHA256SUMS entry: $line"
        }
        $expectedHash = $Matches.Hash
        $relativePath = $Matches.Path.Replace('/', '\')
        if ([IO.Path]::IsPathRooted($relativePath)) {
            throw "Checksum entry must be relative: $relativePath"
        }
        $filePath = [IO.Path]::GetFullPath((Join-Path $packageDirectory $relativePath))
        if (-not $filePath.StartsWith($packagePrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Checksum entry escaped the package directory: $relativePath"
        }
        Get-RequiredPath -Path $filePath -Description "Archived checksum target '$relativePath'" | Out-Null
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $filePath).Hash
        if ($actual -ne $expectedHash) {
            throw "SHA-256 mismatch for archived file: $relativePath"
        }
        $verified++
    }
    if ($verified -eq 0) {
        throw 'Archived SHA-256 manifest did not contain any files.'
    }
    Write-CILog -Stage 'Archived Package Verification' -Message "Verified $verified archived files for $($context.buildId)."
}
