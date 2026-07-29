---
id: SUBTASK-060B
parent: TASK-060
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-060A]
updated: 2026-07-29
---

# SUBTASK-060B — Three-Wave Verification Harness

[Parent task](../TASK-060-wave-director.md) · [Tasks overview](../../README.md)

## Objective

Prove counts, ordering, completion, failure handling, and accelerated timing.

## Work

- Create `Tests/Waves/L_Test_WaveDirector` or a functional-test equivalent.
- Use a disposable enemy that can be removed deterministically.
- Configure three short waves with known totals.
- Test no spawn points, a failed spawn, stop mid-wave, and reset/restart.

## Acceptance Criteria

- Observed spawn total equals the sum of configured successful spawns.
- Wave order is exactly 1, 2, 3.
- Completion fires once only after wave three is cleared.
- Invalid configuration reports an actionable failure instead of hanging.

## Verification and Handoff

- Changed assets:
- Expected/actual event log:
- Edge-case results:
- Notes:
