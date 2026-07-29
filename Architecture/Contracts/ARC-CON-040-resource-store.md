---
id: ARC-CON-040
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - resources
---

# ARC-CON-040 — Resource Store

[Contract catalog](README.md) ·
[Resources & Interaction](../Modules/ARC-MOD-050-resources-interaction.md) ·
[Building](../Modules/ARC-MOD-060-building.md)

## Purpose

Make the shared wood balance authoritative and make building costs atomic.

## Proposed Asset

- `BPI_RisbackaResourceStore`
- `E_RisbackaResourceResult`: `Succeeded`, `InvalidAmount`, `InsufficientBalance`
- `FST_RisbackaResourceChange`

## Interface Functions and Events

| API | Inputs | Outputs | Rule |
|---|---|---|---|
| `DepositWood` | Positive amount, source | Result, new balance | Adds once |
| `TrySpendWood` | Positive amount, requester | Result, new balance | Check and subtract in one call |
| `GetStoredWood` | — | Balance | Pure query |
| `OnStoredWoodChanged` | Previous, Current, reason | Dispatcher on store | Fires after successful mutation |

Consumers must not perform `GetStoredWood >= Cost` followed by a separate subtraction;
that creates a race between two local placement requests.

## Users

- `BP_WoodStorage` implements the contract.
- `BP_WoodPickup` deposits through the storage overlap path.
- `BPC_BuildMode` calls `TrySpendWood` only after placement validation.
- HUD reads and subscribes; it never deposits or spends.

## Test Obligations

- Deposit once despite repeated overlap events.
- Exact-balance spend reaches zero.
- Insufficient and invalid spends leave state unchanged.
- Two requests in the same frame cannot overspend.
