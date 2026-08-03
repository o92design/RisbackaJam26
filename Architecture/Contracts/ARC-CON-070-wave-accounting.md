---
id: ARC-CON-070
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - waves
---

# ARC-CON-070 — Wave Accounting

[Contract catalog](README.md) · [Waves Module](../Modules/ARC-MOD-080-waves.md) ·
[Enemy AI](../Modules/ARC-MOD-070-enemy-ai.md)

## Purpose

Track exactly which spawned actors belong to a wave without depending on the final
boar class or treating arbitrary actor destruction as a kill.

## Proposed Assets

- `BPI_RisbackaWaveParticipant`
- `FST_RisbackaWaveDefinition`
- `FST_RisbackaSpawnRequest`
- `FST_RisbackaSpawnResult`

## Participant Interface

| Function | Inputs | Outputs | Rule |
|---|---|---|---|
| `ConfigureWaveParticipant` | `Director: Actor`, `WaveToken: Guid` | `Configured: bool` | Called once after a successful spawn |
| `GetWaveToken` | — | `WaveToken: Guid` | Pure query |
| `ReportWaveParticipantFinished` | `Reason: Name` | `Accepted: bool` | Accepted once by the matching director/token |

The director owns a registered set, not only an integer. Duplicate or unknown reports
are ignored and logged for tests.

Both commands return a boolean so a duplicate configuration or a duplicate
completion report is observable to a test rather than silently absorbed.
`WaveToken` is a `Guid`, matching `FST_RisbackaSpawnResult.WaveToken`.

`Reason` is a `Name` rather than an enum, consistent with
`FST_RisbackaDamageRequest.DamagePurpose` and `FST_RisbackaResourceChange.Reason`.
Cleanup and cancel paths must each use a documented, stable reason name.

## Director Events

- `OnWaveStarted(WaveIndex, PlannedCount)`
- `OnLivingEnemyCountChanged(Current)`
- `OnWaveCleared(WaveIndex)`
- `OnAllWavesCleared()`

## Test Obligations

- Failed spawns do not enter the living set.
- Duplicate completion does not decrement twice.
- Cleanup/cancel has a documented completion reason.
- Exactly three configured waves complete once in order.
- Enemy class can be replaced by a disposable test participant.
