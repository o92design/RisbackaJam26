---
id: ARC-MOD-080
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
  - ARC-MOD-070
updated: 2026-07-29
tags:
  - architecture/module
  - waves
---

# ARC-MOD-080 — Waves

[Module catalog](README.md) ·
[Wave Accounting](../Contracts/ARC-CON-070-wave-accounting.md) ·
[TASK-060](../../Tasks/07-wave-director/TASK-060-wave-director.md)

## Responsibility

Own three-wave scheduling, spawn requests, the registered living set, and wave/night
completion facts. It does not own the day/night clock or enemy decisions.

## Proposed Assets

```text
/Game/RisbackaJam26/Waves/
├── BP_WaveDirector
├── BP_WaveSpawnPoint
├── DA_Phase1WaveSet
└── Structs/
```

## Public API

- `ConfigureWaveSet(Definitions, EnemyClass, SpawnPoints)`
- `BeginNightWaves()`, `CancelWaves(Reason)`, `ResetWaves()`
- `GetWaveSnapshot()`
- [Wave events and participant contract](../Contracts/ARC-CON-070-wave-accounting.md)

## Dependencies and Consumers

- Depends on shared contracts and a configurable participant class.
- Composition binds the cycle's Night event to `BeginNightWaves`.
- Runtime observes `OnAllWavesCleared`.
- HUD observes wave read state.
- WaveDirector does not cast to `BP_BoarPlaceholder` or read the cycle clock.

## Quality/Test Seam

Accelerated data and a disposable participant test exact spawn totals, failed spawn,
duplicate completion, cancellation, living-set consistency, and one completion event.

## Feature Requirements

- [TASK-060](../../Tasks/07-wave-director/TASK-060-wave-director.md)
