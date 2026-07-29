# Unreal MCP Python Bridge (TAPython enum/struct workflow)

This guide explains how we drive the Unreal Editor from an MCP client to create the
things the stock MCP asset tools cannot — chiefly Blueprint **enums** and **structs** —
and how to replicate the setup on a fresh machine.

It keeps the project **Blueprint-only**: no `Source/` directory, no C++ module. (CI
enforces this — `Scripts/CI/Test-Project.ps1` fails the build if a `Source/` directory
exists.)

## The problem

The Unreal MCP server (UE 5.8) can create Blueprints, interfaces, components,
DataTables, materials, and place actors. It **cannot**:

- create or populate `UserDefinedEnum` / `UserDefinedStruct` assets — there is no
  enum/struct factory in any toolset, and `BlueprintTools.create` rejects those
  classes; and
- run arbitrary editor Python — there is **no** `execute_python` / `run_editor_script`
  tool, and the `ProgrammaticToolset` sandbox blocks `import unreal` (both by AST and
  by `__import__`).

The fix is two parts:

1. **TAPython** — a plugin that adds `unreal.PythonEnumLib` and
   `unreal.PythonStructLib`, which can populate enum items and struct fields from
   Python.
2. **A startup "bridge"** — a small `init_unreal.py` that lets an MCP client execute
   arbitrary editor Python by writing a command file and reading a result file, since
   there is no direct Python tool. This is the general capability; enum/struct creation
   is one use of it.

## Prerequisites

- Unreal Engine **5.8**.
- The editor MCP plugins enabled (`ModelContextProtocol`, `EditorToolset`,
  `AutomationTestToolset`, `ConfigSettingsToolset`), Editor target only.
- The MCP server reachable from the client (ours: `http://<host>:8000/mcp`,
  JSON-RPC 2.0; it requires the `initialize` handshake and an `Mcp-Session-Id` header
  on every subsequent call).
- **TAPython** installed as a *project* plugin at
  `<Project>/Plugins/TAPython/`. Confirm it is mounted by checking that
  `AssetTools.get_plugin_content_paths` includes `/TAPython/`.

## Setup (replicating on a new machine)

### 1. Install TAPython

Copy the TAPython plugin into `<Project>/Plugins/TAPython/` and let the editor build
its module. Verify the libraries exist (via the bridge below, or the editor's Python
console): `hasattr(unreal, "PythonEnumLib")` and `hasattr(unreal, "PythonStructLib")`
should both be `True`.

### 2. Deploy the bridge

Write the script below to `<Project>/Content/Python/init_unreal.py`. Unreal's Python
plugin auto-runs `init_unreal.py` at editor startup. You can push it with the MCP
`AssetTools.write_file` tool (it accepts paths under the project `Content/` and
`Saved/` directories) or copy it by hand.

```python
# Risbacka MCP Python bridge (dev tool).
#
# Watches <Project>/Saved/rtapy/cmd.json for a Python command and executes it in the
# editor's real Python interpreter, with `unreal` (and TAPython) fully available.
# Results are written to <Project>/Saved/rtapy/out.json.
#
# Command file : {"id": "<unique>", "code": "<python source>"}
# Result file  : {"id": "<same>", "ok": bool, "output": <jsonable>,
#                 "stdout": "<captured>", "error": "<traceback or absent>"}
#
# The executed code may set a variable named `output` to return a JSON-able value.
# This bridge only acts when a command file is present, and is idle otherwise.
# To disable it: delete this file and restart the editor.

import os
import io
import json
import time
import traceback
import contextlib

import unreal

_DIR = os.path.join(unreal.Paths.project_saved_dir(), "rtapy")
_CMD = os.path.join(_DIR, "cmd.json")
_OUT = os.path.join(_DIR, "out.json")
_state = {"last_id": None, "next_check": 0.0}

try:
    os.makedirs(_DIR, exist_ok=True)
except Exception:
    pass


def _process():
    if not os.path.exists(_CMD):
        return
    try:
        with open(_CMD, "r", encoding="utf-8") as handle:
            cmd = json.load(handle)
    except Exception:
        return  # Likely a partial write; retry on the next tick.

    cid = cmd.get("id")
    if cid is None or cid == _state["last_id"]:
        return
    _state["last_id"] = cid

    namespace = {"unreal": unreal, "json": json, "output": None}
    buffer = io.StringIO()
    result = {"id": cid}
    try:
        with contextlib.redirect_stdout(buffer):
            exec(cmd.get("code", ""), namespace)
        result["ok"] = True
        result["output"] = namespace.get("output")
    except Exception:
        result["ok"] = False
        result["error"] = traceback.format_exc()
    result["stdout"] = buffer.getvalue()

    try:
        with open(_OUT, "w", encoding="utf-8") as handle:
            json.dump(result, handle, default=str)
    except Exception:
        pass
    try:
        os.remove(_CMD)
    except Exception:
        pass


def _tick(_delta):
    now = time.time()
    if now < _state["next_check"]:
        return
    _state["next_check"] = now + 0.5  # Poll at 2 Hz to stay cheap.
    _process()


_handle = unreal.register_slate_post_tick_callback(_tick)
unreal.log("[rtapy] Risbacka MCP Python bridge active. Watching: " + _CMD)
```

### 3. Restart the editor once

`init_unreal.py` runs only at startup, so the bridge activates after **one** restart.
After that, no more restarts are needed for any Python work.

### 4. Verify

Send a ping and confirm you get a result (see the client pattern below):

```python
output = {"alive": True, "ue": unreal.SystemLibrary.get_engine_version()}
```

## Driving the bridge from an MCP client

The bridge is client-agnostic — any MCP client that can call `AssetTools.write_file`
and `AssetTools.read_file` can use it:

1. `write_file` `<Project>/Saved/rtapy/cmd.json` = `{"id": "<uuid>", "code": "<python>"}`.
2. Poll `read_file` `<Project>/Saved/rtapy/out.json` until the JSON's `id` matches.
3. Read `ok`, `output`, `stdout`, `error` from the result.

A ready-to-use client is committed at [Scripts/UnrealMCP/ue.py](../Scripts/UnrealMCP/ue.py)
(`pyexec`, `bridge_ping`, plus thin `call`/`describe` helpers; host and Saved path come
from `RISBACKA_MCP_URL` / `RISBACKA_MCP_SAVED`). The essential shape:

```python
import json, time, uuid

def pyexec(call, code, saved_dir, timeout=30.0):
    """`call(tool, args, toolset)` invokes an MCP tool and returns parsed text.
    `saved_dir` is the editor host's <Project>/Saved/rtapy directory."""
    A = "editor_toolset.toolsets.asset.AssetTools"
    cid = uuid.uuid4().hex
    call("write_file", {"file_path": saved_dir + "/cmd.json",
                        "content": json.dumps({"id": cid, "code": code})}, A)
    deadline = time.time() + timeout
    while time.time() < deadline:
        raw = call("read_file", {"file_path": saved_dir + "/out.json"}, A)
        try:
            res = json.loads(json.loads(raw)["returnValue"])  # unwrap MCP + file
            if res.get("id") == cid:
                return res
        except Exception:
            pass
        time.sleep(1.0)
    return {"ok": False, "error": "bridge timeout (is init_unreal.py active?)"}
```

## Creating enums and structs with TAPython

### Enums

```python
atl = unreal.AssetToolsHelpers.get_asset_tools()
enum = atl.create_asset("E_Name", "/Game/Path", unreal.UserDefinedEnum, unreal.EnumFactory())
unreal.PythonEnumLib.set_enum_items(enum, ["EntryA", "EntryB"])   # display names
unreal.EditorAssetLibrary.save_loaded_asset(enum)
```

The raw enumerator names are auto-generated (`E_Name::NewEnumerator0`, ...); the strings
you pass become the **display names** that Blueprints show.

### Structs

```python
atl = unreal.AssetToolsHelpers.get_asset_tools()
struct = atl.create_asset("FST_Name", "/Game/Path", unreal.UserDefinedStruct, unreal.StructureFactory())
defaults = list(unreal.PythonStructLib.get_variable_names(struct))   # one auto member
unreal.PythonStructLib.add_variable(struct, category, sub_category,
                                    sub_category_object, container, is_reference, friendly_name)
# ...add all real fields, THEN remove the auto-created default member:
for d in defaults:
    unreal.PythonStructLib.remove_variable_by_name(struct, d)
unreal.EditorAssetLibrary.save_loaded_asset(struct)
```

`add_variable(struct, category, sub_category, sub_category_object, container_type, is_reference, friendly_name)`
field-type tokens (verified on UE 5.8):

| Field type | `category` | `sub_category` | `sub_category_object` | `container` |
|---|---|---|---|---|
| bool | `bool` | `""` | `None` | 0 |
| int | `int` | `""` | `None` | 0 |
| float | `real` | `float` | `None` | 0 |
| name | `name` | `""` | `None` | 0 |
| string | `string` | `""` | `None` | 0 |
| enum | `byte` | `""` | the enum asset (`load_asset`) | 0 |
| struct | `struct` | `""` | the `ScriptStruct` (`unreal.load_object(None, "/Script/CoreUObject.Transform")`) | 0 |
| object ref | `object` | `""` | `UClass` (`unreal.Actor.static_class()`) | 0 |
| class ref (`TSubclassOf`) | `class` | `""` | `UClass` (`unreal.Actor.static_class()`) | 0 |
| array / set | *(as above)* | | | 1 / 2 |

Notes:
- Pass the `UClass` **object** (`.static_class()`), not the Python type — the type
  fails to convert.
- A `UserDefinedStruct` must always have at least one member, so add real fields
  *before* removing the default member.
- Inspect any field with
  `unreal.PythonStructLib.get_variable_description(struct, friendly_name)` — a
  `{Category, SubCategory, SubCategoryObject, ContainerType, ...}` map — to confirm or
  discover tokens.

### Verify from the MCP side

After creation, confirm independently with the standard asset tool rather than trusting
the script's own report:

```
AssetTools.find_assets { folder_path: "/Game/Path", name: "", recursive: true }
AssetTools.get_asset_class { asset_path: "/Game/Path/E_Name" }   -> "UserDefinedEnum"
```

## Removal and safety

The bridge executes arbitrary Python and auto-runs at every editor start while present.
Treat it as a **development tool on a trusted machine**:

- Command I/O lives under `Saved/` (gitignored) and the bridge is idle unless a command
  file exists.
- To disable: delete `<Project>/Content/Python/init_unreal.py` and restart.
- Do **not** commit `init_unreal.py` into `Content/Python/` unless the team explicitly
  accepts that every checkout auto-activates the bridge. This guide keeps the script as
  copy-paste text for that reason.
