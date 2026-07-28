[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

$context = Read-PromotionContext
& (Join-Path $PSScriptRoot 'Upload-Butler.ps1') `
    -Target $context.target `
    -Channel $context.channel `
    -Version $context.version `
    -PackageDirectory $context.packageDirectory
