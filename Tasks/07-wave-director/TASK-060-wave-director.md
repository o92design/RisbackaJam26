---
id: TASK-060
title: Three-wave night director
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
architecture_gates: [ARCH-TASK-030]
updated: 2026-07-29
---

# TASK-060 — Three-Wave Night Director

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Architecture Gate

- Module: [Waves](../../Architecture/Modules/ARC-MOD-080-waves.md)
- Contract:
  [Wave Accounting](../../Architecture/Contracts/ARC-CON-070-wave-accounting.md)
- Gate:
  [ARCH-TASK-030](../../Architecture/Tasks/04-cycle-waves/ARCH-TASK-030-cycle-waves.md)
- The director owns a registered living set and never depends on the concrete boar
  class. `DONE` requires the independent cycle/wave review.

## Goal

Create a configurable director that runs three escalating waves within a five-minute
night and reports progress without depending on the final boar class.

## Exclusive Ownership

- `/Game/RisbackaJam26/Waves/**`
- `/Game/RisbackaJam26/Tests/Waves/**`

## Deliverables

- `BP_WaveDirector`
- `BP_WaveSpawnPoint`
- Configurable enemy class, wave counts, spawn cadence, and inter-wave delay
- Current wave, living enemy count, and night-complete events
- Accelerated test configuration

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-060A](subtasks/SUBTASK-060A-wave-director.md) | `BLOCKED` |
| [SUBTASK-060B](subtasks/SUBTASK-060B-wave-verification.md) | `BLOCKED` |

## Out of Scope

- Day/night clock ownership
- Boar targeting logic
- Final difficulty balance or endless mode
- HUD

## Acceptance Criteria

- Exactly three waves run in order.
- Spawn totals match configured counts.
- Living count returns to zero after each cleared wave.
- Completion fires once after the third wave clears.
- Enemy class is replaceable without graph edits.

## Verification

- Run accelerated waves using a disposable test enemy.
- Test missing spawn points and failed spawn attempts.
- Compile and reload all wave assets.

## Handoff

- Changed assets:
- Public events/properties:
- Tests run:
- Commit:
