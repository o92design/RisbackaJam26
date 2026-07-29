---
id: SUBTASK-090B
parent: TASK-090
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-090A]
updated: 2026-07-29
---

# SUBTASK-090B — Full Day/Night Loop and Run States

[Parent task](../TASK-090-integration.md) · [Tasks overview](../../README.md)

## Objective

Connect all completed systems into one start-to-finish playable run.

## Work

- Start in Day and enable gathering/building.
- At Night transition, stop new preparation actions and start the wave director.
- Route home destruction and player deaths to the defined failure rules.
- Route third-wave clear to dawn/success.
- Create/show one HUD and provide a deterministic restart/reset path.
- Set project default map/GameMode only after the integrated map passes.

## Acceptance Criteria

- Day lasts 180 seconds and Night lasts 300 seconds at defaults.
- All wood, building, combat, wave, success, and failure criteria work with two players.
- Restart returns every manager, actor, balance, fence, and player to initial state.
- No Blueprint runtime errors occur during one full cycle.

## Verification and Handoff

- Changed assets/config:
- One-player result:
- Two-player result:
- Runtime-log findings:
