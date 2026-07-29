# Phase 1 Agent Task Board

This is the overview and status board for AI agents and developers implementing the
first playable Risbacka loop. The player-facing requirements are in
[GAME_DESIGN.md](../GAME_DESIGN.md), and the proposed Unreal architecture is in
[Docs/Implementation-Plan.md](../Docs/Implementation-Plan.md).

Last board update: **2026-07-29**

## Status Legend

| Status | Meaning |
|---|---|
| `READY` | Dependencies are satisfied and an agent may claim the task |
| `BLOCKED` | Do not start implementation until the listed dependencies are done |
| `IN_PROGRESS` | One named owner has claimed the task and its assets |
| `IN_REVIEW` | Implementation is complete and awaiting verification/integration |
| `DONE` | Acceptance criteria and verification are complete |
| `PAUSED` | Work started but was intentionally stopped; read the handoff notes |

## Agent Coordination Contract

1. Read this board, the selected task, every linked subtask, and
   [CONTRIBUTING.md](../CONTRIBUTING.md) before editing.
2. Pull immediately before claiming a task.
3. Claim by setting `status`, `owner`, `computer`, and `branch` in the task file.
   Commit and push that claim before opening any shared Unreal asset.
4. Treat every `.uasset` and `.umap` path listed under **Exclusive ownership** as
   locked to that task owner. These files cannot be merged safely.
5. Do not edit template/vendor assets. Duplicate or extend them below
   `/Game/RisbackaJam26/`.
6. Stay inside the task's declared asset paths. If another file is necessary, record
   the proposed expansion in the task and coordinate before editing it.
7. Update subtask status in its own file. The coordinator updates this overview board
   when task-level status changes, preventing many agents from editing this file.
8. Compile every changed Blueprint, save intentionally, and run the task's verification.
9. Before handoff, record exact changed assets, tests run, known limitations, and the
   commit SHA in the parent task.
10. Never mark a task `DONE` merely because its implementation exists; all acceptance
    criteria must pass.

Suggested branch format: `codex/task-###-short-name`.

## Task Board

| ID | Task | Status | Depends on | Primary exclusive area |
|---|---|---|---|---|
| [TASK-001](01-foundation/TASK-001-foundation.md) | Foundation and game-owned baseline | `READY` | — | `/Game/RisbackaJam26/Core`, `/Characters` |
| [TASK-010](02-shared-camera/TASK-010-shared-camera.md) | Shared camera and two local players | `BLOCKED` | TASK-001 | `/Camera`, GameMode camera hookup |
| [TASK-020](03-day-night/TASK-020-day-night.md) | Day/night cycle manager | `BLOCKED` | TASK-001 | `/Cycle` |
| [TASK-030](04-home-failure/TASK-030-home-failure.md) | Home objective and failure signals | `BLOCKED` | TASK-001 | `/Home` |
| [TASK-040](05-wood-loop/TASK-040-wood-loop.md) | Axe, wood pickups, and shared storage | `BLOCKED` | TASK-001 | `/Resources`, player axe hookup |
| [TASK-050](06-boar-ai/TASK-050-boar-ai.md) | Placeholder boar and objective AI | `BLOCKED` | TASK-001 | `/Enemies` |
| [TASK-060](07-wave-director/TASK-060-wave-director.md) | Three-wave night director | `BLOCKED` | TASK-001 | `/Waves` |
| [TASK-070](08-fence-building/TASK-070-fence-building.md) | Wooden fence placement | `BLOCKED` | TASK-040 | `/Building`, player build hookup |
| [TASK-080](09-hud/TASK-080-hud.md) | Phase 1 HUD | `BLOCKED` | TASK-020, 030, 040, 060 | `/UI` |
| [TASK-090](10-integration/TASK-090-integration.md) | Prototype level and system integration | `BLOCKED` | TASK-010–080 | `/Maps/L_Risbacka_Prototype`, cross-system hookup |
| [TASK-100](11-verification/TASK-100-verification.md) | Automation and two-player playtest | `BLOCKED` | TASK-090 | `/Tests/Phase1` |

## Parallel Execution Waves

### Wave 0 — Foundation

Only TASK-001 runs. It creates game-owned copies and shared conventions so later
agents do not touch Combat template assets.

### Wave 1 — Independent Systems

After TASK-001 is `DONE`, these tasks may run concurrently on different computers:

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
