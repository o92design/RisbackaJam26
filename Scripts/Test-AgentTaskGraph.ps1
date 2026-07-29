[CmdletBinding()]
param(
    [string]$GraphPath = (Join-Path $PSScriptRoot '..\Agent-Orchestration\task-graph.json')
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$resolvedGraph = (Resolve-Path $GraphPath).Path
$graph = Get-Content -Raw -LiteralPath $resolvedGraph | ConvertFrom-Json
$errors = [System.Collections.Generic.List[string]]::new()

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
    if ($Milestone -eq 'done') {
        return $Status -eq 'DONE'
    }
    return $false
}

if ($graph.schema_version -ne 1) {
    $errors.Add("Unsupported schema_version '$($graph.schema_version)'.")
}

$allowedStatuses = @(
    'BLOCKED', 'READY', 'IN_PROGRESS', 'REVIEW_READY', 'IN_REVIEW',
    'CHANGES_REQUESTED', 'DONE'
)
$allowedMilestones = @('review_ready', 'done')
$nodeById = @{}
$statusById = @{}

foreach ($node in $graph.nodes) {
    if ($nodeById.ContainsKey($node.id)) {
        $errors.Add("Duplicate node id '$($node.id)'.")
        continue
    }
    $nodeById[$node.id] = $node

    $taskPath = Join-Path $repoRoot ($node.file -replace '/', '\')
    if (-not (Test-Path -LiteralPath $taskPath -PathType Leaf)) {
        $errors.Add("Missing task file for '$($node.id)': $($node.file)")
        continue
    }

    try {
        $frontmatter = Get-TaskFrontmatter -Path $taskPath
        if ($frontmatter.id -ne $node.id) {
            $errors.Add("ID mismatch for '$($node.id)': task file has '$($frontmatter.id)'.")
        }
        if ($frontmatter.status -notin $allowedStatuses) {
            $errors.Add("Invalid status '$($frontmatter.status)' for '$($node.id)'.")
        }
        $statusById[$node.id] = $frontmatter.status
    }
    catch {
        $errors.Add($_.Exception.Message)
    }
}

$adjacency = @{}
$indegree = @{}
function Add-Vertex {
    param([string]$Vertex)
    if (-not $adjacency.ContainsKey($Vertex)) {
        $adjacency[$Vertex] = [System.Collections.Generic.List[string]]::new()
        $indegree[$Vertex] = 0
    }
}
function Add-Edge {
    param([string]$From, [string]$To)
    Add-Vertex $From
    Add-Vertex $To
    if (-not $adjacency[$From].Contains($To)) {
        $adjacency[$From].Add($To)
        $indegree[$To] = [int]$indegree[$To] + 1
    }
}

foreach ($node in $graph.nodes) {
    $start = "$($node.id):start"
    $reviewReady = "$($node.id):review_ready"
    $done = "$($node.id):done"
    Add-Edge $start $reviewReady
    Add-Edge $reviewReady $done

    foreach ($dependency in @($node.start_after)) {
        if (-not $nodeById.ContainsKey($dependency.id)) {
            $errors.Add("'$($node.id)' references missing start dependency '$($dependency.id)'.")
            continue
        }
        if ($dependency.milestone -notin $allowedMilestones) {
            $errors.Add("'$($node.id)' has invalid milestone '$($dependency.milestone)'.")
            continue
        }
        Add-Edge "$($dependency.id):$($dependency.milestone)" $start
    }

    foreach ($dependency in @($node.done_after)) {
        if (-not $nodeById.ContainsKey($dependency.id)) {
            $errors.Add("'$($node.id)' references missing done dependency '$($dependency.id)'.")
            continue
        }
        if ($dependency.milestone -notin $allowedMilestones) {
            $errors.Add("'$($node.id)' has invalid milestone '$($dependency.milestone)'.")
            continue
        }
        Add-Edge "$($dependency.id):$($dependency.milestone)" $done
    }
}

$queue = [System.Collections.Generic.Queue[string]]::new()
foreach ($vertex in $indegree.Keys) {
    if ($indegree[$vertex] -eq 0) {
        $queue.Enqueue($vertex)
    }
}

$visited = 0
while ($queue.Count -gt 0) {
    $vertex = $queue.Dequeue()
    $visited++
    foreach ($next in $adjacency[$vertex]) {
        $indegree[$next] = [int]$indegree[$next] - 1
        if ($indegree[$next] -eq 0) {
            $queue.Enqueue($next)
        }
    }
}
if ($visited -ne $indegree.Count) {
    $cycleVertices = @($indegree.Keys | Where-Object { $indegree[$_] -gt 0 } | Sort-Object)
    $errors.Add("Dependency cycle detected around: $($cycleVertices -join ', ')")
}

foreach ($node in $graph.nodes) {
    if ($statusById[$node.id] -ne 'READY') {
        continue
    }
    foreach ($dependency in @($node.start_after)) {
        if (-not $statusById.ContainsKey($dependency.id)) {
            continue
        }
        if (-not (Test-MilestoneReached $statusById[$dependency.id] $dependency.milestone)) {
            $errors.Add(
                "'$($node.id)' is READY but '$($dependency.id):$($dependency.milestone)' " +
                "is not reached (status $($statusById[$dependency.id]))."
            )
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

$readyCount = @($statusById.Values | Where-Object { $_ -eq 'READY' }).Count
Write-Host (
    "Agent task graph valid: {0} nodes, {1} milestone vertices, {2} task(s) READY." -f
    $graph.nodes.Count, $indegree.Count, $readyCount
)
