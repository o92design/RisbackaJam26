---
id: SUBTASK-070A
parent: TASK-070
status: BLOCKED
owner: unassigned
depends_on: [TASK-040]
updated: 2026-07-29
---

# SUBTASK-070A — Damageable Wooden Fence

[Parent task](../TASK-070-fence-building.md) · [Tasks overview](../../README.md)

## Objective

Create one cheap, breakable wooden defense with navigation-relevant collision.

## Work

- Create `Building/BP_FenceBase`.
- Expose wood cost, max health, and placement footprint.
- Implement the existing damage interface.
- Add healthy/damaged/destroyed placeholder presentation.
- Configure collision so players are blocked appropriately and AI paths must respond.

## Acceptance Criteria

- Fence cost and health are data-editable.
- Valid enemy attacks reduce health and destroy the fence once.
- Destroyed collision no longer blocks the route.
- Fence has no dependency on final art.

## Verification and Handoff

- Changed assets:
- Collision/navigation settings:
- Damage tests:
- Notes:
