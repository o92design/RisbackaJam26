# Risbacka Jam 26

Unreal Engine 5.8 game-jam project by Oskar Månsson and Daniel Sjöholm.

The current gameplay title **Zummer TimeZ** is a working idea, not a final product name. The early concept is a base-building survival game where players fend off zombie attacks. Planned play modes are single-player, two-player local split-screen, and two computers over LAN. Multiplayer gameplay is deliberately outside this repository bootstrap.

## Project baseline

- Unreal project: `RisbackaJam26Game/RisbackaJam26Game.uproject`
- Template: Third Person, Blueprint, Combat variant
- Target: Windows / Win64
- Quality: Maximum
- Rendering: DX12, SM6, Lumen, Nanite; hardware ray tracing disabled
- Default branch: `master`
- Automatic test channel: `kioskars/risbacka-jam-26:windows-test`
- Promoted development channel: `kioskars/risbacka-jam-26:windows-dev`
- Release channel: `kioskars/risbacka-jam-26:windows`

## Repository layout

```text
RisbackaJam26/
├─ RisbackaJam26Game/       Unreal project and content
├─ Scripts/CI/              Small reusable build/test/release steps
├─ Jenkins/                 Release pipeline and server setup
├─ Docs/                    Decisions and editor handoffs
├─ Jenkinsfile              Automatic Test pipeline
├─ Setup-Local.ps1          One-time Git/LFS setup
├─ Test.ps1                 Local project and functional tests
└─ Package.ps1              Local Windows package
```

## First local setup

Install Unreal Engine 5.8, Visual Studio with Unreal/C++ build tools, Git, and Git LFS. Then run:

```powershell
.\Setup-Local.ps1
```

The script uses `master`, installs Git LFS for this repository, enables repository-local long paths, and validates the Unreal settings.

Before the first CI run, create the Blueprint smoke test described in [Docs/Unreal-Automation-Smoke-Test.md](Docs/Unreal-Automation-Smoke-Test.md). This binary asset must be created in Unreal Editor.

## Daily workflow

1. Pull `master` and Git LFS changes.
2. Work in a small, clearly owned set of assets.
3. Test in Editor; run `.\Test.ps1` before pushing.
4. Commit a small coherent change and push to `master`.
5. Jenkins detects the push within about two minutes, runs tests, packages once, archives the result, then uploads it to `windows-test`.
6. When a build is suitable for shared play, manually promote that exact archived package to `windows-dev` without rebuilding it.

Unreal maps and Blueprints are binary. Coordinate ownership before both developers edit the same `.umap` or `.uasset`; Git cannot merge them reliably. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Local commands

```powershell
# Validate configuration and run Blueprint Functional Tests
.\Test.ps1

# Development package; runs tests and a startup smoke test
.\Package.ps1

# Fast packaging diagnosis when the editor smoke-test asset is not ready
.\Package.ps1 -SkipTests

# Shipping package for local verification only
.\Package.ps1 -Configuration Shipping
```

Local scripts default to `J:\dev\unreal\UE_5.8`. CI uses `C:\Epic\UE_5.8`.

## Releases

Development is trunk-based on `master`. A release is an immutable semantic tag:

```powershell
git tag -a v0.1.0 -m "Risbacka Jam 26 v0.1.0"
git push origin v0.1.0
```

The separate release job polls `vMAJOR.MINOR.PATCH` tags, creates a Shipping build, archives it, and uploads the exact tag version to the public `windows` channel. Never move or reuse a release tag.

## Unreal MCP for Codex

The project enables UE 5.8's experimental `ModelContextProtocol` plugin plus the focused
`EditorToolset`, `AutomationTestToolset`, and `ConfigSettingsToolset` plugins for Editor
targets only. The `AllToolsets` aggregator is intentionally excluded because it loads
unrelated experimental Game Features and Dataflow plugins. After Unreal restarts, open
the Output Log and run:

```text
ModelContextProtocol.StartServer
```

The repository-level [.codex/config.toml](.codex/config.toml) points Codex at `http://127.0.0.1:8000/mcp`. The server is local and manually started; do not expose it to the network.

## Jenkins

The complete folder-based three-job setup and operational checklist are in [Jenkins/README.md](Jenkins/README.md). The generated LAN dashboard is:

`http://DESKTOP-6M3T3NU:8080/userContent/RisbackaJam26/`
