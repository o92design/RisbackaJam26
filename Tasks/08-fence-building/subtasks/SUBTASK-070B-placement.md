---
id: SUBTASK-070B
parent: TASK-070
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-070A, SUBTASK-040B]
updated: 2026-07-29
---

# SUBTASK-070B — Preview, Validation, and Shared-Wood Spending

[Parent task](../TASK-070-fence-building.md) · [Tasks overview](../../README.md)

## Objective

Let either player place a fence through a clear preview while spending shared wood
atomically.

## Work

- Add build-mode entry, rotation if needed, confirm, and cancel to the player.
- Create a preview using valid/invalid materials or colors.
- Reject overlap with players, home, storage, and existing fences.
- Call storage `TrySpend` only during confirmed valid placement.
- Handle simultaneous placement requests without a negative balance.

## Acceptance Criteria

- Cancel and invalid confirm never spend wood.
- A valid confirm creates one fence and one spend transaction.
- Two players cannot spend the same last units of wood.
- Build mode exits cleanly on placement, cancel, death, or phase change.

## Verification and Handoff

- Changed assets:
- Player Blueprint changes:
- Two-player spending results:
- Notes:
