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
- `E_RisbackaPlacementResult`: `Valid`, `Blocked`, `OutOfBounds`,
  `InsufficientWood`, `SpawnFailed`

## Component API

| Function | Rule |
|---|---|
| `BeginPlacement(BuildClass, Store)` | Creates preview only; spends nothing |
| `UpdatePlacement(TargetTransform)` | Runs bounded collision/bounds validation |
| `TryCommitPlacement()` | Revalidates, atomically spends, then spawns |
| `CancelPlacement()` | Removes preview and clears transient state |
| `GetPlacementResult()` | Pure read for feedback |

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
