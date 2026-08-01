---
id: CLAIM-ARCH-SUBTASK-001A
task: ARCH-SUBTASK-001A
status: IN_PROGRESS
owner: root_implementer
computer: DESKTOP-2KFO48U
context: /root
branch: codex/arch-001a-contract-shells-v2
worktree: .cache/worktrees/arch-001a-v2
base_sha: 6a5c8149f4751d6a283fd1b81375d6be09396dd9
claimed_at: 2026-08-01T12:03:43.5199255+02:00
lease_expires_at: none
---

# Claim — ARCH-SUBTASK-001A

[Orchestration guide](../README.md) ·
[Task](../../Architecture/Tasks/01-contracts/subtasks/ARCH-SUBTASK-001A-shell.md)

## Coordination

This claim supersedes the abandoned pre-cleanup claim on
`codex/arch-001a-contract-shells` and its local
`.cache/worktrees/arch-001a` worktree. That branch is historical evidence only
and must not be integrated or mutated by this implementation.

It also replaces the stalled `/root/arch_001a_worker_v2` and
`/root/arch_001a_worker_v2b` contexts. Neither context made a worktree change
before the coordinator interrupted it. The primary context is taking over the
isolated implementation worktree; independent review will still use a fresh
reviewer context.

## Exact Claimed Paths

Coordinator/task evidence:

- `Agent-Orchestration/Claims/CLAIM-ARCH-SUBTASK-001A.md`
- `Architecture/Tasks/01-contracts/subtasks/ARCH-SUBTASK-001A-shell.md`

Existing enums and their final destinations:

- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaCarryResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaCarryResult`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaFailureReason`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaFailureReason`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaInitResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaInitResult`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaPhase`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaPhase`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaPlacementResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaPlacementResult`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaResourceResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaResourceResult`
- `/Game/RisbackaJam26/Core/Contracts/E_RisbackaRunState`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaRunState`

Existing structs and their final destinations:

- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaDamageRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaDamageRequest`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaInitContext`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaInitContext`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaPlacementRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaPlacementRequest`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaPlacementResult`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaPlacementResult`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaResourceChange`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaResourceChange`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaSpawnRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaSpawnRequest`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaSpawnResult`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaSpawnResult`
- `/Game/RisbackaJam26/Core/Contracts/FST_RisbackaWaveDefinition`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaWaveDefinition`

New interfaces:

- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaInitializable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaDamageable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaObjective`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaResourceStore`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaCarryable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaWaveParticipant`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaCameraParticipant`

Contract notes may be edited only to record a signature clarification required by
the implementation:

- `Architecture/Contracts/ARC-CON-001-initialization.md`
- `Architecture/Contracts/ARC-CON-010-run-state.md`
- `Architecture/Contracts/ARC-CON-020-health-damage.md`
- `Architecture/Contracts/ARC-CON-030-objective-targeting.md`
- `Architecture/Contracts/ARC-CON-040-resource-store.md`
- `Architecture/Contracts/ARC-CON-050-carry-interaction.md`
- `Architecture/Contracts/ARC-CON-060-building.md`
- `Architecture/Contracts/ARC-CON-070-wave-accounting.md`
- `Architecture/Contracts/ARC-CON-080-camera-participant.md`
- `Architecture/Contracts/ARC-CON-090-ui-read-model.md`

Local-only bridge command/result files below the implementation worktree's
`RisbackaJam26Game/Saved/rtapy/` and an ignored
`RisbackaJam26Game/Content/Python/init_unreal.py` are permitted but must not be
staged or committed.

## Lease Keys

- `contracts`

## Scope Rules

- Preserve the existing enum values, struct fields, types, and defaults.
- Create only the seven interfaces listed above.
- Do not create components, dispatchers, tests, consumers, maps, GameMode,
  player, boar, fence, storage, widget, Combat-template, or runtime behavior.
- Use only generic engine types and contract-owned structs/enums in public
  signatures.
- `ResetHealthForTest` belongs to the later health component and is not a
  cross-module interface function.
- Store/change dispatchers belong to later concrete owners and are not Blueprint
  interface members.

## Integration

- Expected handoff branch: `codex/arch-001a-contract-shells-v2`
- Expected integration order: first architecture increment
- LFS locks: required for the 17 existing contract assets when the remote
  supports them; initial lock discovery failed because the local Git credential
  helper crashed, so the worker must re-check and record the result before
  mutation.
- Coordinator approval commit: this claim commit, to be recorded after creation
