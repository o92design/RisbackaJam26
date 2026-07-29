---
id: SUBTASK-080A
parent: TASK-080
status: BLOCKED
owner: unassigned
depends_on: [TASK-020, TASK-030, TASK-040, TASK-060]
updated: 2026-07-29
---

# SUBTASK-080A — Shared HUD Layout and State Widgets

[Parent task](../TASK-080-hud.md) · [Tasks overview](../../README.md)

## Objective

Create a compact shared-camera HUD layout and isolated widgets for all required state.

## Work

- Create `UI/WBP_RisbackaHUD`.
- Create or embed phase/clock, wave, home, wood, and two-player status widgets.
- Keep the center playfield clear and reserve edges/corners for information.
- Expose explicit setter functions and preview values.
- Add readable temporary styling; final branding is not required.

## Acceptance Criteria

- All required information is distinguishable without entering gameplay.
- Player one and player two states cannot be confused.
- Layout remains readable at the agreed target and reduced test resolution.
- No widget uses a Tick-bound gameplay lookup.

## Verification and Handoff

- Changed assets:
- Target resolutions:
- Screenshots:
- Notes:
