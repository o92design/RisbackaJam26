---
id: ARCH-SUBTASK-010B
parent: ARCH-TASK-010
stage: red-test
status: REVIEW_READY
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-010A
updated: 2026-07-29
tags:
  - architecture/task
  - testing
---

# ARCH-SUBTASK-010B — Runtime and Initialization Red Tests

Parent: [ARCH-TASK-010](../ARCH-TASK-010-runtime-composition.md) ·
[TDD workflow](../../../Plans/TDD-Workflow.md)

## Work

- Test valid/invalid initialization and repeat calls.
- Drive competing success/failure requests through public commands.
- Simulate solo and two-player death facts with test emitters.
- Prove the shell fails the expected transition/initialization behavior.

## Acceptance Criteria

- Tests load and call only public contracts.
- At least one named behavior assertion is red for the expected reason.
- Duplicate binding/event counts are asserted.
- No prototype map is required.

## Handoff

- Test assets: four Functional Tests and one discovery map under
  `/Game/RisbackaJam26/Tests/Architecture/Runtime/`.
- Expected red result: the runtime shell does not yet arbitrate terminal
  requests or provide solo/two-player life-emitter behavior.
- Actual result: focused run completed 1/4 passed and 3/4 failed with named
  assertions. Terminal arbitration failed with `Expected=state transition
  after success; Actual=state unchanged`; solo and two-player checks failed
  with explicit missing-life-emitter diagnostics.
- Linked feature tasks: TASK-001, TASK-090
- Red-test command: Unreal Automation `RunTests` for the four
  `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Runtime.Maps.L_FT_Runtime_Composition.*` tests.
- Regression checks: `Scripts/Test-AgentTaskGraph.ps1` and
  `Scripts/CI/Test-Project.ps1` passed; all four test Blueprints compiled with
  warnings treated as errors.
- Commit: immutable candidate SHA recorded in the coordinator handoff.
