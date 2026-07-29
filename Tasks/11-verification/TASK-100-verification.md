---
id: TASK-100
title: Automation and two-player playtest
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-090]
architecture_gates: [ARCH-TASK-070]
updated: 2026-07-29
---

# TASK-100 — Automation and Two-Player Playtest

[Tasks overview](../README.md) · [TASK-090](../10-integration/TASK-090-integration.md)

## Architecture Gate

- Module: [Verification](../../Architecture/Modules/ARC-MOD-110-verification.md)
- Plans: [TDD Workflow](../../Architecture/Plans/TDD-Workflow.md) and
  [Independent Review](../../Architecture/Plans/Independent-Review.md)
- Gate:
  [ARCH-TASK-070](../../Architecture/Tasks/08-integration-review/ARCH-TASK-070-integration-review.md)
- Evidence must trace every feature requirement to a module, test, and reviewed commit.

## Goal

Prove the integrated Phase 1 loop with new automation coverage and a repeatable manual
two-controller playtest.

## Exclusive Ownership

- `/Game/RisbackaJam26/Tests/Phase1/**`
- New test documentation below `Docs/`
- Test-only fixes coordinated with the owning feature task

Do not edit the existing `BP_AutomationSmoke` asset without explicit coordination.

## Deliverables

- Automated tests for critical deterministic contracts
- Manual two-controller playtest checklist and result record
- Regression findings linked back to the responsible task
- Final Phase 1 completion report

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-100A](subtasks/SUBTASK-100A-automation.md) | `BLOCKED` |
| [SUBTASK-100B](subtasks/SUBTASK-100B-playtest.md) | `BLOCKED` |

## Out of Scope

- Feature redesign unless a test proves the acceptance criteria cannot be met
- Final art/performance optimization
- Editing unrelated CI/release scripts

## Acceptance Criteria

- Automated checks cover cycle boundaries, storage accounting, home destruction, and
  wave completion where Unreal automation can do so deterministically.
- The two-controller checklist covers camera, gathering, building, combat, success,
  and all failure paths.
- `.\Test.ps1` passes.
- Every discovered defect is fixed or recorded with owner, severity, and reproduction.

## Verification

- Run new Unreal tests twice from a clean Editor session.
- Run `.\Test.ps1`.
- Complete one full eight-minute two-player playtest.

## Handoff

- Changed assets/docs:
- Automated results:
- Manual result:
- Open defects:
- Commit:
