# Risbacka MCP Python bridge (temporary dev tool).
#
# Watches <Project>/Saved/rtapy/cmd.json for a Python command and executes it in
# the editor's real Python interpreter, with `unreal` (and TAPython libraries)
# fully available. Results are written to <Project>/Saved/rtapy/out.json.
#
# Command file : {"id": "<unique>", "code": "<python source>"}
# Result file  : {"id": "<same>", "ok": bool, "output": <jsonable>,
#                 "stdout": "<captured>", "error": "<traceback or absent>"}
#
# The executed code may set a variable named `output` to return a JSON-able value.
# This bridge only acts when a command file is present and idle otherwise.
# To disable it: delete this file (Content/Python/init_unreal.py) and restart.

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
