---
id: ARC-MOD-010
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
updated: 2026-07-29
tags:
  - architecture/module
  - runtime
---

# ARC-MOD-010 — Runtime Coordination

[Module catalog](README.md) · [Run State Contract](../Contracts/ARC-CON-010-run-state.md) ·
[ARCH-TASK-010](../Tasks/02-runtime-composition/ARCH-TASK-010-runtime-composition.md)

## Responsibility

Own overall run state and terminal-outcome arbitration. It coordinates facts reported
by other modules but does not implement their behavior.

## Proposed Assets

```text
/Game/RisbackaJam26/Core/
├── BP_GM_Risbacka
├── BP_RunCoordinator
└── BP_PlayerLifeAggregator
```

`BP_GM_Risbacka` stays thin: create local players, select starts, locate exactly one
composition root, and request startup. `BP_RunCoordinator` owns
`E_RisbackaRunState`. `BP_PlayerLifeAggregator` observes the registered local players
and reports solo/all-player death.

## Public API

- [Initialization](../Contracts/ARC-CON-001-initialization.md)
- [Run State](../Contracts/ARC-CON-010-run-state.md)
- Read-only player-life snapshot for [UI](ARC-MOD-090-ui.md)

## Dependencies

- [Shared Contracts](ARC-MOD-000-contracts.md)
- Signals from [Cycle](ARC-MOD-030-cycle.md),
  [Health & Objectives](ARC-MOD-040-health-objectives.md), and
  [Waves](ARC-MOD-080-waves.md), supplied through composition.

Runtime must not depend on widget classes, AI implementation, storage, or placement.

## Consumers

- [World Composition](ARC-MOD-100-composition.md) initializes it.
- [Shared HUD](ARC-MOD-090-ui.md) observes it.

## Quality/Test Seam

Use test emitters for home, player-life, and wave facts. Verify transition tables,
first-terminal-event wins, repeated events, and restart/reset behavior without loading
the prototype map.

## Feature Requirements

- [TASK-001](../../Tasks/01-foundation/TASK-001-foundation.md)
- [TASK-030](../../Tasks/04-home-failure/TASK-030-home-failure.md)
- [TASK-090](../../Tasks/10-integration/TASK-090-integration.md)
