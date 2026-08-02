---
id: TASK-110
title: Safe Blueprint interface automation
status: READY
owner: unassigned
computer: unassigned
branch: unassigned
depends_on: [ARCH-SUBTASK-001B]
architecture_gates: []
updated: 2026-08-02
---

# TASK-110 — Safe Blueprint Interface Automation

[Tasks overview](../README.md) ·
[Python bridge](../../Docs/Unreal-MCP-Python-Bridge.md) ·
[Agent orchestration](../../Agent-Orchestration/README.md)

## Origin

`ARCH-SUBTASK-001B` exposed a gap in the stock Unreal MCP toolset: an agent could
create and edit Blueprints, but could not safely add an existing Blueprint
Interface to an existing Blueprint class. A temporary, task-specific native
bridge proved that `FBlueprintEditorUtils::ImplementNewInterface` can fill the
gap.

Replace that experiment with a reusable, explicit Editor command. Interface
application is the primary operation; compile, save, and reload reporting are
part of the same safe transaction. This is not a general arbitrary-code bridge
or a duplicate "save every dirty asset" command.

## Goal

Provide a deterministic automation command that adds one existing Blueprint
Interface to one existing Blueprint, compiles it, saves it intentionally, and
returns enough structured evidence for an agent to verify the result without
opening the Blueprint manually.

Proposed command:

```text
add_blueprint_interface(blueprint_path, interface_path, compile=true, save=true)
```

The final public name may follow the existing MCP naming convention, but its
arguments and behavior must remain equivalent and be documented.

## Coordinator Preflight and Exclusive Ownership

Use branch `codex/task-110-blueprint-interface-automation` and a dedicated
worktree plus Unreal Editor/MCP session.

The claim must enumerate every new source file and any modified existing file.
Expected ownership is limited to:

- `RisbackaJam26Game/Plugins/RisbackaBlueprintAutomation/`
- the `RisbackaBlueprintAutomation` entry in
  `RisbackaJam26Game/RisbackaJam26Game.uproject`
- the minimum required MCP client/registration files below
  `Scripts/UnrealMCP/`
- `Docs/Unreal-Blueprint-Interface-Automation.md`
- narrowly scoped CI validation for this Editor plugin, if required

Do not edit engine plugins, TAPython, production Blueprints, contract assets,
or the existing automation smoke assets. Do not create
`RisbackaJam26Game/Source/`. Any committed test `.uasset` requires an explicit
path added to the claim before creation.

## Implementation Requirements

### Editor-only plugin

- Implement the native Unreal code in a project plugin named
  `RisbackaBlueprintAutomation`.
- Every module must be `Editor`-only and restricted to Editor targets in the
  plugin descriptor.
- Use supported Unreal Editor APIs such as `FBlueprintEditorUtils`,
  `FKismetEditorUtilities`, the Asset Registry, and editor asset-save APIs.
- Do not mutate assets during module startup or Editor startup.
- Do not hard-code task-specific `/Game/...` paths.
- Do not expose arbitrary Python, console-command, file-write, or native-code
  execution.

### Preconditions

Before mutation, the command must:

- normalize and validate both package paths;
- restrict targets to project-owned `/Game/` content;
- load the target and prove it is a modifiable Blueprint;
- load the interface and prove it is a Blueprint Interface;
- reject missing, redirector-only, engine, plugin, cooked, or read-only targets;
- detect whether the interface is already implemented.

### Transaction behavior

- If the interface is absent, add it through the Blueprint editor API and mark
  the Blueprint structurally modified.
- If the interface is already present, return a successful idempotent result
  without adding a duplicate or dirtying the package unnecessarily.
- When compilation is requested, treat warnings and errors as failure.
- Save only the explicitly named Blueprint and only after successful
  validation and compilation.
- On any failed mutation or compile, leave no persistent partial change. Roll
  back or reload the asset and report whether cleanup succeeded.
- Never save unrelated dirty packages.
- Interface removal is destructive and is out of scope for the first version.

### Structured result

Return a machine-readable result containing at least:

```text
blueprint_path
interface_path
already_present
changed
compile_attempted
compile_succeeded
warnings
errors
save_attempted
saved
dirty_after
rollback_attempted
rollback_succeeded
message
```

Transport errors and Unreal validation failures must be distinguishable.
Messages must identify the failed precondition or stage without requiring log
scraping.

## Test-Driven Delivery

Write the smallest editor automation test for the missing interface operation
before implementing the command. The red result must fail because the command
or operation is unavailable, not because the Editor or transport failed.

Automated coverage must include:

1. Adding a valid interface to a valid Blueprint.
2. Calling the command again and proving idempotency.
3. Invalid Blueprint path.
4. Invalid interface path.
5. Existing non-interface asset supplied as the interface.
6. Unsupported or read-only target rejection.
7. Compile warning/error failure with no persistent partial save.
8. Explicit `save=false` behavior.
9. Successful save followed by Editor restart or package unload/reload.
10. Proof that no unrelated dirty package was saved.

Prefer transient or generated test packages that are removed at test cleanup.
If persistent fixtures are necessary, the coordinator must approve and claim
their exact `/Game/RisbackaJam26/Tests/Tooling/...` paths before creation.
Generated files, binaries, and intermediate build products must not be
committed.

## Out of Scope

- Generic Blueprint graph authoring
- Creating user-defined enums or structs
- Replacing the existing trusted TAPython bridge
- Applying interfaces to C++ classes
- Removing interfaces
- Batch mutation or wildcard asset selection
- Runtime or packaged-game functionality
- Changes to production interfaces or gameplay assets

## Acceptance Criteria

- One explicit command applies an existing Blueprint Interface to an existing
  Blueprint using only the supplied asset paths.
- A second identical invocation succeeds as an idempotent no-op.
- Valid changes compile without warnings, save only the target, and survive a
  clean Editor restart.
- Invalid paths, asset types, compile results, and save failures return
  structured failure without a persistent partial mutation.
- The plugin performs no startup mutation and contains no task-specific path.
- The plugin is excluded from non-Editor targets and packaged builds.
- `RisbackaJam26Game/Source/` remains absent.
- The existing MCP tools and automation smoke test remain unchanged unless an
  exact integration file was approved in the claim.
- Documentation includes setup, command schema, result schema, examples,
  security boundaries, and recovery behavior.

## Verification

- Build the `RisbackaJam26GameEditor` target with the plugin enabled.
- Run the focused editor automation suite twice.
- Restart the Editor and repeat the successful add/idempotency/reload check.
- Independently inspect the target with existing asset discovery/class and
  Blueprint inspection tools.
- Run `Scripts/Test-AgentTaskGraph.ps1`.
- Run `Scripts/CI/Test-Project.ps1`.
- Run `.\Test.ps1`.
- Verify a non-Editor target does not load or package the plugin.
- Verify `git status` contains only claimed source, registration,
  documentation, project-plugin configuration, and test files.

## Review and Handoff

Hand off an immutable commit to a fresh reviewer with:

- the exact command and result schemas;
- red and green test commands/results;
- the two focused post-restart results;
- invalid-input and rollback evidence;
- build, regression, and non-Editor exclusion results;
- the exact changed paths;
- confirmation that no production asset or unrelated dirty package was saved;
- remaining API-version or Editor-session risks.

The task reaches `DONE` only after independent review returns `APPROVED`.
