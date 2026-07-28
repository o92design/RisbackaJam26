[CmdletBinding()]
param([Parameter(Mandatory)][string]$PackageDirectory)

. (Join-Path $PSScriptRoot 'Common.ps1')

$context = Read-BuildContext
$buildInfo = [ordered]@{
    project        = $context.project
    displayName    = $context.displayName
    jobName        = $context.jobName
    buildNumber    = $context.buildNumber
    buildComputer  = $context.buildComputer
    buildId        = $context.buildId
    commit         = $context.commit
    tag            = $context.tag
    subject        = $context.subject
    author         = $context.author
    stream         = $context.stream
    configuration  = $context.configuration
    engineVersion  = $context.engineVersion
    platform       = $context.platform
    itchChannel    = $context.channel
    itchVersion    = $context.version
    startedUtc     = $context.startedUtc
    builtUtc       = [DateTime]::UtcNow.ToString('o')
}
$buildInfo | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $PackageDirectory 'BuildInfo.json') -Encoding UTF8
