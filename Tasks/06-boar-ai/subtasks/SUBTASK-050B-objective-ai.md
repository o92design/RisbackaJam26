---
id: SUBTASK-050B
parent: TASK-050
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-050A]
updated: 2026-07-29
---

# SUBTASK-050B — Objective and Blocker Targeting

[Parent task](../TASK-050-boar-ai.md) · [Tasks overview](../../README.md)

## Objective

Make the placeholder boar prefer the home, attack a damageable blocker when pathing is
obstructed, and resume movement after the blocker is removed.

## Work

- Implement objective acquisition by explicit reference first, stable tag as fallback.
- Update Risbacka-owned StateTree/controller logic to move to the objective.
- Detect an attackable blocker at the failed path/front contact.
- Attack until the blocker is destroyed, then reacquire the objective.
- Create open-path and blocked-path cases below `Tests/Enemies`.

## Acceptance Criteria

- Players standing nearby do not replace the configured objective by default.
- Open-path boars reach attack range of the home.
- Blocked-path boars damage the blocker and continue after it breaks.
- Missing objectives fail safely with a useful log message.

## Verification and Handoff

- Changed assets:
- Objective contract:
- Five-run pathing results:
- Notes:
