[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ReportDirectory,
    [Parameter(Mandatory)][string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$indexPath = Join-Path $ReportDirectory 'index.json'
if (-not (Test-Path -LiteralPath $indexPath)) {
    throw "Unreal Automation report is missing index.json: $indexPath"
}

$report = Get-Content -Raw -LiteralPath $indexPath | ConvertFrom-Json
$tests = @()
if ($report.PSObject.Properties.Name -contains 'tests') { $tests = @($report.tests) }
elseif ($report.PSObject.Properties.Name -contains 'Tests') { $tests = @($report.Tests) }

$document = New-Object System.Xml.XmlDocument
$declaration = $document.CreateXmlDeclaration('1.0', 'utf-8', $null)
$document.AppendChild($declaration) | Out-Null
$suite = $document.CreateElement('testsuite')
$suite.SetAttribute('name', 'Project.Functional Tests.RisbackaJam26')
$document.AppendChild($suite) | Out-Null

$failures = 0
$skipped = 0
$totalTime = 0.0

foreach ($test in $tests) {
    $case = $document.CreateElement('testcase')
    $name = if ($test.PSObject.Properties.Name -contains 'testDisplayName') { [string]$test.testDisplayName } else { [string]$test.fullTestPath }
    $path = if ($test.PSObject.Properties.Name -contains 'fullTestPath') { [string]$test.fullTestPath } else { $name }
    $duration = if ($test.PSObject.Properties.Name -contains 'duration') { [double]$test.duration } else { 0.0 }
    $state = if ($test.PSObject.Properties.Name -contains 'state') { [string]$test.state } else { 'Unknown' }

    $case.SetAttribute('name', $name)
    $case.SetAttribute('classname', $path)
    $case.SetAttribute('time', $duration.ToString([Globalization.CultureInfo]::InvariantCulture))
    $totalTime += $duration

    $messages = @()
    if ($test.PSObject.Properties.Name -contains 'entries') {
        foreach ($entry in @($test.entries)) {
            if ($entry.PSObject.Properties.Name -contains 'event') {
                $messages += [string]$entry.event.message
            }
        }
    }

    if ($state -match '^(Fail|Failed)$') {
        $failures++
        $failure = $document.CreateElement('failure')
        $failure.SetAttribute('message', "Unreal Automation state: $state")
        $failure.InnerText = $messages -join [Environment]::NewLine
        $case.AppendChild($failure) | Out-Null
    }
    elseif ($state -notmatch '^(Success|Succeeded|Passed)$') {
        $skipped++
        $skippedElement = $document.CreateElement('skipped')
        $skippedElement.SetAttribute('message', "Unreal Automation state: $state")
        $case.AppendChild($skippedElement) | Out-Null
    }

    if ($messages.Count -gt 0) {
        $output = $document.CreateElement('system-out')
        $output.InnerText = $messages -join [Environment]::NewLine
        $case.AppendChild($output) | Out-Null
    }
    $suite.AppendChild($case) | Out-Null
}

$suite.SetAttribute('tests', [string]$tests.Count)
$suite.SetAttribute('failures', [string]$failures)
$suite.SetAttribute('errors', '0')
$suite.SetAttribute('skipped', [string]$skipped)
$suite.SetAttribute('time', $totalTime.ToString([Globalization.CultureInfo]::InvariantCulture))

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
$document.Save($OutputPath)

[pscustomobject]@{
    Tests    = $tests.Count
    Failures = $failures
    Skipped  = $skipped
    Path     = $OutputPath
}
