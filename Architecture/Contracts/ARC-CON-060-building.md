---
id: ARC-CON-060
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-020
  - ARC-CON-040
updated: 2026-07-29
tags:
  - architecture/contract
  - building
---

# ARC-CON-060 — Building

[Contract catalog](README.md) · [Building Module](../Modules/ARC-MOD-060-building.md) ·
[Resource Store](ARC-CON-040-resource-store.md)

## Purpose

Separate visual preview, placement validation, resource spending, and final spawning
so invalid or concurrent requests cannot consume wood.

## Proposed Assets

- `BPC_BuildMode`
- `FST_RisbackaPlacementRequest`
- `FST_RisbackaPlacementResult`
- `E_RisbackaPlacementResult`: `Unset`, `Valid`, `Blocked`, `OutOfBounds`,
  `InsufficientWood`, `SpawnFailed`

## Component API

| API | Kind | Outputs | Rule |
|---|---|---|---|
| `BeginPlacement(BuildClass: class<Actor>, Store: Actor)` | Command | `Result: E_RisbackaPlacementResult` | Creates preview only; spends nothing |
| `UpdatePlacement(TargetTransform: Transform)` | Command | `Result: E_RisbackaPlacementResult` | Runs bounded collision/bounds validation |
| `TryCommitPlacement()` | Command | `Result: FST_RisbackaPlacementResult` | Revalidates, atomically spends, then spawns |
| `CancelPlacement()` | Command | — | Removes preview and clears transient state |
| `GetPlacementResult()` | Pure query | `Result: FST_RisbackaPlacementResult` | Pure read for feedback |
| `OnPlacementCommitted(Result)` | Dispatcher | — | Fires once after a committed placement |

The in-progress calls return the bare enum because only validity matters while
previewing. Commit and read-back return the full struct so the confirmed
transform and spawned actor travel with the outcome. `OnPlacementCommitted`
reports a completed placement; it is not a request to place.

`Store` is typed as `Actor` in the Phase 1 shell and is accessed through the
resource-store contract. It may be narrowed to `BPI_RisbackaResourceStore` at
any time — an interface is usable as a pin type with no implementers — and
should be once a store exists and the calling shape is settled.

If spawning fails after a successful spend, the component must refund through a
documented storage command or avoid committing the transaction until spawn success can
be guaranteed.

## Users

- `BP_Player_Risbacka` forwards build input to `BPC_BuildMode`.
- `BP_WoodStorage` is accessed through the resource-store contract.
- `BP_FenceBase` exposes cost and placement bounds but does not spend resources itself.

## Test Obligations

- Valid, overlap-blocked, outside-bounds, and insufficient-wood cases.
- Cancellation never changes the balance.
- Two local players cannot spend the same wood.
- Spawn failure leaves the balance consistent.
