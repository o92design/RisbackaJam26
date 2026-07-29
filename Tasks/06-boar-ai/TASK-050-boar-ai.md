---
id: TASK-050
title: Placeholder boar and objective AI
status: BLOCKED
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [TASK-001]
updated: 2026-07-29
---

# TASK-050 — Placeholder Boar and Objective AI

[Tasks overview](../README.md) · [TASK-001](../01-foundation/TASK-001-foundation.md)

## Goal

Adapt the Combat enemy into a placeholder boar that navigates toward a configured
objective, attacks blocking defenses, and can be killed by the player.

## Exclusive Ownership

- `/Game/RisbackaJam26/Enemies/**`
- `/Game/RisbackaJam26/Tests/Enemies/**`

## Deliverables

- `BP_BoarPlaceholder`
- Risbacka-owned AI controller/StateTree assets as needed
- Configurable objective discovery, preferably by explicit reference or stable tag
- Attack behavior for the home and damageable blockers
- Death event usable by the wave director

## Subtasks

| Subtask | Status |
|---|---|
| [SUBTASK-050A](subtasks/SUBTASK-050A-boar-placeholder.md) | `BLOCKED` |
| [SUBTASK-050B](subtasks/SUBTASK-050B-objective-ai.md) | `BLOCKED` |

## Out of Scope

- Fab animal import, final animation, or ragdoll polish
- Pack/flanking behavior
- Boss or multiple boar species
- Editing Combat template AI assets

## Acceptance Criteria

- The boar reaches a reachable objective without targeting the nearest player by default.
- A damageable blocker on the route is attacked rather than ignored indefinitely.
- Removing the blocker lets the boar continue toward the objective.
- Player axe damage can kill the boar and produces one death notification.

## Verification

- Dedicated navmesh test with open and blocked paths.
- Compile all owned AI assets.
- Run at least five consecutive spawn-to-objective attempts.

## Handoff

- Changed assets:
- Targeting contract:
- Tests run:
- Commit:
