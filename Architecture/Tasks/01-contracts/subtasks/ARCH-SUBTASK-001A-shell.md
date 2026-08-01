---
id: ARCH-SUBTASK-001A
parent: ARCH-TASK-001
stage: shell
status: IN_PROGRESS
owner: root_implementer
computer: DESKTOP-2KFO48U
context: /root
branch: codex/arch-001a-contract-shells-v2
worktree: .cache/worktrees/arch-001a-v2
base_sha: 6a5c8149f4751d6a283fd1b81375d6be09396dd9
implementation_commit: unassigned
updated: 2026-08-01
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
