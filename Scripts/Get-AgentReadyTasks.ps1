[CmdletBinding()]
param(
    [string]$GraphPath = (Join-Path $PSScriptRoot '..\Agent-Orchestration\task-graph.json'),
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$graph = Get-Content -Raw -LiteralPath (Resolve-Path $GraphPath) | ConvertFrom-Json

function Get-TaskFrontmatter {
    param([string]$Path)

    $content = Get-Content -Raw -LiteralPath $Path
    if ($content -notmatch '(?s)\A---\s*\r?\n(.*?)\r?\n---') {
        throw "Missing YAML frontmatter: $Path"
    }
    $result = @{}
    foreach ($line in ($Matches[1] -split '\r?\n')) {
        if ($line -match '^([A-Za-z0-9_-]+):\s*(.*?)\s*$') {
            $result[$Matches[1]] = $Matches[2].Trim("'`"")
        }
    }
    return $result
}

function Test-MilestoneReached {
    param([string]$Status, [string]$Milestone)
    if ($Milestone -eq 'review_ready') {
        return $Status -in @('REVIEW_READY', 'IN_REVIEW', 'DONE')
    }
    return $Milestone -eq 'done' -and $Status -eq 'DONE'
}

$frontmatterById = @{}
foreach ($node in $graph.nodes) {
    $path = Join-Path $repoRoot ($node.file -replace '/', '\')
    $frontmatterById[$node.id] = Get-TaskFrontmatter $path
}

$result = foreach ($node in $graph.nodes) {
    $metadata = $frontmatterById[$node.id]
    if ($metadata.status -notin @('BLOCKED', 'READY')) {
        continue
    }

    $unmet = @(
        foreach ($dependency in @($node.start_after)) {
            $dependencyStatus = $frontmatterById[$dependency.id].status
            if (-not (Test-MilestoneReached $dependencyStatus $dependency.milestone)) {
                "$($dependency.id):$($dependency.milestone) [$dependencyStatus]"
            }
        }
    )
    if ($unmet.Count -gt 0) {
        continue
    }

    [pscustomobject]@{
        Id = $node.id
        CurrentStatus = $metadata.status
        SchedulingState = if ($metadata.status -eq 'READY') {
            'CLAIMABLE'
        } else {
            'CAN_MARK_READY'
        }
        Kind = $node.kind
        File = $node.file
        LeaseKeys = @($node.lease_keys) -join ', '
    }
}

if ($Json) {
    $result | ConvertTo-Json -Depth 4
} else {
    $result | Format-Table -AutoSize
}
