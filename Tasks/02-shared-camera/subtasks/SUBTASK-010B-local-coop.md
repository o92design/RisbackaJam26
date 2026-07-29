---
id: SUBTASK-010B
parent: TASK-010
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-010A]
updated: 2026-07-29
---

# SUBTASK-010B — Two-Player View Target and Input Verification

[Parent task](../TASK-010-shared-camera.md) · [Tasks overview](../../README.md)

## Objective

Connect both local controllers to the same camera while retaining separate pawn input.

## Work

- Add shared-camera discovery and view-target assignment to `BP_GM_Risbacka`.
- Verify the existing local-player count and tagged start logic.
- Set `bUseSplitscreen=False` only after the shared view works in PIE.
- Document controller assignment and keyboard/mouse limitations.

## Acceptance Criteria

- Two controllers possess two different pawns.
- Both controllers see the shared camera with no split divider.
- Repeated PIE starts do not swap a controller into an unpossessed state.

## Verification and Handoff

- Test three PIE starts with two controllers.
- Changed assets/config:
- Input observations:
- Notes:
