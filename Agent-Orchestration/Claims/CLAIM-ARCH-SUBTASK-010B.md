---
id: CLAIM-ARCH-SUBTASK-010B
task: ARCH-SUBTASK-010B
status: IN_PROGRESS
owner: codex-coordinator
computer: local
context: codex-coordinator-2026-08-03-010b
branch: codex/arch-subtask-010b-runtime-red-tests-v2
worktree: J:/dev/Projects/Unreal/RisbackaJam26/.cache/worktrees/arch-010b-v2
base_sha: bcdb34f
claimed_at: 2026-08-03T00:00:00+02:00
lease_expires_at: none
---

# Claim — ARCH-SUBTASK-010B

[Orchestration guide](../README.md) · [Task](../../Architecture/Tasks/02-runtime-composition/subtasks/ARCH-SUBTASK-010B-red-tests.md)

## Exact Claimed Paths

- `Architecture/Tasks/02-runtime-composition/subtasks/ARCH-SUBTASK-010B-red-tests.md`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/`

Only new test assets may be created below the runtime test scope. Existing
runtime/composition Blueprint assets remain owned by ARCH-SUBTASK-010A.

New runtime test assets currently include:

- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Doubles/BP_TD_PlayerLifeEmitter_Solo.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Doubles/BP_TD_PlayerLifeEmitter_TwoPlayer.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Functional/BP_FT_Runtime_Initialization.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Functional/BP_FT_Runtime_TerminalFirstWins.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Functional/BP_FT_Runtime_PlayerLifeSolo.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Functional/BP_FT_Runtime_PlayerLifeTwoPlayer.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Tests/Architecture/Runtime/Maps/L_FT_Runtime_Composition.umap`

## Lease Keys

- `tests:runtime`

## Integration

- Expected handoff branch: `codex/arch-subtask-010b-runtime-red-tests-v2`
- Expected integration order: after ARCH-SUBTASK-010A; before TASK-001
- LFS locks: none
- Coordinator approval commit: `bcdb34f`

## Evidence

- Seven new Unreal assets remain only below the claimed runtime test scope.
- Four Functional Tests discovered on `L_FT_Runtime_Composition`.
- Corrected terminal test adds explicit post-terminal failure/success requests
  and asserts unchanged state plus unchanged dispatcher counts. Both life
  tests repeat public registration setup and assert one event per emission.
  Initialization retains its invalid/no-partial-startup/repeat assertions.
  All four registered tests now complete with bounded named red results:
  terminal arbitration reports its intended failure, while initialization and
  both life tests report bounded setup-watchdog failures.
- All four test Blueprints compiled with warnings treated as errors.
- Graph validation and project validation passed.
- No production Blueprint, map, config, or feature asset changed.
