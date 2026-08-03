---
id: ARCH-SUBTASK-010B
parent: ARCH-TASK-010
stage: red-test
status: IN_PROGRESS
owner: unassigned
computer: unassigned
depends_on:
  - ARCH-SUBTASK-010A
updated: 2026-08-03
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

- Test assets: two player-life emitter doubles, four Functional Tests, and one
  discovery map under `/Game/RisbackaJam26/Tests/Architecture/Runtime/`.
- Expected red result: the runtime shell does not yet arbitrate terminal
  requests, enforce repeat-safe valid initialization, or aggregate solo/two-
  player life-emitter facts.
- Actual result: the four tests now drive public initialization, run-state,
  player registration, life-emitter, and dispatcher contracts. Initialization
  asserts invalid configuration errors, no partial startup, first-call
  `Succeeded`, and repeat `AlreadyInitialized`. Terminal coverage records the
  first accepted state, late-state immunity, and exact state/success/failure
  event counts. Solo and two-player tests register real emitter doubles,
  assert one death per emitter, count observed life events, and query the
  `Alive`/`Dead` snapshot. The shell remains intentionally red; the focused
  run timed out in the initialization path and reported named failures for the
  incomplete runtime behavior.
- Linked feature tasks: TASK-001, TASK-090
- Red-test command: Unreal Automation `RunTests` for the four
  `Project.Functional Tests.RisbackaJam26.Tests.Architecture.Runtime.Maps.L_FT_Runtime_Composition.*` tests.
- Regression checks: `Scripts/Test-AgentTaskGraph.ps1` and
  `Scripts/CI/Test-Project.ps1` passed before the correction; all four test
  Blueprints compile with warnings treated as errors, as do both emitter
  doubles. The focused run must be repeated from the corrected candidate
  worktree before review-ready handoff.
- Commit: pending corrected candidate commit.
