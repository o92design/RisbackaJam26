---
id: ARCH-SUBTASK-070C
parent: ARCH-TASK-070
stage: independent-review
status: BLOCKED
owner: unassigned
computer: unassigned
depends_on:
  - TASK-090:review_ready
updated: 2026-07-29
tags:
  - architecture/task
  - architecture/review
---

# ARCH-SUBTASK-070C — Fresh-Context Integration Review

Parent: [ARCH-TASK-070](../ARCH-TASK-070-integration-review.md) ·
[Review protocol](../../../Plans/Independent-Review.md) ·
[Review template](../../templates/ARCH-REVIEW-TEMPLATE.md)

## Independence

Use a new task/context that did not implement TASK-090. Supply requirements,
architecture notes, exact `REVIEW_READY` commit, test evidence, and known
limitations. Do not supply implementation chat history.

## Inspection

- Trace every feature requirement through the
  [crosswalk](../../../Feature-Task-Crosswalk.md).
- Inspect state owners, dependencies, composition, shared assets, and graph quality.
- Compile every changed Blueprint.
- Run every focused architecture test and `.\\Test.ps1`.
- Exercise accelerated success and failure integration paths.
- Record all findings using the review template.

## Acceptance Criteria

- Every integrated feature uses its public module boundary.
- No unresolved integration or high-impact quality finding remains.
- `APPROVED` names the exact TASK-090 commit and test results.
- If changes are requested, the owning feature task reopens and regression is rerun.
