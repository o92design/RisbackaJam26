Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$script:LogRoot = Join-Path $script:RepositoryRoot 'BuildLogs'
$script:MetadataRoot = Join-Path $script:RepositoryRoot 'BuildMetadata'
$script:TestRoot = Join-Path $script:RepositoryRoot 'TestOutput'
$script:OutputRoot = Join-Path $script:RepositoryRoot 'BuildOutput'

function Initialize-CIDirectories {
    foreach ($path in @($script:LogRoot, $script:MetadataRoot, $script:TestRoot)) {
        New-Item -ItemType Directory -Force -Path $path | Out-Null
    }
}

function Write-CILog {
    param(
        [Parameter(Mandatory)][string]$Stage,
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('INFO', 'WARN', 'ERROR')][string]$Level = 'INFO'
    )

    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
    $line = "[$timestamp] [$Stage] [$Level] $Message"
    Write-Host $line

    Initialize-CIDirectories
    $safeStage = $Stage -replace '[^A-Za-z0-9_.-]', '-'
    Add-Content -LiteralPath (Join-Path $script:LogRoot "$safeStage.log") -Value $line -Encoding UTF8
}

function Get-RequiredPath {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Description
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Description was not found: $Path"
    }
    return (Resolve-Path -LiteralPath $Path).Path
}

function Get-UEPaths {
    param([string]$UERoot = $(if ($env:UE_ROOT) { $env:UE_ROOT } else { 'C:\Epic\UE_5.8' }))

    [pscustomobject]@{
        Root          = $UERoot
        RunUAT        = Join-Path $UERoot 'Engine\Build\BatchFiles\RunUAT.bat'
        EditorCmd     = Join-Path $UERoot 'Engine\Binaries\Win64\UnrealEditor-Cmd.exe'
        Project       = Join-Path $script:RepositoryRoot 'RisbackaJam26Game\RisbackaJam26Game.uproject'
        PackageFolder = Join-Path $script:OutputRoot 'Windows'
    }
}

function Get-SanitizedCommand {
    param([string]$FilePath, [string[]]$Arguments)

    $joined = @($Arguments | ForEach-Object {
        if ($_ -match '(?i)(api[_-]?key|token|password|secret)') { '<redacted>' }
        elseif ($_ -match '\s') { '"' + ($_ -replace '"', '\"') + '"' }
        else { $_ }
    }) -join ' '
    return "$FilePath $joined"
}

function Invoke-LoggedProcess {
    param(
        [Parameter(Mandatory)][string]$Stage,
        [Parameter(Mandatory)][string]$FilePath,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory = $script:RepositoryRoot,
        [int[]]$SuccessExitCodes = @(0)
    )

    Initialize-CIDirectories
    $safeStage = $Stage -replace '[^A-Za-z0-9_.-]', '-'
    $nativeLog = Join-Path $script:LogRoot "$safeStage.native.log"
    Write-CILog -Stage $Stage -Message "Command: $(Get-SanitizedCommand -FilePath $FilePath -Arguments $Arguments)"

    $started = Get-Date
    Push-Location $WorkingDirectory
    try {
        $previousErrorAction = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            & $FilePath @Arguments 2>&1 | Tee-Object -FilePath $nativeLog
            $exitCode = $LASTEXITCODE
        }
        finally {
            $ErrorActionPreference = $previousErrorAction
        }
    }
    finally {
        Pop-Location
    }

    $elapsed = (Get-Date) - $started
    Write-CILog -Stage $Stage -Message ("Exit code {0}; elapsed {1:c}" -f $exitCode, $elapsed)
    if ($SuccessExitCodes -notcontains $exitCode) {
        throw "$Stage failed with exit code $exitCode. See $nativeLog"
    }
    return $exitCode
}

function Get-GitText {
    param([Parameter(Mandatory)][string[]]$Arguments, [switch]$AllowFailure)

    $safeOption = "safe.directory=$($script:RepositoryRoot.Replace('\', '/'))"
    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $output = & git -c $safeOption @Arguments 2>$null
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorAction
    }
    if ($exitCode -ne 0 -and -not $AllowFailure) {
        throw "git $($Arguments -join ' ') failed with exit code $exitCode"
    }
    return ($output | Out-String).Trim()
}

function Start-CIStage {
    param([Parameter(Mandatory)][string]$Name)
    Initialize-CIDirectories
    Write-CILog -Stage $Name -Message 'Started.'
    return [Diagnostics.Stopwatch]::StartNew()
}

function Complete-CIStage {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][Diagnostics.Stopwatch]$Stopwatch,
        [ValidateSet('Success', 'Failed', 'Unstable')][string]$Result,
        [string]$Detail = ''
    )

    $Stopwatch.Stop()
    $record = [ordered]@{
        name            = $Name
        result          = $Result
        elapsedSeconds  = [Math]::Round($Stopwatch.Elapsed.TotalSeconds, 3)
        completedUtc    = [DateTime]::UtcNow.ToString('o')
        detail          = $Detail
    }

    Initialize-CIDirectories
    $path = Join-Path $script:MetadataRoot 'stages.ndjson'
    Add-Content -LiteralPath $path -Value ($record | ConvertTo-Json -Compress) -Encoding UTF8
    $level = if ($Result -eq 'Success') { 'INFO' } elseif ($Result -eq 'Unstable') { 'WARN' } else { 'ERROR' }
    Write-CILog -Stage $Name -Level $level -Message ("Completed as {0} in {1:n3}s. {2}" -f $Result, $Stopwatch.Elapsed.TotalSeconds, $Detail)
}

function Invoke-CIStage {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][scriptblock]$Body
    )

    $timer = Start-CIStage -Name $Name
    try {
        & $Body
        Complete-CIStage -Name $Name -Stopwatch $timer -Result Success
    }
    catch {
        Complete-CIStage -Name $Name -Stopwatch $timer -Result Failed -Detail $_.Exception.Message
        throw
    }
}

function Read-BuildContext {
    $path = Join-Path $script:MetadataRoot 'BuildContext.json'
    Get-RequiredPath -Path $path -Description 'Build context' | Out-Null
    return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json
}

Initialize-CIDirectories
