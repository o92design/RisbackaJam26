---
id: SUBTASK-040A
parent: TASK-040
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-040A — Axe Hits, Wood Sources, Carry, and Drop

[Parent task](../TASK-040-wood-loop.md) · [Tasks overview](../../README.md)

## Objective

Turn the existing melee attack into a Phase 1 axe interaction and produce carryable
wood pickups from marked sources.

## Work

- Create `Resources/BP_WoodSource` with configurable health/yield.
- Create `Resources/BP_WoodPickup`.
- Reuse the player attack trace and identify valid axe/wood-source hits.
- Add one-pickup carry and drop behavior to `BP_Player_Risbacka`.
- Use placeholder visuals; do not introduce final axe/tree art dependencies.

## Acceptance Criteria

- One source drops its configured yield once.
- Ordinary collision or non-axe damage does not harvest the source.
- Either player can pick up, carry, and drop one pickup.
- A carried pickup cannot be claimed by the other player.

## Verification and Handoff

- Changed assets:
- Player Blueprint changes:
- Harvest/carry tests:
- Notes:
