---
id: SUBTASK-060A
parent: TASK-060
status: BLOCKED
owner: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# SUBTASK-060A — Configurable Wave Director and Spawn Points

[Parent task](../TASK-060-wave-director.md) · [Tasks overview](../../README.md)

## Objective

Implement a reusable, enemy-class-agnostic director and explicit spawn-point actors.

## Work

- Create `Waves/BP_WaveSpawnPoint`.
- Create `Waves/BP_WaveDirector`.
- Expose enemy class, three wave counts, spawn cadence, and inter-wave delay.
- Track successful spawns, living enemies, current wave, and running/completed state.
- Add current-wave, living-count, wave-started, wave-cleared, and completed events.

## Acceptance Criteria

- The director can use any compatible enemy class selected in defaults.
- Only successful spawns increment the living count.
- Enemy death decrements living count once.
- Stop/reset cancels pending timers and returns to a clean pre-wave state.

## Verification and Handoff

- Changed assets:
- Public API/events:
- Timer/reset tests:
- Notes:
