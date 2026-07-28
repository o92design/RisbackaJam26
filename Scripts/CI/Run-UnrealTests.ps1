[CmdletBinding()]
param(
    [string]$UERoot = $(if ($env:UE_ROOT) { $env:UE_ROOT } else { 'C:\Epic\UE_5.8' }),
    [string]$Filter = 'Project.Functional Tests.RisbackaJam26',
    [switch]$AllowNoTests
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Blueprint Functional Tests' -Body {
    $paths = Get-UEPaths -UERoot $UERoot
    Get-RequiredPath -Path $paths.EditorCmd -Description 'Unreal command-line editor' | Out-Null
    Get-RequiredPath -Path $paths.Project -Description 'Unreal project' | Out-Null

    $reportDirectory = Join-Path $script:TestRoot 'UnrealReport'
    if (Test-Path -LiteralPath $reportDirectory) {
        Remove-Item -LiteralPath $reportDirectory -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $reportDirectory | Out-Null

    $arguments = @(
        $paths.Project,
        '-unattended',
        '-nopause',
        '-nosplash',
        '-NullRHI',
        '-NoSound',
        '-stdout',
        '-FullStdOutLogOutput',
        "-ReportExportPath=$reportDirectory",
        "-ExecCmds=Automation RunTests $Filter",
        '-TestExit=Automation Test Queue Empty'
    )
    Invoke-LoggedProcess -Stage 'Blueprint Functional Tests' -FilePath $paths.EditorCmd -Arguments $arguments | Out-Null

    $junitPath = Join-Path $script:TestRoot 'junit.xml'
    $summary = & (Join-Path $PSScriptRoot 'Convert-UnrealTestsToJUnit.ps1') -ReportDirectory $reportDirectory -OutputPath $junitPath
    Write-CILog -Stage 'Blueprint Functional Tests' -Message "$($summary.Tests) test(s), $($summary.Failures) failure(s), $($summary.Skipped) skipped."

    if ($summary.Tests -eq 0 -and -not $AllowNoTests) {
        throw 'No Blueprint Functional Tests matched the filter. Create Content/RisbackaJam26/Tests/L_AutomationSmoke before enabling CI.'
    }
    if ($summary.Failures -gt 0) {
        throw "$($summary.Failures) Unreal functional test(s) failed."
    }
}
