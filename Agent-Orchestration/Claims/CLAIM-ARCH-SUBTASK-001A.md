---
id: CLAIM-ARCH-SUBTASK-001A
task: ARCH-SUBTASK-001A
status: IN_PROGRESS
owner: arch_001a_worker
computer: DESKTOP-2KFO48U
context: /root/arch_001a_worker
branch: codex/arch-001a-contract-shells
worktree: .cache/worktrees/arch-001a
base_sha: 6c3cb43
claimed_at: 2026-07-29T19:56:37+02:00
lease_expires_at: none
---

# Claim — ARCH-SUBTASK-001A

[Orchestration guide](../README.md) ·
[Task](../../Architecture/Tasks/01-contracts/subtasks/ARCH-SUBTASK-001A-shell.md)

## Exact Claimed Paths

Interfaces:

- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaInitializable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaDamageable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaObjective`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaResourceStore`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaCarryable`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaWaveParticipant`
- `/Game/RisbackaJam26/Core/Contracts/Interfaces/BPI_RisbackaCameraParticipant`

Enums:

- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaInitResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaPhase`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaRunState`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaFailureReason`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaResourceResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaCarryResult`
- `/Game/RisbackaJam26/Core/Contracts/Enums/E_RisbackaPlacementResult`

Structs:

- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaInitContext`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaDamageRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaDamageResult`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaResourceChange`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaPlacementRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaPlacementResult`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaWaveDefinition`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaSpawnRequest`
- `/Game/RisbackaJam26/Core/Contracts/Structs/FST_RisbackaSpawnResult`

No existing binary asset is claimed. Components, maps, GameMode, player,
template/vendor assets, and contract test assets are outside this claim.

## Lease Keys

- `contracts`

## Safe Shell Policy

- Create only the seven interfaces, eight enums, and nine structs listed above.
- Add the public interface functions explicitly named by the contract notes.
- Do not create runtime behavior, components, dispatchers, tests, or consumers.
- Put invalid/rejected/non-operational enum values first where the notes permit
  refinement; `E_RisbackaPhase` must contain exactly `Day` and `Night`.
- For under-specified struct fields and function parameters, use generic engine
  types (`Actor`, `Object`, `Name`, `Transform`, primitives) rather than concrete
  feature classes.
- Record every resolved ambiguity under `Signature deviations` in the task
  handoff before review.

## Integration

- Expected handoff branch: `codex/arch-001a-contract-shells`
- Expected integration order: first architecture increment
- LFS locks: none; all assets are new
- Coordinator approval commit: pending
