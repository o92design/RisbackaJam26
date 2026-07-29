---
id: SUBTASK-040B
parent: TASK-040
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-040A]
updated: 2026-07-29
---

# SUBTASK-040B — Shared Wood Storage and Accounting

[Parent task](../TASK-040-wood-loop.md) · [Tasks overview](../../README.md)

## Objective

Convert dropped pickups inside a storage volume into one shared, safely spendable
wood count.

## Work

- Create `Resources/BP_WoodStorage`.
- Accept only uncarried `BP_WoodPickup` actors dropped inside the storage volume.
- Consume each accepted pickup once and increment stored wood by its value.
- Add `CanAfford`, `TrySpend`, `AddWood`, `Reset`, and `OnStoredWoodChanged`.
- Create a resource-loop test harness below `Tests/Resources`.

## Acceptance Criteria

- One pickup produces one accounting transaction.
- Repeated overlap events cannot duplicate wood.
- Failed spending leaves the balance unchanged.
- Two near-simultaneous deposits produce the correct total.

## Verification and Handoff

- Changed assets:
- Public storage API:
- Accounting tests:
- Notes:
