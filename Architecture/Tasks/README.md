---
id: ARCH-TASK-BOARD
type: architecture-task-board
status: active
updated: 2026-07-29
tags:
  - architecture
  - architecture/task
---

# Architecture Task Board

[Architecture home](../README.md) ·
[Implementation sequence](../Plans/Implementation-Sequence.md) ·
[Feature task board](../../Tasks/README.md)

Machine scheduling and typed milestones live in the
[Agent Task Graph](../../Agent-Orchestration/task-graph.json); see the
[orchestration guide](../../Agent-Orchestration/README.md). This board is a
human-readable architecture summary.

This board tracks architecture gates separately from playable feature implementation.
Each parent task contains:

1. a compileable public shell;
2. a focused test that fails for the expected missing behavior;
3. implementation through the linked feature task;
4. green/regression evidence and refactoring;
5. an independent review in a fresh context.

## Status Legend

| Status | Meaning |
|---|---|
| `READY` | Prerequisites are satisfied and an owner may claim the work |
| `BLOCKED` | A listed prerequisite or feature implementation is incomplete |
| `IN_PROGRESS` | One owner is executing the subtask's declared `stage` |
| `REVIEW_READY` | Implementation/evidence is frozen at a named commit |
| `IN_REVIEW` | Fresh-context reviewer is inspecting the finished increment |
| `CHANGES_REQUESTED` | Review found required corrections |
| `DONE` | Tests pass, quality checks pass, and independent review approved |

Shell, red-test, implementation, and independent-review are task `stage` values,
not alternate lifecycle statuses.

## Coordination Contract

1. Read the module, contracts, architecture task, linked feature task, and
   [CONTRIBUTING.md](../../CONTRIBUTING.md).
2. Claim exact production and test asset paths before opening Unreal.
3. Complete the shell subtask without implementing target behavior.
4. Complete the red-test subtask and record the expected failure.
5. Hand implementation to the linked feature task; do not duplicate it here.
6. After green/refactor evidence reaches `REVIEW_READY`, hand the review
   subtask to a new context.
7. The reviewer may inspect and report but must not silently modify production assets.
8. Parent and feature tasks reach `DONE` only after approval against a named commit.

## Board

| ID | Architecture increment | Status | Contract-ready prerequisite | Feature implementation |
|---|---|---|---|---|
| [ARCH-TASK-001](01-contracts/ARCH-TASK-001-contracts.md) | Shared contracts | `READY` | — | TASK-001 |
| [ARCH-TASK-010](02-runtime-composition/ARCH-TASK-010-runtime-composition.md) | Runtime and composition | `BLOCKED` | ARCH-001 shell | TASK-001, TASK-090 |
| [ARCH-TASK-020](03-camera/ARCH-TASK-020-camera.md) | Camera and local co-op | `BLOCKED` | ARCH-001 shell, runtime context | TASK-010 |
| [ARCH-TASK-030](04-cycle-waves/ARCH-TASK-030-cycle-waves.md) | Cycle and waves | `BLOCKED` | ARCH-001 shell, runtime context | TASK-020, TASK-060 |
| [ARCH-TASK-040](05-health-ai/ARCH-TASK-040-health-ai.md) | Health, objectives, and enemy AI | `BLOCKED` | ARCH-001 shell, runtime context | TASK-030, TASK-050 |
| [ARCH-TASK-050](06-resources-building/ARCH-TASK-050-resources-building.md) | Resources and building | `BLOCKED` | ARCH-001 shell, health contract | TASK-040, TASK-070 |
| [ARCH-TASK-060](07-ui/ARCH-TASK-060-ui.md) | Shared HUD read model | `BLOCKED` | Producer contracts stable | TASK-080 |
| [ARCH-TASK-070](08-integration-review/ARCH-TASK-070-integration-review.md) | Integration and architecture acceptance | `BLOCKED` | Domain reviews approved | TASK-090, TASK-100 |

## Parallel Work

After ARCH-TASK-001 provides compileable contracts and ARCH-TASK-010 provides the
minimal runtime context, ARCH-TASK-020, 030, 040, and 050 shells/tests may proceed
in separate worktrees/checkouts on different computers. Their linked feature
tasks retain the binary-asset lease order in the
[feature board](../../Tasks/README.md).

ARCH-TASK-060 starts when producer APIs are stable. ARCH-TASK-070 is the single-owner
composition and final conformance gate.

## Templates

- [Architecture task template](templates/ARCH-TASK-TEMPLATE.md)
- [Architecture subtask template](templates/ARCH-SUBTASK-TEMPLATE.md)
- [Independent review template](templates/ARCH-REVIEW-TEMPLATE.md)
