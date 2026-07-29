---
id: TASK-010
title: Shared camera and two local players
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# TASK-010 — Shared Camera and Two Local Players

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Goal

Both local players are independently controllable while viewing the entire active
play area through one shared high-angle camera.

## Exclusive Ownership

- `/Game/RisbackaJam26/Camera/**`
- `/Game/RisbackaJam26/Tests/Camera/**`
- `/Game/RisbackaJam26/Core/BP_GM_Risbacka` for camera hookup only
- `RisbackaJam26Game/Config/DefaultEngine.ini` `bUseSplitscreen` only

## Deliverables

- `BP_SharedGameplayCamera`
- A small camera test level with two tagged PlayerStarts
- GameMode hookup that assigns the shared view target to both local controllers
- Split-screen disabled only after the shared view and both inputs work together

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-010A](subtasks/SUBTASK-010A-camera-actor.md) | `BLOCKED` |
| [SUBTASK-010B](subtasks/SUBTASK-010B-local-coop.md) | `BLOCKED` |

## Out of Scope

- Neighbor travel or dialogue
- Dynamic zoom unless the fixed whole-area framing is insufficient
- Editing the player Blueprint

## Acceptance Criteria

- One image fills the screen; no split-screen divider is visible.
- Two gamepads control separate player characters simultaneously.
- Both players remain visible throughout the defined camera test bounds.
- Keyboard/mouse behavior is documented rather than assumed for player two.

## Verification

- PIE with two connected controllers.
- Stand players in opposite corners and capture a viewport image.
- Restart PIE three times to verify stable player/camera assignment.

## Handoff

- Changed assets:
- Tests run:
- Known limitations:
- Commit:
