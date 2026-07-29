---
id: ARCH-SUBTASK-001A
parent: ARCH-TASK-001
stage: shell
status: IN_PROGRESS
owner: arch_001a_worker
computer: DESKTOP-2KFO48U
context: /root/arch_001a_worker
branch: codex/arch-001a-contract-shells
worktree: .cache/worktrees/arch-001a
base_sha: 6c3cb43
implementation_commit: unassigned
updated: 2026-07-29
tags:
  - architecture/task
---

# ARCH-SUBTASK-001A — Create Contract Shells

Parent: [ARCH-TASK-001](../ARCH-TASK-001-contracts.md) ·
[Contract catalog](../../../Contracts/README.md)

## Work

- Create the contract folder structure.
- Create every proposed interface, enum, and struct with documented names/signatures.
- Keep defaults explicit and nonfunctional.
- Add Blueprint categories/tooltips and compile each asset.
- Record any signature change in the linked contract note before consumers exist.

## Acceptance Criteria

- All contract assets compile without new warnings.
- `E_RisbackaPhase` contains only `Day` and `Night`.
- Run outcome uses `E_RisbackaRunState`.
- No contract references a concrete home, player, boar, fence, storage, widget, or map.

## Handoff

- Changed assets:
- Signature deviations:
- Compile result:
- Commit:
