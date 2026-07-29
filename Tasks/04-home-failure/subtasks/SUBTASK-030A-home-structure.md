---
id: SUBTASK-030A
parent: TASK-030
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-030A — Damageable Home Structure

[Parent task](../TASK-030-home-failure.md) · [Tasks overview](../../README.md)

## Objective

Create the main objective with predictable health and placeholder visual states.

## Work

- Create `Home/BP_HomeStructure`.
- Implement the existing damage interface used by Combat assets.
- Expose max health and health-state thresholds.
- Represent healthy, damaged, critical, and destroyed states with simple materials,
  meshes, or visibility changes.
- Reject invalid, negative, or post-destruction damage.

## Acceptance Criteria

- Controlled hits yield exact health values.
- State transitions occur once at documented thresholds.
- Health clamps to zero and never becomes negative.

## Verification and Handoff

- Changed assets:
- Thresholds/default health:
- Damage tests:
- Notes:
