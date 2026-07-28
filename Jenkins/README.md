# Jenkins setup

Build server: `DESKTOP-6M3T3NU`
Jenkins: `http://DESKTOP-6M3T3NU:8080/`
Unreal Engine: `C:\Epic\UE_5.8`
Butler: `C:\Tools\butler\butler.exe`
Archive root: `D:\RisbackaJam26`

Jenkins runs as LocalSystem. Keep the repository workspace and all active Unreal output on the SSD. Do not move workspaces, `Intermediate`, cooking/staging, or DDC to `D:`.

## Server-wide prerequisites

1. Set the Windows build node to **1 executor**. Both project jobs also disable concurrent builds, but one executor prevents them from overlapping each other.
2. Confirm the Secret Text credential `itch-butler-api-key` exists.
3. Disable sleep and hibernation during the jam.
4. Prevent automatic Windows restarts during the jam window.
5. Keep Jenkins port 8080 LAN-only.
6. Confirm LocalSystem can execute Git, Git LFS, `RunUAT.bat`, Visual Studio, and Butler.
7. Create/retain `D:\RisbackaJam26`; the pipeline creates its subdirectories.

The MSVC 14.51 warning from UE 5.8 is known and non-blocking on this server.

## Development job

Create a **Pipeline script from SCM** job named `RisbackaJam26-Dev`:

| Setting | Value |
|---|---|
| SCM | Git |
| Repository | `https://github.com/o92design/RisbackaJam26.git` |
| Credentials | None (public repository) |
| Branch specifier | `*/master` |
| Script path | `Jenkinsfile` |
| Lightweight checkout | Enabled |
| Poll SCM | `H/2 * * * *` |

Run one manual build first. Download it from the restricted itch.io page and launch it on another computer before relying on polling.

## Release job

Create a separate **Pipeline script from SCM** job named `RisbackaJam26-Release`:

| Setting | Value |
|---|---|
| SCM | Git |
| Repository | `https://github.com/o92design/RisbackaJam26.git` |
| RefSpec | `+refs/tags/v*:refs/remotes/origin/tags/v*` |
| Branch specifier | `refs/tags/v*` |
| Script path | `Jenkins/Jenkinsfile.release` |
| Lightweight checkout | Enabled |
| Poll SCM | `H/2 * * * *` |

The pipeline rejects anything except an exact `vMAJOR.MINOR.PATCH` tag and uploads Shipping builds to `windows`.

## Pipeline stages

Both jobs expose small, reusable stages:

1. checkout and Git LFS pull;
2. LFS pointer validation;
3. build context;
4. tool and SSD preflight;
5. Unreal project validation;
6. Blueprint Functional Tests and JUnit conversion;
7. atomic Unreal `BuildCookRun`;
8. package and startup verification;
9. required archive to `D:`;
10. Butler upload;
11. final manifest, dashboard, and Jenkins diagnostic artifacts.

`BuildCookRun` intentionally remains one stage because that exact flow is proven. The workspace is not deleted after builds; Unreal's `Binaries`, `Intermediate`, and caches make incremental builds much faster. Only `BuildOutput` is recreated for packaging.

Every script line uses millisecond timestamps and a named stage. Native tool output is also saved separately under `BuildLogs`. Commands report sanitized arguments, exit code, and elapsed time.

## Build identity

Development builds use one identity consistently for the archive folder, manifest,
packaged `BuildInfo.json`, and itch.io user version:

```text
Build-DESKTOP-6M3T3NU-20260728-184602Z-Development-Build-12-696540b1e6e7
```

Release archive identities also include the immutable semantic tag:

```text
Build-DESKTOP-6M3T3NU-20260728-184602Z-Release-v0.1.0-Build-4-696540b1e6e7
```

The timestamp is the build start in UTC (`Z`). The dashboard displays timestamps in
Stockholm time. Result and failure stage remain in the manifest and dashboard because
they are only final after archival and upload; immutable archive folders are not renamed.
Release uploads continue using the semantic tag itself as the itch.io user version.

## Archive and retention

Jenkins keeps five build records. The HDD keeps all build attempts with no automatic deletion:

```text
D:\RisbackaJam26\
├─ Runs\Development\
├─ Runs\Release\
├─ History\
├─ Dashboard\
└─ Staging\
```

Successful runs contain the package, `BuildInfo.json`, SHA-256 checksums, logs, test reports, metadata, stage timing, and changelog. Failed runs retain diagnostics and identify the failure stage.

The pipeline warns below 150 GB free on `D:` and stops archival below 50 GB. Because archival is required, a successful package is not uploaded when it cannot be archived.

Dashboard publishing target:

`C:\ProgramData\Jenkins\.jenkins\userContent\RisbackaJam26`

Dashboard URL:

`http://DESKTOP-6M3T3NU:8080/userContent/RisbackaJam26/`

Dashboard generation errors mark an otherwise successful build unstable; they do not invalidate a package that was already verified, archived, and uploaded.

## Recovery

- If checkout fails, verify GitHub access and `git lfs pull` as LocalSystem.
- If SSD space is below 50 GB, stop and remove only knowingly disposable old workspaces/caches.
- If `D:` is below 50 GB, expand or manually curate archives before retrying. There is no automatic deletion.
- If upload fails, the verified package remains in its immutable archive and can be uploaded later with Butler.
- Never use `deleteDir()` as a routine fix; it destroys incremental build performance.
