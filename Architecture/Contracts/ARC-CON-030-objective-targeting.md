---
id: ARC-CON-030
type: architecture-contract
status: proposed
depends_on:
  - ARC-CON-020
updated: 2026-07-29
tags:
  - architecture/contract
  - ai
---

# ARC-CON-030 — Objective Targeting

[Contract catalog](README.md) · [Enemy AI](../Modules/ARC-MOD-070-enemy-ai.md) ·
[Health & Objectives](../Modules/ARC-MOD-040-health-objectives.md)

## Purpose

Allow enemy AI to act on an explicitly assigned target without searching for a
specific home or player class.

## Proposed Asset

- `BPI_RisbackaObjective`

## Interface Functions

| Function | Outputs | Rule |
|---|---|---|
| `GetObjectiveTargetActor` | Actor | Stable actor used for navigation/attack |
| `GetObjectiveAimLocation` | Vector | Optional attack/navigation focus |
| `IsObjectiveAvailable` | Boolean | False when destroyed or intentionally inactive |
| `GetObjectivePriority` | Integer | Higher wins only when composition supplies alternatives |

`BP_HomeStructure` implements the objective. A damageable fence is a blocker, not a
replacement main objective. AI receives the home reference from composition or its
spawn request and only switches to a blocker when path/overlap logic requires it.

## Dependency Rule

- AI may depend on this interface and the damage contract.
- The objective must not know which AI class is attacking it.
- StateTree tasks receive the target through context; they do not call world searches.

## Test Obligations

- Reachable home is selected over nearby players.
- Missing/destroyed target produces a controlled idle/failure state.
- A blocker is attacked, then the original objective is resumed.
