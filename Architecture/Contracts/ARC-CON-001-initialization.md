---
id: ARC-CON-001
type: architecture-contract
status: proposed
depends_on: []
updated: 2026-07-29
tags:
  - architecture/contract
  - initialization
---

# ARC-CON-001 — Initialization

[Contract catalog](README.md) · [World Composition](../Modules/ARC-MOD-100-composition.md) ·
[Runtime](../Modules/ARC-MOD-010-runtime.md)

## Purpose

Make startup order, required references, and failed configuration observable. Feature
actors must not rely on an accidental `BeginPlay` order.

## Proposed Assets

- `BPI_RisbackaInitializable`
- `FST_RisbackaInitContext`
- `E_RisbackaInitResult`: `Unset`, `Succeeded`, `AlreadyInitialized`,
  `InvalidConfiguration`

## Interface Functions

| Function | Inputs | Outputs | Rule |
|---|---|---|---|
| `InitializeRisbacka` | `InitContext` | `InitResult` | Safe to call once; repeat returns `AlreadyInitialized` |
| `IsRisbackaInitialized` | — | `IsInitialized` | Pure query with no side effects |
| `ValidateRisbackaConfiguration` | — | `IsValid`, `Errors` | Does not start timers, spawn, or bind twice |

`FST_RisbackaInitContext` contains only shared startup references such as the
composition root and run coordinator. Module-specific references remain explicit
properties on the module's initialization function or configuration struct.

## Users

- `BP_RisbackaWorldBootstrap` calls initialization in dependency order.
- `BP_RunCoordinator`, `BP_DayNightManager`, `BP_WaveDirector`,
  `BP_SharedGameplayCamera`, and HUD implement or expose equivalent initialization.
- Functional tests call the same public initialization path as production.

## Test Obligations

- Valid configuration succeeds once.
- Repeated initialization does not duplicate bindings, timers, players, or waves.
- Missing required references return named errors and do not partially start.
