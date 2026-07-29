---
id: ARC-CON-010
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-001
updated: 2026-07-29
tags:
  - architecture/contract
  - runtime
---

# ARC-CON-010 — Run State

[Contract catalog](README.md) · [Runtime](../Modules/ARC-MOD-010-runtime.md) ·
[Cycle](../Modules/ARC-MOD-030-cycle.md)

## Purpose

Keep time phase separate from the overall run outcome. `Success` and `Failure` are not
times of day.

## Proposed Types

- `E_RisbackaPhase`: `Day`, `Night`
- `E_RisbackaRunState`: `Bootstrapping`, `Ready`, `Playing`, `Success`, `Failure`
- `E_RisbackaFailureReason`: `HomeDestroyed`, `SoloPlayerDead`,
  `AllLocalPlayersDead`, `InvalidConfiguration`

This replaces the earlier proposal to place success and failure inside
`E_RisbackaPhase`.

## Coordinator Functions and Events

| API | Kind | Rule |
|---|---|---|
| `StartRun()` | Command | Valid only from `Ready` |
| `RequestRunSuccess(Source)` | Command | First terminal request wins |
| `RequestRunFailure(Reason, Source)` | Command | First terminal request wins |
| `GetRunState()` | Pure query | Returns authoritative state |
| `OnRunStateChanged(Previous, Current)` | Dispatcher | Fires once per accepted transition |
| `OnRunFailed(Reason)` | Dispatcher | Fires once after state becomes `Failure` |
| `OnRunSucceeded()` | Dispatcher | Fires once after state becomes `Success` |

## Producers

- Home destruction requests `HomeDestroyed`.
- Player life aggregation requests the appropriate player failure.
- Wave completion at the valid night boundary requests success.
- Bootstrap requests `InvalidConfiguration` when startup validation fails.

Producers report facts; they do not open failure screens, pause the world, or restart.

## Test Obligations

- Invalid transitions are rejected.
- Simultaneous terminal requests produce one deterministic terminal state.
- Late events after a terminal state have no effect.
- Solo and two-player death rules are covered independently.
