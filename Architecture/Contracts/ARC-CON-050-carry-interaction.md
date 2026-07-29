---
id: ARC-CON-050
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - interaction
---

# ARC-CON-050 — Carry Interaction

[Contract catalog](README.md) ·
[Resources & Interaction](../Modules/ARC-MOD-050-resources-interaction.md)

## Purpose

Separate player input from pickup ownership and physics behavior.

## Proposed Assets

- `BPI_RisbackaCarryable`
- `BPC_CarryInteractor`
- `E_RisbackaCarryResult`

## Carryable Interface

| Function | Inputs | Outputs | Rule |
|---|---|---|---|
| `CanBeginCarry` | Carrier | Boolean, reason | Rejects a second carrier |
| `BeginCarry` | Carrier, attach target | Result | Assigns one authoritative carrier |
| `EndCarry` | Carrier, drop transform | Result | Only current carrier may drop |
| `GetDepositValue` | — | Wood amount | Pure query for valid resource pickups |
| `ConsumeAfterDeposit` | Storage | Result | Can succeed once |

## Interactor Component

`BPC_CarryInteractor` owns selection, input forwarding, and the currently carried
actor. `BP_Player_Risbacka` forwards input to the component and does not implement
carry state in its Event Graph.

## Test Obligations

- Either local player can carry a free pickup.
- A second player cannot steal an actively carried pickup.
- Drop restores documented collision/physics behavior.
- Deposit consumes once and clears the carrier safely.
- Carrier death or destruction releases the pickup deterministically.
