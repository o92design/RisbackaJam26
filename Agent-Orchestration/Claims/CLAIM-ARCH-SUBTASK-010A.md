---
id: CLAIM-ARCH-SUBTASK-010A
task: ARCH-SUBTASK-010A
status: REVIEW_READY
owner: codex-coordinator
computer: local
context: codex-coordinator-2026-08-03
branch: codex/arch-subtask-010a-runtime-shell
worktree: J:/dev/Projects/Unreal/RisbackaJam26
base_sha: b934c46
claimed_at: 2026-08-03T00:00:00+02:00
lease_expires_at: none
---

# Claim — ARCH-SUBTASK-010A

[Orchestration guide](../README.md) · [Task](../../Architecture/Tasks/02-runtime-composition/subtasks/ARCH-SUBTASK-010A-shell.md)

## Exact Claimed Paths

- `RisbackaJam26Game/Content/RisbackaJam26/Core/BP_RunCoordinator.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Core/BP_PlayerLifeAggregator.uasset`
- `RisbackaJam26Game/Content/RisbackaJam26/Core/BP_RisbackaWorldBootstrap.uasset`

## Lease Keys

- `core:runtime`
- `core:composition`

## Integration

- Expected handoff branch: `codex/arch-subtask-010a-runtime-shell`
- Expected integration order: after ARCH-SUBTASK-001B; before ARCH-SUBTASK-010B and dependent domain shells
- LFS locks: none
- Coordinator approval commit: `951229d`

## Evidence

- Three claimed assets independently discovered as Blueprint classes.
- All three compiled with warnings treated as errors.
- Project validation passed.
- Functional suite passed 5/5 using `-DDC-ForceMemoryCache`.
- No production maps, gameplay assets, or unrelated packages changed.

## Review Outcome

- Reviewed commit: `d62aadc`
- Outcome: `CHANGES_REQUESTED`
- Findings: initialization API mismatch, incomplete failure command signature,
  incomplete bootstrap dependency surface.
