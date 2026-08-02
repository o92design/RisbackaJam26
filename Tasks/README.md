# Phase 1 Agent Task Board

This is the overview and status board for AI agents and developers implementing the
first playable Risbacka loop. The player-facing requirements are in
[GAME_DESIGN.md](../GAME_DESIGN.md), and the proposed Unreal architecture is in
[Architecture/README.md](../Architecture/README.md). High-level asset targets and
Unreal workflow notes remain in
[Docs/Implementation-Plan.md](../Docs/Implementation-Plan.md).

Architecture shells, red tests, and fresh-context reviews are tracked on the separate
[Architecture Task Board](../Architecture/Tasks/README.md). Feature implementation
must satisfy the linked architecture gate in each task; the two boards remain separate
so feature progress is not confused with architecture readiness.

Scheduling is controlled by the machine-checked
[Agent Task Graph](../Agent-Orchestration/task-graph.json) and its
[orchestration guide](../Agent-Orchestration/README.md). The board below is a
human-readable summary.

Last board update: **2026-08-02**

## Status Legend

| Status | Meaning |
|---|---|
| `READY` | Dependencies are satisfied and an agent may claim the task |
| `BLOCKED` | Do not start implementation until the listed dependencies are done |
| `IN_PROGRESS` | One named owner has claimed the task and its assets |
| `REVIEW_READY` | Implementation and evidence are complete at an immutable commit |
| `IN_REVIEW` | A fresh context is reviewing that exact commit |
| `CHANGES_REQUESTED` | Independent review found required corrections |
| `DONE` | Acceptance criteria, verification, and all completion reviews are approved |

## Agent Coordination Contract

1. Read this board, the selected task, every linked subtask, and
   [CONTRIBUTING.md](../CONTRIBUTING.md) before editing.
2. Read the task's architecture modules/contracts and confirm its shell/red-test gate
   is complete.
3. Validate the graph and confirm the task is `READY` before claiming it.
4. Claim by recording `status`, `owner`, `computer`, `context`, `branch`,
   `worktree`, `base_sha`, exact paths, and lease keys.
   Commit and push that claim before opening any shared Unreal asset.
5. Treat every `.uasset` and `.umap` path listed under **Exclusive ownership** as
   locked to that task owner. These files cannot be merged safely.
6. Do not edit template/vendor assets. Duplicate or extend them below
   `/Game/RisbackaJam26/`.
7. Stay inside the task's declared asset paths. If another file is necessary, record
   the proposed expansion in the task and coordinate before editing it.
8. Update subtask status in its own file. The coordinator updates this overview board
   when task-level status changes, preventing many agents from editing this file.
9. Compile every changed Blueprint, save intentionally, and run the task's verification.
10. Before handoff, move to `REVIEW_READY` and record exact changed assets,
    red/green tests, regression results, known limitations, and the immutable
    implementation commit.
11. Never mark a task `DONE` merely because its implementation exists; all acceptance
    criteria and the linked independent architecture review must pass.

Suggested branch format: `codex/task-###-short-name`.

## Task Board

| ID | Task | Status | Depends on | Primary exclusive area |
|---|---|---|---|---|
| [TASK-001](01-foundation/TASK-001-foundation.md) | Foundation and game-owned baseline | `BLOCKED` | Architecture contract shell/red test | `/Game/RisbackaJam26/Core`, `/Characters` |
| [TASK-010](02-shared-camera/TASK-010-shared-camera.md) | Shared camera and two local players | `BLOCKED` | TASK-001 | `/Camera`, GameMode camera hookup |
| [TASK-020](03-day-night/TASK-020-day-night.md) | Day/night cycle manager | `BLOCKED` | TASK-001 | `/Cycle` |
| [TASK-030](04-home-failure/TASK-030-home-failure.md) | Home objective and failure signals | `BLOCKED` | TASK-001 | `/Home` |
| [TASK-040](05-wood-loop/TASK-040-wood-loop.md) | Axe, wood pickups, and shared storage | `BLOCKED` | TASK-001 | `/Resources`, player axe hookup |
| [TASK-050](06-boar-ai/TASK-050-boar-ai.md) | Placeholder boar and objective AI | `BLOCKED` | TASK-001 | `/Enemies` |
| [TASK-060](07-wave-director/TASK-060-wave-director.md) | Three-wave night director | `BLOCKED` | TASK-001 | `/Waves` |
| [TASK-070](08-fence-building/TASK-070-fence-building.md) | Wooden fence placement | `BLOCKED` | TASK-040 | `/Building`, player build hookup |
| [TASK-080](09-hud/TASK-080-hud.md) | Phase 1 HUD | `BLOCKED` | TASK-010, 020, 030, 040, 060 | `/UI` |
| [TASK-090](10-integration/TASK-090-integration.md) | Prototype level and system integration | `BLOCKED` | TASK-010–080 | `/Maps/L_Risbacka_Prototype`, cross-system hookup |
| [TASK-100](11-verification/TASK-100-verification.md) | Automation and two-player playtest | `BLOCKED` | TASK-090 | `/Tests/Phase1` |

## Supporting Tooling

Supporting tooling follows the same claim, test, review, and handoff rules but
does not block the Phase 1 gameplay sequence unless a dependency is added to the
task graph.

| ID | Task | Status | Depends on | Primary exclusive area |
|---|---|---|---|---|
| [TASK-110](12-editor-tooling/TASK-110-blueprint-interface-automation.md) | Safe Blueprint interface automation | `READY` | ARCH-SUBTASK-001B | Editor-only project plugin and MCP registration |

## Parallel Execution Waves

### Architecture Preparation — Contracts and Red Tests

Before feature Wave 0, complete the shell and red-test stages of
[ARCH-TASK-001](../Architecture/Tasks/01-contracts/ARCH-TASK-001-contracts.md). Then
create the minimal runtime/composition shell in
[ARCH-TASK-010](../Architecture/Tasks/02-runtime-composition/ARCH-TASK-010-runtime-composition.md).
This gives TASK-001 stable types and tests before implementation.

### Wave 0 — Foundation

Only TASK-001 runs. It creates game-owned copies and shared conventions so later
agents do not touch Combat template assets.

### Wave 1 — Independent Systems

After TASK-001 is `DONE` and each domain's shell/red-test gate is complete, these
tasks may run concurrently in separate worktrees/checkouts on different computers:

- TASK-010 Shared Camera
- TASK-020 Day/Night
- TASK-030 Home and Failure
- TASK-040 Wood Loop
- TASK-050 Boar AI
- TASK-060 Wave Director

Each owns a separate content folder. TASK-010 temporarily leases the Risbacka
GameMode; TASK-040 temporarily leases the Risbacka player Blueprint.

### Wave 2 — Dependent Features

- TASK-070 starts after TASK-040 and takes over the player Blueprint lease.
- TASK-080 starts after its four data-producing systems have stable public events.

### Wave 3 — Integration

TASK-090 is intentionally single-owner. It takes temporary ownership of the prototype
map, project map/GameMode configuration, and any cross-system edits required to join
completed features.

### Wave 4 — Verification

TASK-100 adds new Phase 1 tests and completes the full two-player acceptance pass.

## Shared Binary Asset Lease Order

| Asset | Lease order |
|---|---|
| `/Game/RisbackaJam26/Core/BP_GM_Risbacka` | TASK-001 → TASK-010 → TASK-090 |
| `/Game/RisbackaJam26/Characters/BP_Player_Risbacka` | TASK-001 → TASK-040 → TASK-070 → TASK-090 |
| `/Game/RisbackaJam26/Maps/L_Risbacka_Prototype` | TASK-090 only |
| `Config/DefaultEngine.ini` map/camera settings | TASK-010, then TASK-090 |
| Existing `BP_AutomationSmoke` asset | No task may edit without explicit coordination |

## Phase 1 Completion Gate

Phase 1 is complete only when:

- two local players are controllable in one shared view;
- daytime lasts three minutes and nighttime lasts five minutes;
- an axe produces wood pickups from marked sources;
- players carry and deposit wood into shared storage;
- stored wood purchases one placeable wooden fence type;
- three waves spawn and attack the home/defenses;
- base destruction, single-player death, and both-player co-op death fail cleanly;
- the complete day/night cycle can finish without a crash;
- new automated tests and the manual two-player checklist pass.

## Templates

- [Task template](templates/TASK-TEMPLATE.md)
- [Subtask template](templates/SUBTASK-TEMPLATE.md)
