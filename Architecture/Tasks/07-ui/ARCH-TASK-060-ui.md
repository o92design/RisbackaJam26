---
id: ARCH-TASK-060
title: Shared HUD read-model architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-TASK-010
  - ARCH-TASK-030
  - ARCH-TASK-040
  - ARCH-TASK-050
feature_tasks:
  - TASK-080
updated: 2026-07-29
tags:
  - architecture/task
  - ui
---

# ARCH-TASK-060 — Shared HUD Read-Model Architecture

[Architecture task board](../README.md) ·
[Shared HUD](../../Modules/ARC-MOD-090-ui.md) ·
[UI Read Model](../../Contracts/ARC-CON-090-ui-read-model.md)

## Goal

Prove that one HUD can initialize from read-only sources, bind once to events, update
without Tick polling, and tolerate missing optional sources before TASK-080 styles it.

## Asset Scope

- `/Game/RisbackaJam26/UI/**`
- `/Game/RisbackaJam26/Tests/UI/**`
- Test doubles for read sources
- No edits to producer modules

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-060A](subtasks/ARCH-SUBTASK-060A-shell.md) — HUD/read-source shell | `BLOCKED` |
| [ARCH-SUBTASK-060B](subtasks/ARCH-SUBTASK-060B-red-tests.md) — binding/update red tests | `BLOCKED` |
| [ARCH-SUBTASK-060C](subtasks/ARCH-SUBTASK-060C-review.md) — independent review | `BLOCKED` |

## Completion Gate

- HUD is created once by local player 0.
- Initial reads and event updates are explicit.
- No gameplay mutation, actor search, or Tick binding exists.
- Lifecycle/rebind tests and visual checks pass.
- Fresh-context review approves TASK-080.
