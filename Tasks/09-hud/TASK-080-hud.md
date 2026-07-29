---
id: TASK-080
title: Phase 1 HUD
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-020, TASK-030, TASK-040, TASK-060]
updated: 2026-07-29
---

# TASK-080 — Phase 1 HUD

[Tasks overview](../README.md) · [GAME_DESIGN.md](../../GAME_DESIGN.md)

## Goal

Present the minimum shared-camera information needed to understand time, waves, home
danger, stored wood, and both players without obscuring the playfield.

## Exclusive Ownership

- `/Game/RisbackaJam26/UI/**`
- `/Game/RisbackaJam26/Tests/UI/**`

## Deliverables

- `WBP_RisbackaHUD`
- Phase/clock, wave, home, wood, and co-op status widgets
- Event-driven updates using the public contracts from dependency tasks
- A UI test harness with representative states

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-080A](subtasks/SUBTASK-080A-hud-widgets.md) | `BLOCKED` |
| [SUBTASK-080B](subtasks/SUBTASK-080B-hud-hookup.md) | `BLOCKED` |

## Out of Scope

- Menus, settings, dialogue, inventory, or final visual branding
- Polling gameplay actors every frame
- Editing dependency-system Blueprints

## Acceptance Criteria

- All five information groups are readable at the target play resolution.
- Updates occur from events or explicit setters, not Tick bindings.
- The HUD is shown once for the shared view, not duplicated per local player.
- Missing optional systems fail gracefully in the UI test harness.

## Verification

- Exercise day/night, wave, health, wood, and player-state changes.
- Capture screenshots at target and reduced resolutions.
- Compile every widget Blueprint.

## Handoff

- Changed assets:
- Required public events:
- Tests/screenshots:
- Commit:
