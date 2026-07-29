---
id: TASK-###
title: Replace with task title
status: BLOCKED
owner: unassigned
computer: unassigned
context: unassigned
branch: unassigned
worktree: unassigned
base_sha: unassigned
implementation_commit: unassigned
reviewer: unassigned
review_context: unassigned
reviewed_commit: unassigned
depends_on: []
architecture_gates: []
updated: YYYY-MM-DD
---

# TASK-### — Task Title

[Tasks overview](../README.md) ·
[Agent orchestration](../../Agent-Orchestration/README.md)

## Architecture Gate

- Link the owning architecture module.
- Link every public contract this task consumes or changes.
- Link the shell/red-test/review architecture task.
- State what evidence is required before implementation and before `DONE`.

## Goal

State one concrete player-visible or technical outcome.

## Dependencies

- Link every prerequisite task, or state `None`.

## Exclusive Ownership

- List every `.uasset`, `.umap`, or config file this task may edit.
- At claim time, replace broad planning scopes with exact paths and lease keys.

## Deliverables

- List concrete assets and behavior.

## Subtasks

| Subtask | Status |
|---|---|
| `SUBTASK-###A` (`subtasks/SUBTASK-###A-name.md`) | `BLOCKED` |

## Out of Scope

- State what this task must not expand into.

## Acceptance Criteria

- Use observable pass/fail statements.

## Verification

- List compilation, automated tests, and PIE checks.

## Handoff

- Red test and expected failure:
- Changed assets:
- Green/regression tests:
- Known limitations:
- Immutable implementation commit:
- Independent review outcome/commit:
