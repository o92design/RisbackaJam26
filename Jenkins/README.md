# Jenkins setup

Build server: `DESKTOP-6M3T3NU`
Jenkins: `http://DESKTOP-6M3T3NU:8080/`
Unreal Engine: `C:\Epic\UE_5.8`
Butler: `C:\Tools\butler\butler.exe`
Archive root: `D:\RisbackaJam26`

Jenkins runs as LocalSystem. Keep the repository workspace and all active Unreal output on the SSD. Do not move workspaces, `Intermediate`, cooking/staging, or DDC to `D:`.

## Server-wide prerequisites

1. Set the Windows build node to **1 executor**. All project jobs also disable concurrent runs, but one executor prevents Unreal builds and promotions from overlapping each other.
2. Confirm the Secret Text credential `itch-butler-api-key` exists.
3. Disable sleep and hibernation during the jam.
4. Prevent automatic Windows restarts during the jam window.
5. Keep Jenkins port 8080 LAN-only.
6. Confirm LocalSystem can execute Git, Git LFS, `RunUAT.bat`, Visual Studio, and Butler.
7. Create/retain `D:\RisbackaJam26`; the pipeline creates its subdirectories.

The MSVC 14.51 warning from UE 5.8 is known and non-blocking on this server.

## Jenkins folder

Create a Jenkins folder named `RisbackaJam26`. The jobs below live inside it and therefore
have the full names `RisbackaJam26/Test`, `RisbackaJam26/Promote-Dev`, and
`RisbackaJam26/Release`.

## Test job

Inside the folder, create a **Pipeline script from SCM** job named `Test`:

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

This job packages Development configuration once, archives it under `Runs\Test`, and
uploads it to `windows-test`.

## Development promotion job

Inside the folder, create another **Pipeline script from SCM** job named `Promote-Dev`:

| Setting | Value |
|---|---|
| SCM | Git |
| Repository | `https://github.com/o92design/RisbackaJam26.git` |
| Credentials | None (public repository) |
| Branch specifier | `*/master` |
| Script path | `Jenkins/Jenkinsfile.promote-dev` |
| Lightweight checkout | Enabled |
| Poll SCM | Disabled |

Under **General**, enable **This project is parameterized** and add a String parameter:

| Parameter | Value |
|---|---|
| Name | `TEST_BUILD_ID` |
| Default | Empty |
| Description | Exact successful Test Build ID from the dashboard or `D:\RisbackaJam26\Runs\Test` |

Run this job only with **Build with Parameters**. It resolves the selected Test archive,
verifies every SHA-256 checksum, and uploads the unchanged package to `windows-dev`.
It does not run Unreal, cook, or create a second package.

## Release job

Inside the folder, create a **Pipeline script from SCM** job named `Release`:

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

## Build pipeline stages

The Test and Release jobs expose small, reusable stages:

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

The Promote-Dev job uses a shorter, package-only flow:

1. checkout the promotion scripts without Git LFS content;
2. resolve one exact successful Test Build ID;
3. verify the archived executable and every SHA-256 checksum;
4. upload the unchanged package to `windows-dev`;
5. record the promotion and regenerate the dashboard.

`BuildCookRun` intentionally remains one stage because that exact flow is proven. The workspace is not deleted after builds; Unreal's `Binaries`, `Intermediate`, and caches make incremental builds much faster. Only `BuildOutput` is recreated for packaging.

Every script line uses millisecond timestamps and a named stage. Native tool output is also saved separately under `BuildLogs`. Commands report sanitized arguments, exit code, and elapsed time. Butler uploads additionally echo verbose live status to the Jenkins console; noisy Unreal editor and cook output remains available in the archived native logs.

## Build identity

Test builds use one identity consistently for the archive folder, manifest,
packaged `BuildInfo.json`, `windows-test` version, and later development promotion:

```text
Build-DESKTOP-6M3T3NU-20260728-184602Z-Test-Build-12-696540b1e6e7
```

Release archive identities also include the immutable semantic tag:

```text
Build-DESKTOP-6M3T3NU-20260728-184602Z-Release-v0.1.0-Build-4-696540b1e6e7
```

The timestamp is the build start in UTC (`Z`). The dashboard displays timestamps in
Stockholm time. Result and failure stage remain in the manifest and dashboard because
they are only final after archival and upload; immutable archive folders are not renamed.
Release uploads continue using the semantic tag itself as the itch.io user version.
Promotion to `windows-dev` preserves the source Test Build ID so the exact tested binary
remains traceable.

Jenkins applies these identities as the visible run names after the Build context stage.
Its internal sequence number and URL remain numeric (for example, `/1/`); this is normal
Jenkins behavior. Development promotion runs are displayed as
`Promote-Dev-<source Test Build ID>`.

## Archive and retention

Jenkins keeps five records for each build job and ten lightweight promotion records. The HDD keeps all build attempts with no automatic deletion:

```text
D:\RisbackaJam26\
├─ Runs\Test\
├─ Runs\Development\
├─ Runs\Release\
├─ History\
├─ Promotions\
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
- If promotion fails before upload, correct the reported archive/checksum problem; never bypass verification.
- If promotion upload succeeds but final recording fails, inspect the Jenkins log before retrying so channel history and the manifest remain understandable.
- Never use `deleteDir()` as a routine fix; it destroys incremental build performance.
