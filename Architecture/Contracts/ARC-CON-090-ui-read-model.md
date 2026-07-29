---
id: ARC-CON-090
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-010
  - ARC-CON-020
  - ARC-CON-040
  - ARC-CON-070
updated: 2026-07-29
tags:
  - architecture/contract
  - ui
---

# ARC-CON-090 — UI Read Model

[Contract catalog](README.md) · [Shared HUD](../Modules/ARC-MOD-090-ui.md)

## Purpose

Make the shared HUD a read-only consumer of authoritative gameplay state.

## Required Source APIs

| Source | Initial read | Change event |
|---|---|---|
| Run coordinator | `GetRunState` | `OnRunStateChanged` |
| Day/night manager | `GetPhaseSnapshot` | `OnPhaseChanged`, `OnClockUpdated` |
| Home health | `GetHealthSnapshot` | `OnHealthChanged`, `OnDestroyed` |
| Wood storage | `GetStoredWood` | `OnStoredWoodChanged` |
| Wave director | `GetWaveSnapshot` | wave/living-count events |
| Player-life source | `GetLocalPlayerSnapshot` | `OnLocalPlayerStateChanged` |

The composition root supplies these references once. Widgets perform an initial read,
bind once, update explicit fields, and unbind on teardown.

## Rules

- No property binding that polls gameplay values every frame.
- No `Get Actor Of Class` from widgets.
- No gameplay command or mutation from status widgets.
- Only local player 0 creates the shared HUD.
- Missing optional sources produce a visible test-harness state, not an access error.

## Test Obligations

- Initial values appear before the first change event.
- Each event updates only its related presentation.
- Reinitialization does not create duplicate bindings.
- Widget removal/recreation leaves no stale callbacks.
