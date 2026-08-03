---
id: ARC-CONTRACTS
type: architecture-index
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/contract
---

# Public Contract Catalog

[Architecture home](../README.md) · [System map](../System-Map.md)

Contracts define the only supported cross-module calls. Names are proposed Phase 1
Blueprint asset names; the shell task may refine a signature before implementation,
but every consumer and test must then be updated together.

| Contract | Assets | Responsibility |
|---|---|---|
| [Initialization](ARC-CON-001-initialization.md) | `BPI_RisbackaInitializable`, `FST_RisbackaInitContext` | Deterministic startup and validation |
| [Run State](ARC-CON-010-run-state.md) | `E_RisbackaPhase`, `E_RisbackaRunState`, `E_RisbackaFailureReason` | Separate time phase from run outcome |
| [Health & Damage](ARC-CON-020-health-damage.md) | `BPI_RisbackaDamageable`, `BPC_Health`, damage structs | Reusable damage transaction |
| [Objective Targeting](ARC-CON-030-objective-targeting.md) | `BPI_RisbackaObjective` | Explicit AI target and blocker semantics |
| [Resource Store](ARC-CON-040-resource-store.md) | `BPI_RisbackaResourceStore` | Atomic deposit and spending |
| [Carry Interaction](ARC-CON-050-carry-interaction.md) | `BPI_RisbackaCarryable`, `BPC_CarryInteractor` | Pickup ownership and drop |
| [Building](ARC-CON-060-building.md) | `BPC_BuildMode`, placement structs | Preview and transactional commit |
| [Wave Accounting](ARC-CON-070-wave-accounting.md) | `BPI_RisbackaWaveParticipant`, wave structs | Exact registration and completion |
| [Camera Participant](ARC-CON-080-camera-participant.md) | `BPI_RisbackaCameraParticipant` | Shared-camera focus inputs |
| [UI Read Model](ARC-CON-090-ui-read-model.md) | read functions and dispatchers | One-way state presentation |

## Contract Rules

- Commands that can fail return an explicit result; they do not silently do nothing.
- A result enum reserves index `0` for `Unset`, never for success. Blueprint
  returns the zero value from an unimplemented function, and a struct field that
  nobody filled in is also zero, so a success-at-zero enum makes both silently
  report success. `E_RisbackaRunState` shows the same idea for state enums: its
  index `0` is `Bootstrapping`, the honest "nothing has happened yet" value.
- Currency and counters change in one atomic function on the state owner.
- Event dispatchers describe completed state changes, not requests.
- A terminal event fires once.
- Initialization is explicit and testable.
- Interfaces contain cross-module behavior only; private helpers remain local.
- Public functions and variables use Blueprint categories and tooltips.
- Contract changes require consumer search, test updates, and fresh-context review.
