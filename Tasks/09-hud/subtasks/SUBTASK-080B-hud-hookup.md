---
id: SUBTASK-080B
parent: TASK-080
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-080A]
updated: 2026-07-29
---

# SUBTASK-080B — Event Hookup and HUD Test Harness

[Parent task](../TASK-080-hud.md) · [Tasks overview](../../README.md)

## Objective

Bind one HUD instance to stable public events without editing the source-system assets.

## Work

- Subscribe to cycle, wave, home, and storage dispatchers.
- Add explicit co-op state setters or subscribe to existing player death/health events.
- Create a UI test harness below `Tests/UI`.
- Exercise normal, boundary, missing-source, success, and failure states.
- Document the expected integration call that creates the one shared HUD.

## Acceptance Criteria

- One event produces one visible update.
- Rebinding does not duplicate delegates.
- Missing systems show safe defaults rather than Blueprint errors.
- Only one HUD instance is present for local co-op.

## Verification and Handoff

- Changed assets:
- Required event sources:
- Test screenshots/results:
- Notes:
