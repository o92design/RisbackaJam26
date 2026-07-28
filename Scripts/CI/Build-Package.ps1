[CmdletBinding()]
param(
    [ValidateSet('Development', 'Shipping')][string]$Configuration = 'Development',
    [string]$UERoot = $(if ($env:UE_ROOT) { $env:UE_ROOT } else { 'C:\Epic\UE_5.8' })
)

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Build Cook Package' -Body {
    $paths = Get-UEPaths -UERoot $UERoot
    Get-RequiredPath -Path $paths.RunUAT -Description 'Unreal Automation Tool' | Out-Null
    Get-RequiredPath -Path $paths.Project -Description 'Unreal project' | Out-Null

    $resolvedOutput = [IO.Path]::GetFullPath($script:OutputRoot)
    $expectedOutput = [IO.Path]::GetFullPath((Join-Path $script:RepositoryRoot 'BuildOutput'))
    if ($resolvedOutput -ne $expectedOutput) {
        throw "Refusing to clean unexpected package path: $resolvedOutput"
    }
    if (Test-Path -LiteralPath $resolvedOutput) {
        Remove-Item -LiteralPath $resolvedOutput -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $resolvedOutput | Out-Null

    $uatArguments = @(
        'BuildCookRun',
        "-project=`"$($paths.Project)`"",
        '-noP4',
        '-platform=Win64',
        "-clientconfig=$Configuration",
        '-build',
        '-cook',
        '-stage',
        '-pak',
        '-package',
        '-archive',
        "-archivedirectory=`"$resolvedOutput`"",
        '-utf8output',
        '-unattended'
    )
    $command = 'call "' + $paths.RunUAT + '" ' + ($uatArguments -join ' ')
    Invoke-LoggedProcess -Stage 'Build Cook Package' -FilePath 'cmd.exe' -Arguments @('/d', '/s', '/c', $command) | Out-Null
}
