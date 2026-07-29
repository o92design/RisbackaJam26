---
id: SUBTASK-030B
parent: TASK-030
status: BLOCKED
owner: unassigned
depends_on: [SUBTASK-030A]
updated: 2026-07-29
---

# SUBTASK-030B — Home Health and Destruction Contract

[Parent task](../TASK-030-home-failure.md) · [Tasks overview](../../README.md)

## Objective

Expose clean, integration-friendly signals for health UI and base-destruction failure.

## Work

- Add `OnHomeHealthChanged(Current, Max, Normalized)` dispatcher.
- Add parameterless `OnHomeDestroyed` dispatcher.
- Ensure destruction fires once even if multiple damage events arrive in one frame.
- Add a reset path suitable for tests and run restart.
- Create `Tests/Home/L_Test_HomeStructure` or an equivalent functional test.

## Acceptance Criteria

- Health dispatcher reports the post-damage value.
- Destruction dispatcher fires exactly once.
- Reset restores health, presentation, and dispatcher eligibility.

## Verification and Handoff

- Dispatcher-count results:
- Changed assets:
- Integration instructions:
- Notes:
