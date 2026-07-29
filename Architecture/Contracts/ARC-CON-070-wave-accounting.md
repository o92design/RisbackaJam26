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

| Function | Rule |
|---|---|
| `ConfigureWaveParticipant(Director, WaveToken)` | Called once after a successful spawn |
| `GetWaveToken()` | Pure query |
| `ReportWaveParticipantFinished(Reason)` | Accepted once by the matching director/token |

The director owns a registered set, not only an integer. Duplicate or unknown reports
are ignored and logged for tests.

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
