---
id: CLAIM-ARCH-SUBTASK-001B
task: ARCH-SUBTASK-001B
status: DONE
owner: root_implementer
computer: DESKTOP-2KFO48U
context: /root
branch: codex/arch-001b-contract-fixtures
worktree: .cache/worktrees/arch-001b-contract-fixtures
base_sha: ce2af3e7f3d7d4e86e457c1839f19cbe6d1eb949
implementation_commit: 29e66951841d37f214576a70caef241ce84dda03
claimed_at: 2026-08-02T19:26:26.5633972+02:00
lease_expires_at: 2026-08-02T22:13:01.5505975+02:00
released_at: 2026-08-02T22:13:01.5505975+02:00
---

# Claim — ARCH-SUBTASK-001B

[Orchestration guide](../README.md) ·
[Task](../../Architecture/Tasks/01-contracts/subtasks/ARCH-SUBTASK-001B-red-tests.md)

## Exact Claimed Paths

Coordinator/task evidence:

- `Agent-Orchestration/Claims/CLAIM-ARCH-SUBTASK-001B.md`
- `Architecture/Tasks/01-contracts/subtasks/ARCH-SUBTASK-001B-red-tests.md`

New test doubles:

- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Doubles/BP_TD_Initializable_DefaultInvalid`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Doubles/BP_TD_Damageable_DefaultRejected`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Doubles/BP_TD_ResourceStore_DefaultInvalid`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Doubles/BP_TD_WaveParticipant_DefaultUnconfigured`

New Functional Test actors:

- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Functional/BP_FT_Contracts_InitializationDefaults`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Functional/BP_FT_Contracts_DamageDefaults`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Functional/BP_FT_Contracts_ResourceDefaults`
- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Functional/BP_FT_Contracts_WaveDefaults`

New discovery map:

- `/Game/RisbackaJam26/Tests/Architecture/Contracts/Maps/L_FT_Contracts_Defaults`

Local-only automation scripts and result files below the implementation
worktree's `RisbackaJam26Game/Saved/` are permitted but must not be staged or
committed.

## Lease Keys

- `tests:contracts`

## Scope Rules

- Create only the nine Unreal assets listed above.
- Do not modify the existing smoke test assets or any production contract,
  GameMode, player, feature, map, config, or Combat-template asset.
- Test assets may depend only on sibling test assets, public contract assets,
  and engine packages.
- Tests communicate with doubles through generic object references and
  Blueprint interface messages; concrete casts and private-variable reads are
  forbidden.
- Tick, timers, latent waits, Level Blueprint gameplay, and unnecessary mutable
  state are forbidden.

## Integration

- Expected handoff branch: `codex/arch-001b-contract-fixtures`
- Expected integration order: after ARCH-SUBTASK-001A; before TASK-001
- LFS locks: not required because all nine binary assets are new
- Coordinator approval commit: this claim commit, to be recorded after creation
