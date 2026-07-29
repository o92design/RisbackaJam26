---
id: SUBTASK-100A
parent: TASK-100
status: BLOCKED
owner: unassigned
depends_on: [TASK-090]
updated: 2026-07-29
---

# SUBTASK-100A — Phase 1 Functional Automation

[Parent task](../TASK-100-verification.md) · [Tasks overview](../../README.md)

## Objective

Add deterministic regression coverage without modifying the existing smoke-test asset.

## Work

- Add new Functional Test Blueprints/maps below `Tests/Phase1`.
- Cover accelerated cycle boundaries and event counts.
- Cover wood deposit/no-duplication and failed spending.
- Cover home destruction firing once.
- Cover three-wave completion with accelerated disposable enemies.
- Ensure tests are discoverable by `.\Test.ps1`.

## Acceptance Criteria

- Each test has one named failure path per violated contract.
- Tests pass twice from a fresh Editor session.
- No test depends on manual controller input or full five-minute timing.
- Existing automation smoke assets remain untouched.

## Verification and Handoff

- Changed assets:
- Test names:
- Two-run results:
- Notes:
