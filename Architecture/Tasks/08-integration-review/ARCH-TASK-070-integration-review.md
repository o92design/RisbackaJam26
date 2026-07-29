---
id: ARCH-TASK-070
title: Integration and architecture acceptance
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-TASK-020
  - ARCH-TASK-030
  - ARCH-TASK-040
  - ARCH-TASK-050
  - ARCH-TASK-060
feature_tasks:
  - TASK-090
  - TASK-100
updated: 2026-07-29
tags:
  - architecture/task
  - integration
  - review
---

# ARCH-TASK-070 — Integration and Architecture Acceptance

[Architecture task board](../README.md) ·
[World Composition](../../Modules/ARC-MOD-100-composition.md) ·
[Verification](../../Modules/ARC-MOD-110-verification.md)

## Goal

Assemble reviewed module APIs through one composition root, prove the complete loop,
and perform a fresh-context architecture audit before declaring Phase 1 whole.

## Asset Scope

- `/Game/RisbackaJam26/Core/BP_RisbackaWorldBootstrap`
- `/Game/RisbackaJam26/Maps/L_Risbacka_Prototype`
- Map external actors/objects owned by TASK-090
- `/Game/RisbackaJam26/Tests/Phase1/**`
- Architecture review report

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-070A](subtasks/ARCH-SUBTASK-070A-shell.md) — integration fixture/composition shell | `BLOCKED` |
| [ARCH-SUBTASK-070B](subtasks/ARCH-SUBTASK-070B-red-tests.md) — cross-module red tests | `BLOCKED` |
| [ARCH-SUBTASK-070C](subtasks/ARCH-SUBTASK-070C-review.md) — integration review after TASK-090 | `BLOCKED` |
| [ARCH-SUBTASK-070D](subtasks/ARCH-SUBTASK-070D-final-review.md) — final Phase 1 audit after TASK-100 | `BLOCKED` |

## Completion Gate

- Composition contains references/bindings only.
- Level Blueprint has no gameplay business logic.
- Full-cycle, success, and every failure path pass.
- All focused and regression tests pass.
- Fresh-context integration and final verification audits approve their exact commits.
