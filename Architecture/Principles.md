---
id: ARC-PRINCIPLES
type: architecture-policy
status: proposed
updated: 2026-07-29
tags:
  - architecture
  - architecture/policy
---

# Architecture Principles

[Architecture home](README.md) · [System map](System-Map.md) ·
[Independent review](Plans/Independent-Review.md)

## 1. Blueprint Modules, Not a Hidden C++ Migration

Phase 1 remains Blueprint-only as decided in
[Technical Decisions](../Docs/Technical-Decisions.md). The folders and assets described
here are logical runtime modules. Introduce C++ only through a separate decision that
states the problem, migration cost, build impact, and Blueprint API.

## 2. One State Owner

Every mutable fact has one authoritative owner:

| State | Owner |
|---|---|
| Run outcome | `BP_RunCoordinator` |
| Current day/night phase and time | `BP_DayNightManager` |
| Home/fence/boar health | Each actor's `BPC_Health` |
| Stored wood | `BP_WoodStorage` |
| Placement transaction | Initiating `BPC_BuildMode`, committed by storage |
| Current wave and living count | `BP_WaveDirector` |
| Camera framing | `BP_SharedGameplayCamera` |

Consumers read through public functions and react to event dispatchers. They must not
maintain competing copies of authoritative state.

## 3. Explicit Composition

`BP_RisbackaWorldBootstrap` is the composition root for placed world systems. It owns
editable references, validates them once, and initializes modules in a documented
order. A single composition-root lookup is acceptable; scattered
`Get All Actors Of Class`, tag searches, and Level Blueprint wiring are not.

See [World Composition](Modules/ARC-MOD-100-composition.md) and
[Initialization Contract](Contracts/ARC-CON-001-initialization.md).

## 4. Depend on Contracts

Cross-module calls use the contracts in [Contracts](Contracts/README.md). Concrete
Blueprint class references are allowed inside a module and at the composition root,
but a feature module must not reach into another module's internal graph or variables.

Events flow outward; commands flow inward:

```text
Caller -> public command/interface -> state owner
State owner -> event dispatcher -> interested consumers
```

## 5. Thin Shared Assets

The GameMode, player Blueprint, prototype map, and project configuration are binary
merge hotspots. Keep them thin:

- GameMode creates players and starts composition.
- Player delegates carry/build behavior to actor components.
- The map places and references systems but contains no business logic.
- Configuration selects defaults; it does not encode gameplay rules.

This protects the asset-lease policy in [CONTRIBUTING.md](../CONTRIBUTING.md).

## 6. Event-Driven, Not Tick-Driven

Tick is reserved for continuous spatial behavior such as camera interpolation,
placement preview traces, and AI movement. HUD values, resource balances, phase
changes, health, and run outcomes update from dispatchers or explicit setters.

Any new Tick must document:

1. why an event or timer is insufficient;
2. how work is bounded;
3. how it is disabled when inactive.

## 7. Deterministic Test Seams

Durations, spawn classes, costs, health, target references, and phase transitions are
configurable. Tests must be able to accelerate time and use disposable actors without
editing production graphs.

Follow [TDD Workflow](Plans/TDD-Workflow.md): compileable shell, meaningful red test,
implementation, green test, refactor, regression, then independent review.

## 8. Quality Is Part of Done

A passing happy path is necessary but insufficient. Done also requires:

- clear ownership and dependency direction;
- named functions with narrow responsibilities;
- no new compile warnings;
- failure and re-entry behavior;
- no vendor/template edits;
- no circular module dependency;
- automated evidence where deterministic;
- independent review from a fresh context.

The required evidence is defined in
[Independent Review](Plans/Independent-Review.md).
