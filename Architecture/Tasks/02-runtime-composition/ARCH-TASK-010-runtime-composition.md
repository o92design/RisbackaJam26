---
id: ARCH-TASK-010
title: Runtime and composition architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-SUBTASK-001A
feature_tasks:
  - TASK-001
  - TASK-090
updated: 2026-07-29
tags:
  - architecture/task
  - runtime
  - composition
---

# ARCH-TASK-010 — Runtime and Composition Architecture

[Architecture task board](../README.md) ·
[Runtime](../../Modules/ARC-MOD-010-runtime.md) ·
[Composition](../../Modules/ARC-MOD-100-composition.md)

## Goal

Create a thin runtime coordinator and one explicit composition root so terminal run
state and cross-module wiring never spread into feature actors or the Level Blueprint.

## Asset Scope

- `/Game/RisbackaJam26/Core/BP_RunCoordinator`
- `/Game/RisbackaJam26/Core/BP_PlayerLifeAggregator`
- `/Game/RisbackaJam26/Core/BP_RisbackaWorldBootstrap`
- `/Game/RisbackaJam26/Tests/Architecture/Runtime/**`
- GameMode and prototype map hookups remain in TASK-001/TASK-090

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-010A](subtasks/ARCH-SUBTASK-010A-shell.md) — runtime/composition shell | `BLOCKED` |
| [ARCH-SUBTASK-010B](subtasks/ARCH-SUBTASK-010B-red-tests.md) — transition/init red tests | `BLOCKED` |
| [ARCH-SUBTASK-010C](subtasks/ARCH-SUBTASK-010C-review.md) — runtime review after TASK-001 | `BLOCKED` |
| [ARCH-SUBTASK-010D](subtasks/ARCH-SUBTASK-010D-composition-review.md) — composition review after TASK-090 | `BLOCKED` |

## Feature Handoff

TASK-001 implements the GameMode/player baseline against the runtime shell and
receives its own runtime review. TASK-090 supplies final world references and
complete initialization, followed by a separate composition review. Splitting
these reviews prevents either feature from waiting on work that it must itself
enable.

## Completion Gate

- First terminal event wins deterministically.
- Invalid/repeated initialization is safe.
- Composition validates references and binds once.
- GameMode and map remain thin.
- Fresh-context review approves a named commit.
