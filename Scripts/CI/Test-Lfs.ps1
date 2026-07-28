[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Git LFS Validation' -Body {
    Get-RequiredPath -Path (Join-Path $script:RepositoryRoot '.gitattributes') -Description '.gitattributes' | Out-Null
    $safeOption = "safe.directory=$($script:RepositoryRoot.Replace('\', '/'))"
    $head = Get-GitText -Arguments @('rev-parse', '--verify', 'HEAD') -AllowFailure
    if ($head) {
        Invoke-LoggedProcess -Stage 'Git LFS Validation' -FilePath 'git' -Arguments @('-c', $safeOption, 'lfs', 'fsck') | Out-Null
    }
    else {
        Write-CILog -Stage 'Git LFS Validation' -Level WARN -Message 'HEAD does not exist yet; validating the initial index without git lfs fsck.'
    }

    $trackedAssets = @(Get-GitText -Arguments @('ls-files', '*.uasset', '*.umap') | Where-Object { $_ })
    $lfsAssets = @(Get-GitText -Arguments @('lfs', 'ls-files', '--name-only') | Where-Object { $_ })

    # Convert multiline strings to collections when PowerShell returns one scalar.
    $trackedAssets = @($trackedAssets -split "`r?`n" | Where-Object { $_ })
    $lfsSet = @{}
    foreach ($path in @($lfsAssets -split "`r?`n" | Where-Object { $_ })) {
        $lfsSet[$path.Replace('\', '/')] = $true
    }

    $missing = @($trackedAssets | Where-Object { -not $lfsSet[$_.Replace('\', '/')] })
    if ($missing.Count -gt 0) {
        throw "$($missing.Count) committed Unreal binary asset(s) are not in Git LFS. First: $($missing[0])"
    }
    if ($trackedAssets.Count -eq 0) {
        throw 'No committed .uasset or .umap files were found.'
    }

    Write-CILog -Stage 'Git LFS Validation' -Message "$($trackedAssets.Count) committed Unreal assets are stored through Git LFS."
}
