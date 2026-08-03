[CmdletBinding()]
param()

. (Join-Path $PSScriptRoot 'Common.ps1')

Invoke-CIStage -Name 'Project Validation' -Body {
    $paths = Get-UEPaths
    $project = Get-Content -Raw -LiteralPath $paths.Project | ConvertFrom-Json
    if ($project.EngineAssociation -ne '5.8') { throw "Expected UE 5.8, found $($project.EngineAssociation)." }
    if (Test-Path -LiteralPath (Join-Path (Split-Path $paths.Project) 'Source')) { throw 'A Source directory exists; the approved baseline is Blueprint-only.' }

    $pluginMap = @{}
    foreach ($plugin in $project.Plugins) { $pluginMap[$plugin.Name] = $plugin }
    foreach ($name in @('ModelContextProtocol', 'EditorToolset', 'AutomationTestToolset', 'ConfigSettingsToolset', 'RisbackaEditorBridge')) {
        if (-not $pluginMap.ContainsKey($name) -or -not $pluginMap[$name].Enabled) {
            throw "Required editor plugin is not enabled: $name"
        }
        if ($pluginMap[$name].TargetAllowList -notcontains 'Editor') {
            throw "$name must be restricted to Editor targets."
        }
    }
    if ($pluginMap.ContainsKey('AllToolsets') -and $pluginMap['AllToolsets'].Enabled) {
        throw 'AllToolsets must remain disabled; enable only the approved focused toolsets.'
    }

    $engineIni = Get-Content -Raw -LiteralPath (Join-Path (Split-Path $paths.Project) 'Config\DefaultEngine.ini')
    $requiredSettings = @(
        'GameDefaultMap=/Game/Variant_Combat/Lvl_Combat.Lvl_Combat',
        'GlobalDefaultGameMode=/Game/Variant_Combat/Blueprints/BP_CombatGameMode.BP_CombatGameMode_C',
        'DefaultGraphicsRHI=DefaultGraphicsRHI_DX12',
        '+D3D12TargetedShaderFormats=PCD3D_SM6',
        'r.RayTracing=False',
        'bUseSplitscreen=True',
        '+PackageRedirects=(OldName="/Game/LevelPrototyping/Interactable/Door/Assets/Meshes/SM_DoorFrame_Edge",NewName="/Game/LevelPrototyping/Interactable/Door/Meshes/SM_DoorFrame_Edge")'
    )
    foreach ($setting in $requiredSettings) {
        if (-not $engineIni.Contains($setting)) { throw "Missing required DefaultEngine.ini setting: $setting" }
    }
    if ($engineIni -match '(?m)^r\.RayTracing=True$') { throw 'Hardware ray tracing is unexpectedly enabled.' }
    if ($engineIni -match '(?m)^SecurityToken=') { throw 'A generated Android file-server token must not be committed.' }

    $combatMap = Join-Path (Split-Path $paths.Project) 'Content\Variant_Combat\Lvl_Combat.umap'
    Get-RequiredPath -Path $combatMap -Description 'Combat variant map' | Out-Null

    $testPipelinePath = Get-RequiredPath -Path (Join-Path $script:RepositoryRoot 'Jenkinsfile') -Description 'Automatic Test Jenkinsfile'
    $promotionPipelinePath = Get-RequiredPath -Path (Join-Path $script:RepositoryRoot 'Jenkins\Jenkinsfile.promote-dev') -Description 'Development promotion Jenkinsfile'
    $releasePipelinePath = Get-RequiredPath -Path (Join-Path $script:RepositoryRoot 'Jenkins\Jenkinsfile.release') -Description 'Release Jenkinsfile'
    $butlerUploadPath = Get-RequiredPath -Path (Join-Path $script:RepositoryRoot 'Scripts\CI\Upload-Butler.ps1') -Description 'Butler upload script'
    $dashboardGeneratorPath = Get-RequiredPath -Path (Join-Path $script:RepositoryRoot 'Scripts\CI\Update-Dashboard.ps1') -Description 'Dashboard generator'
    $testPipeline = Get-Content -Raw -LiteralPath $testPipelinePath
    $promotionPipeline = Get-Content -Raw -LiteralPath $promotionPipelinePath
    $releasePipeline = Get-Content -Raw -LiteralPath $releasePipelinePath
    $butlerUpload = Get-Content -Raw -LiteralPath $butlerUploadPath
    $dashboardGenerator = Get-Content -Raw -Encoding UTF8 -LiteralPath $dashboardGeneratorPath
    if (-not $testPipeline.Contains("ITCH_CHANNEL  = 'windows-test'") -or
        -not $testPipeline.Contains('-Stream Test -Channel windows-test') -or
        -not $testPipeline.Contains('currentBuild.displayName')) {
        throw 'Automatic Jenkins pipeline must build the Test stream, upload windows-test, and apply the informative Build ID.'
    }
    foreach ($collaborationGuardContract in @(
        "GIT_LFS_SKIP_SMUDGE = '1'",
        "CI_SKIP_EXPENSIVE   = 'false'",
        'hudson.triggers.SCMTrigger$SCMTriggerCause',
        'Collaboration-only SCM change',
        "lowerPath.endsWith('.md')",
        "lowerPath == '.gitignore'",
        "lowerPath == '.editorconfig'",
        "lowerPath.startsWith('.codex/')",
        "lowerPath.startsWith('.agents/')",
        "lowerPath.startsWith('.obsidian/')"
    )) {
        if (-not $testPipeline.Contains($collaborationGuardContract)) {
            throw "Automatic Jenkins pipeline collaboration-only guard is missing: $collaborationGuardContract"
        }
    }
    if (-not $promotionPipeline.Contains("name: 'TEST_BUILD_ID'") -or
        -not $promotionPipeline.Contains("ITCH_CHANNEL        = 'windows-dev'")) {
        throw 'Development promotion pipeline must require TEST_BUILD_ID and target windows-dev.'
    }
    if (-not $releasePipeline.Contains("ITCH_CHANNEL  = 'windows'") -or
        -not $releasePipeline.Contains('-Stream Release -Channel windows') -or
        -not $releasePipeline.Contains('currentBuild.displayName')) {
        throw 'Release Jenkins pipeline must build the Release stream, upload windows, and apply the informative Build ID.'
    }
    if ($butlerUpload.Contains("'--verbose'") -or
        -not $butlerUpload.Contains('-EchoToConsole -FilterInteractiveProgress')) {
        throw 'Butler uploads must provide filtered live status without verbose signed upload URLs.'
    }
    if ($dashboardGenerator -match '[^\x00-\x7F]') {
        throw 'Dashboard generator must remain ASCII-only for Windows PowerShell 5.1 compatibility.'
    }
    foreach ($layoutContract in @(
        'main{width:100%;margin:0;padding:24px}',
        '.table-wrap{margin-top:12px;overflow:hidden;padding:0}',
        'table{border-collapse:collapse;table-layout:fixed;width:100%;white-space:nowrap}',
        '@media(max-width:1100px)'
    )) {
        if (-not $dashboardGenerator.Contains($layoutContract)) {
            throw "Dashboard responsive layout contract is missing: $layoutContract"
        }
    }
    $colgroup = [regex]::Match($dashboardGenerator, '(?s)<colgroup>(.*?)</colgroup>')
    $columnWidths = @([regex]::Matches($colgroup.Groups[1].Value, 'width:(\d+)%') | ForEach-Object { [int]$_.Groups[1].Value })
    if (-not $colgroup.Success -or $columnWidths.Count -ne 14 -or ($columnWidths | Measure-Object -Sum).Sum -ne 100) {
        throw 'Dashboard history table must define fourteen columns totaling exactly 100% width.'
    }
    Write-CILog -Stage 'Project Validation' -Message 'Blueprint-only UE 5.8 Combat project settings are valid.'
}
