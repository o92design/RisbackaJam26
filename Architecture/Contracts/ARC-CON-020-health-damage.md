---
id: ARC-CON-020
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - health
---

# ARC-CON-020 — Health and Damage

[Contract catalog](README.md) ·
[Health & Objectives](../Modules/ARC-MOD-040-health-objectives.md)

## Purpose

Provide one reusable, testable damage transaction for the home, fences, enemies, and
future damageable actors while remaining compatible with the retained Combat attack
flow through an adapter.

## Proposed Assets

- `BPI_RisbackaDamageable`
- `BPC_Health`
- `FST_RisbackaDamageRequest`
- `FST_RisbackaDamageResult`
- `E_RisbackaDamageResult`: `Applied`, `Rejected`, `AlreadyDestroyed`

## Interface and Component API

| Function | Inputs | Outputs | Rule |
|---|---|---|---|
| `RequestDamage` | Request struct | Result struct | The health owner applies or rejects once |
| `CanReceiveDamage` | Request struct | Boolean | Pure policy query |
| `GetHealthSnapshot` | — | Current, Max, IsDestroyed | Read-only |
| `ResetHealthForTest` | Optional max | — | Test-only callable path; not exposed to player flow |
| `OnHealthChanged` | Previous, Current, Max | Dispatcher | Fires after accepted damage |
| `OnDestroyed` | Damage result | Dispatcher | Fires once |

The request includes amount, source actor, instigator actor, and a damage-purpose tag
or enum. Negative and zero amounts are rejected. Health is clamped to `[0, Max]`.

## Actor Adoption

- `BP_HomeStructure`: required.
- `BP_FenceBase`: required.
- `BP_BoarPlaceholder`: required unless an adapter proves the copied Combat health
  implementation already satisfies this contract.
- `BP_Player_Risbacka`: use `BPC_Health` or a thin adapter; never maintain two health
  values.
- `BP_WoodSource`: may use a configured durability subset or a narrow axe-hit adapter.

## Test Obligations

- Valid damage, overkill, zero/negative damage, repeated post-destruction damage.
- Exactly one destruction event.
- Combat melee adapter applies one transaction per valid hit.
- Reset/respawn does not leave stale bindings.
