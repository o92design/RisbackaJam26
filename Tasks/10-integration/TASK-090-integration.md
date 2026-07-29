---
id: TASK-090
title: Prototype level and system integration
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-010, TASK-020, TASK-030, TASK-040, TASK-050, TASK-060, TASK-070, TASK-080]
updated: 2026-07-29
---

# TASK-090 — Prototype Level and System Integration

[Tasks overview](../README.md) · [Implementation plan](../../Docs/Implementation-Plan.md)

## Goal

Assemble completed systems into one playable Risbacka prototype without editing the
Combat map.

## Exclusive Ownership

- `/Game/RisbackaJam26/Maps/L_Risbacka_Prototype`
- External actors/objects belonging to that map
- Cross-system hookup edits after feature owners hand off
- Project default map/GameMode settings in `DefaultEngine.ini`

This task is single-owner. No other task may edit the integration map concurrently.

## Deliverables

- Prototype arena framed by the shared camera
- Two tagged PlayerStarts, home, wood sources/storage, build area, spawn points
- Day/night manager, wave director, HUD, and explicit run-state hookup
- Three-minute preparation followed by five-minute defense
- Success and failure reset/restart path

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-090A](subtasks/SUBTASK-090A-prototype-level.md) | `BLOCKED` |
| [SUBTASK-090B](subtasks/SUBTASK-090B-full-loop.md) | `BLOCKED` |

## Out of Scope

- Neighbor gameplay
- Fab boar integration or final environment art
- Weather, cleanup, advanced economy, or progression
- Refactoring stable feature assets without a recorded integration need

## Acceptance Criteria

- Both players can complete the wood-to-fence loop during day.
- Night starts automatically and runs exactly three waves.
- Boars attack the home or blocking fences.
- All defined death/base failure paths end the run cleanly.
- Clearing wave three reaches dawn/success.
- A complete eight-minute cycle can run without a crash.

## Verification

- Run the full loop with one player and with two controllers.
- Run `.\Test.ps1`.
- Package or launch the map using the existing startup-smoke workflow.

## Handoff

- Changed assets:
- Cross-system edits:
- Tests run:
- Commit:
