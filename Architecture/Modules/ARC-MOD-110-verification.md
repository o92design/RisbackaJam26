---
id: ARC-MOD-110
type: architecture-module
status: proposed
depends_on:
  - ARC-MOD-000
updated: 2026-07-29
tags:
  - architecture/module
  - testing
---

# ARC-MOD-110 — Verification

[Module catalog](README.md) · [TDD Workflow](../Plans/TDD-Workflow.md) ·
[Independent Review](../Plans/Independent-Review.md)

## Responsibility

Provide focused functional-test fixtures, command-line regression coverage, evidence
format, and fresh-context architecture inspection.

## Proposed Asset Areas

```text
/Game/RisbackaJam26/Tests/Architecture/
/Game/RisbackaJam26/Tests/<Module>/
```

Keep the existing `BP_AutomationSmoke` and `L_AutomationSmoke` as boot tests. New
feature behavior belongs in separate test maps and must not expand the smoke test.

## Test Naming

- Functional test actor: `BP_FT_<Module>_<Behavior>`
- Test level: `L_FT_<Module>_<Behavior>`
- Test double: `BP_TD_<Contract>_<Case>`
- Data/config: `DA_Test_<Module>_<Case>`

## Public Test Requirements

- Tests use production public contracts.
- Tests can shorten durations and replace spawn classes through configuration.
- Every red test records the expected failure before implementation.
- `.\\Test.ps1` remains the repository regression entry point.
- Manual two-controller evidence supplements, but does not replace, deterministic tests.

## Review Responsibility

The reviewer opens a new context with the specification, commit/diff, and test
evidence—but not the implementation conversation—and follows the
[Independent Review Protocol](../Plans/Independent-Review.md).

## Feature Requirements

- [TASK-100](../../Tasks/11-verification/TASK-100-verification.md)
- Every architecture task's review subtask
