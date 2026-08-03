# Risbacka Editor Bridge plugin

An editor-only plugin at `RisbackaJam26Game/Plugins/RisbackaEditorBridge/` that
exposes editor operations the stock Python and MCP APIs do not, so the contract
pipeline can stay fully automated.

[Agent rules](../AGENTS.md) · [Python bridge](Unreal-MCP-Python-Bridge.md)

## Why it exists

Unreal has no scripted way to make a Blueprint *implement* a Blueprint
interface:

- `UBlueprint.ImplementedInterfaces` is not script-visible, so
  `get_editor_property` / `set_editor_property` cannot reach it.
- `FBPInterfaceDescription` is not reflected, so the array cannot be built even
  if the property were writable. TAPython's typed setters
  (`set_object_property` and friends) cover objects and primitives, not arrays
  of structs.
- `FBlueprintEditorUtils::ImplementNewInterface` is a C++ static rather than a
  `UFUNCTION`, so neither Python glue nor `call_method` reflection can call it.

This was verified by scanning all 11,304 classes exposed to editor Python: every
match on `interface` is a reader (`get_components_by_interface`,
`does_implement_interface`) or belongs to an unrelated system such as MetaSound
or Niagara data interfaces.

Without this plugin, every contract-implementing Blueprint needs a hand step in
**Class Settings → Interfaces → Add** — the architecture is built on Blueprint
interfaces, so that is roughly ten to fifteen actors across the project, and it
cannot be replayed on a fresh checkout or in CI.

## Why a plugin is allowed here

The Blueprint-only baseline forbids a **project** `Source/` directory, and
`Scripts/CI/Test-Project.ps1` enforces exactly that — it checks for
`RisbackaJam26Game/Source`. Plugin C++ is not covered.
[Technical-Decisions](Technical-Decisions.md) states the policy directly:
gameplay is Blueprint-only, plugin functionality may use C++, and the build
machine retains the Visual Studio toolchain. Gameplay stays Blueprint-only.

It is editor-only three times over, so it cannot reach a packaged build:
`"Type": "Editor"` in the `.uplugin`, `TargetAllowList: ["Editor"]` in the
`.uproject`, and a private dependency on `UnrealEd`, which does not exist in a
packaged build and would fail to link. `Scripts/CI/Test-Project.ps1` asserts the
`TargetAllowList` restriction.

## This plugin must be compiled — TAPython is not a precedent for that

TAPython is a project plugin with a `Source/` tree, but its **binaries are
committed**: `Plugins/TAPython/Binaries/Win64/UnrealEditor-TAPython.dll` and
friends are tracked, force-added past the `**/Binaries/` rule in `.gitignore`.
No machine ever compiles it.

`RisbackaEditorBridge` commits source only, with `Binaries/` gitignored, so it
is the first component in this project that a fresh clone must build before the
editor will open. Consequences:

- A new checkout needs the Visual Studio toolchain, not just the editor.
- Build it before first launch, or let the editor's "missing modules — rebuild
  now?" prompt do it.
- If that is unacceptable for a given machine, commit the built DLL the way
  TAPython's is committed.

## API

`unreal.RisbackaBlueprintInterfaceLibrary`:

| Function | Purpose |
|---|---|
| `implement_interface(blueprint, interface_class)` | Adds the interface and compiles. Idempotent. Returns whether the interface is implemented once it returns. |
| `remove_implemented_interface(blueprint, interface_class, preserve_functions=False)` | Removes the interface and compiles. Idempotent. |
| `get_implemented_interfaces(blueprint)` | The interface classes the Blueprint implements directly. |

Neither mutator saves the asset; the caller decides when to save.

`interface_class` is the *generated* class. For a Blueprint interface that is
the `_C` object:

```python
import unreal

LIB = unreal.RisbackaBlueprintInterfaceLibrary
bp = unreal.EditorAssetLibrary.load_asset(
    "/Game/RisbackaJam26/Tests/Architecture/Contracts/BP_TD_Damageable")
iface = unreal.load_object(
    None,
    "/Game/RisbackaJam26/Core/Contracts/BPI_RisbackaDamageable.BPI_RisbackaDamageable_C")

LIB.implement_interface(bp, iface)
unreal.EditorAssetLibrary.save_loaded_asset(bp)
```

Verify independently of the library's own return value, using the engine's
check rather than trusting this plugin:

```python
unreal.SystemLibrary.does_class_implement_interface(bp.generated_class(), iface)
```

Once an interface is implemented, its functions become overridable through the
normal path — `BlueprintEditorLibrary.add_function_override(bp, "RequestDamage")`
returns a real graph instead of `None`.

## Building

The module is compiled by the normal engine build, with no project target of
its own:

```bash
"C:/EpicGames/UE_5.8/Engine/Build/BatchFiles/Build.bat" UnrealEditor Win64 Development -Project="C:/UnrealProjects/RisbackaJam26/RisbackaJam26Game/RisbackaJam26Game.uproject" -WaitMutex
```

Two constraints:

- **The editor must be closed.** Live Coding in a running editor holds the build
  lock and the build fails with `Unable to build while Live Coding is active`.
- **A new module needs a full editor restart**, not a Live Coding patch.

`Binaries/` and `Intermediate/` are gitignored, so a fresh checkout builds the
module on first editor start.

## Adding to it

Keep this plugin narrow: editor automation that is genuinely unreachable from
Python, nothing more. Gameplay logic belongs in Blueprints, per
[Technical-Decisions](Technical-Decisions.md). Before adding a function, confirm
the capability is actually missing rather than merely hard to find — scan
`dir(unreal)` first, as documented above.
