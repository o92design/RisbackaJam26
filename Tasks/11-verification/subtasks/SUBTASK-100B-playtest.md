---
id: SUBTASK-100B
parent: TASK-100
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-100A]
updated: 2026-07-29
---

# SUBTASK-100B — Manual Two-Controller Acceptance Playtest

[Parent task](../TASK-100-verification.md) · [Tasks overview](../../README.md)

## Objective

Run and document the complete eight-minute experience with two people/controllers.

## Work

- Create `Docs/Phase1-Playtest-Checklist.md`.
- Verify player assignment, shared framing, simultaneous actions, and HUD readability.
- Complete axe→pickup→carry→storage→fence during Day.
- Complete all three waves during Night.
- Separately exercise base failure, single-player death, and both-player co-op death.
- Record severity, reproduction, owner task, and evidence for every defect.

## Acceptance Criteria

- One complete two-player success run finishes without crash or runtime Blueprint error.
- Every failure path is observed and restarts cleanly.
- All blockers are fixed; non-blockers are recorded with owners.
- `.\Test.ps1` passes after the final fixes.

## Verification and Handoff

- Checklist/result document:
- Test command output:
- Open defects:
- Final Phase 1 recommendation:
