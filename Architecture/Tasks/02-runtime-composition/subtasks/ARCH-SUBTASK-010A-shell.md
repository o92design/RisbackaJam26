---
id: ARCH-SUBTASK-010A
parent: ARCH-TASK-010
stage: shell
status: REVIEW_READY
owner: codex-coordinator
computer: local
branch: codex/arch-subtask-010a-runtime-shell
worktree: J:/dev/Projects/Unreal/RisbackaJam26
base_sha: b934c46
depends_on:
  - ARCH-SUBTASK-001A
updated: 2026-08-01
tags:
  - architecture/task
---

# ARCH-SUBTASK-010A — Create Runtime and Composition Shell

Parent: [ARCH-TASK-010](../ARCH-TASK-010-runtime-composition.md) ·
[Run State](../../../Contracts/ARC-CON-010-run-state.md) ·
[Initialization](../../../Contracts/ARC-CON-001-initialization.md)

## Work

- Create compileable coordinator, player-life aggregator, and bootstrap shells.
- Expose documented functions/events and editable dependency references.
- Return controlled invalid/not-ready results without starting gameplay.
- Document initialization order in the bootstrap asset.

## Acceptance Criteria

- Shells compile with no new warnings.
- No timers, waves, UI, or feature behavior starts.
- Bootstrap contains references/wiring only.
- Coordinator owns the sole run-state value.

## Handoff

- Changed assets: `BP_RunCoordinator`, `BP_PlayerLifeAggregator`, and
  `BP_RisbackaWorldBootstrap` under `/Game/RisbackaJam26/Core`.
- Public APIs: initialization and validation shells, run-state commands and
  query, player registration/snapshot query, bootstrap references, and runtime
  event dispatchers.
- Compile result: all three Blueprints compiled with warnings treated as errors.
- Regression result: project validation passed; functional suite passed 5/5 with
  `-DDC-ForceMemoryCache`.
- Commit: `2c8dbb8`.
