---
id: SUBTASK-050A
parent: TASK-050
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-050A — Risbacka-Owned Placeholder Boar

[Parent task](../TASK-050-boar-ai.md) · [Tasks overview](../../README.md)

## Objective

Create a killable, spawnable Risbacka enemy without modifying Combat template assets.

## Work

- Duplicate or derive the Combat enemy as `Enemies/BP_BoarPlaceholder`.
- Duplicate/derive required AI assets into `/Enemies`.
- Preserve damage, death, attack, movement, and death notification.
- Replace humanoid presentation only with a simple placeholder if necessary.
- Expose movement speed, damage, health, and target reference/tag.

## Acceptance Criteria

- The enemy spawns and possesses its AI controller.
- Player axe damage kills it.
- Death fires once and the actor cleans up predictably.
- No Combat enemy or AI asset is modified.

## Verification and Handoff

- Changed assets:
- Remaining template dependencies:
- Combat/death tests:
- Notes:
