---
id: SUBTASK-010A
parent: TASK-010
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-010A — Shared Camera Actor and Framing Test

[Parent task](../TASK-010-shared-camera.md) · [Tasks overview](../../README.md)

## Objective

Build a reusable high-angle camera that frames a declared rectangular play area.

## Work

- Create `Camera/BP_SharedGameplayCamera`.
- Expose play-area center, extent, pitch, FOV, and camera distance.
- Use a fixed camera first; add framing math only if required by the test area.
- Create `Tests/Camera/L_Test_SharedCamera` with corner markers and two PlayerStarts.

## Acceptance Criteria

- All four play-area corners are visible at the target aspect ratio.
- Camera settings are editable without graph changes.
- The camera does not follow or zoom in response to a single player's movement.

## Verification and Handoff

- Capture the viewport with markers at all corners.
- Changed assets:
- Recommended camera defaults:
- Notes:
