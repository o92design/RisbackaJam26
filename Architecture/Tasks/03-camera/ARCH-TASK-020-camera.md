---
id: ARCH-TASK-020
title: Shared camera and local co-op architecture
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
contract_prerequisites:
  - ARCH-SUBTASK-001A
  - ARCH-SUBTASK-010A
feature_tasks:
  - TASK-010
updated: 2026-07-29
tags:
  - architecture/task
  - camera
---

# ARCH-TASK-020 — Shared Camera and Local Co-op Architecture

[Architecture task board](../README.md) ·
[Camera Module](../../Modules/ARC-MOD-020-camera-coop.md) ·
[TASK-010](../../../Tasks/02-shared-camera/TASK-010-shared-camera.md)

## Goal

Define a camera participant boundary and prove shared-view setup independently before
TASK-010 implements production framing and disables split-screen.

## Asset Scope

- `/Game/RisbackaJam26/Camera/**`
- `/Game/RisbackaJam26/Tests/Camera/**`
- GameMode hookup only through TASK-010 lease
- `DefaultEngine.ini` only through TASK-010 after proof

## Subtasks

| Subtask | Status |
|---|---|
| [ARCH-SUBTASK-020A](subtasks/ARCH-SUBTASK-020A-shell.md) — camera shell | `BLOCKED` |
| [ARCH-SUBTASK-020B](subtasks/ARCH-SUBTASK-020B-red-tests.md) — shared-view red tests | `BLOCKED` |
| [ARCH-SUBTASK-020C](subtasks/ARCH-SUBTASK-020C-review.md) — independent review | `BLOCKED` |

## Completion Gate

- Participant registration replaces per-frame world searches.
- Two controllers receive one stable view.
- Defined play-area bounds are visible.
- Split-screen changes only after shared behavior passes.
- Fresh-context review approves the feature.
