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
| `CanBeginCarry` | `Carrier: Actor` | `CanBeginCarry: bool`, `Reason: E_RisbackaCarryResult` | Rejects a second carrier |
| `BeginCarry` | `Carrier: Actor`, `AttachTarget: SceneComponent` | `Result: E_RisbackaCarryResult` | Assigns one authoritative carrier |
| `EndCarry` | `Carrier: Actor`, `DropTransform: Transform` | `Result: E_RisbackaCarryResult` | Only current carrier may drop |
| `GetDepositValue` | — | `WoodAmount: int` | Pure query for valid resource pickups |
| `ConsumeAfterDeposit` | `Storage: Actor` | `Result: E_RisbackaCarryResult` | Can succeed once |

`CanBeginCarry` reports its rejection through the same result enum as the commands
so a caller can present one reason vocabulary.

`ConsumeAfterDeposit(Storage: Actor)` is typed as `Actor` in the Phase 1 shell for
the same reason as `BPC_BuildMode.BeginPlacement(Store)`: an interface is usable
as a pin type with no implementers, so this may be narrowed to
`BPI_RisbackaResourceStore` once a store exists.

## Interactor Component

`BPC_CarryInteractor` owns input forwarding and the currently carried actor.
`BP_Player_Risbacka` forwards input to the component and does not implement carry
state in its Event Graph.

Candidate selection is the caller's: `TryBeginCarry` takes an explicit `Target`
rather than searching for one. This keeps overlap/trace policy on the pawn, where
it can differ per input scheme, and keeps the component testable without a world
query.

| API | Kind | Inputs | Outputs | Rule |
|---|---|---|---|---|
| `TryBeginCarry` | Command | `Target: Actor` | `Result: E_RisbackaCarryResult` | Forwards to the carryable after local checks |
| `TryEndCarry` | Command | `DropTransform: Transform` | `Result: E_RisbackaCarryResult` | Drops only what this component carries |
| `GetCarriedActor` | Pure query | — | `CarriedActor: Actor` | Authoritative carried reference |
| `OnCarryStarted` | Dispatcher | `CarriedActor: Actor` | — | Fires after a successful begin |
| `OnCarryEnded` | Dispatcher | `PreviouslyCarried: Actor` | — | Fires after a successful drop or deposit |

State lives in `CarriedActor` and `AttachTarget`, both in the `Risbacka|Carry`
category.

## Test Obligations

- Either local player can carry a free pickup.
- A second player cannot steal an actively carried pickup.
- Drop restores documented collision/physics behavior.
- Deposit consumes once and clears the carrier safely.
- Carrier death or destruction releases the pickup deterministically.
