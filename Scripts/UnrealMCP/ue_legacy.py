"""Legacy curl client for the Unreal Editor MCP server.

Companion to Docs/Unreal-MCP-Python-Bridge.md. Provides thin helpers to call MCP
toolset tools and to drive the TAPython Python bridge (`pyexec`).

Kept for troubleshooting and compatibility. Use `ue.py` for new automation.

Shells out to `curl` because the server rejects urllib's default header set.

Configuration (environment variables, with defaults for the current setup):
  RISBACKA_MCP_URL    MCP endpoint. Default http://127.0.0.1:8123/mcp
  RISBACKA_MCP_SAVED  Editor host's <Project>/Saved/rtapy dir the bridge watches.
                      Default J:/Dev/Projects/Unreal/RisbackaJam26/RisbackaJam26Game/Saved/rtapy

CLI usage:
  python ue.py describe <toolset_name>
  python ue.py <tool_name> [<toolset_name>|-] [<json_args>]
"""
import json
import os
import subprocess
import sys
import tempfile
import time
import uuid

URL = os.environ.get("RISBACKA_MCP_URL", "http://127.0.0.1:8123/mcp")
SIDFILE = os.path.join(tempfile.gettempdir(), "risbacka-mcp-session")
_rid = [10]

_A = "editor_toolset.toolsets.asset.AssetTools"
_SAVED = os.environ.get(
    "RISBACKA_MCP_SAVED",
    "J:/Dev/Projects/Unreal/RisbackaJam26/RisbackaJam26Game/Saved/rtapy",
)
_CMD = _SAVED + "/cmd.json"
_OUT = _SAVED + "/out.json"


def _curl(payload, session=None, dump_headers=False):
    cmd = ["curl", "-s", "-m", "180", "-X", "POST", URL,
           "-H", "Content-Type: application/json",
           "-H", "Accept: application/json, text/event-stream"]
    if session:
        cmd += ["-H", "Mcp-Session-Id: " + session]
    if dump_headers:
        cmd += ["-D", "-", "-o", os.devnull]
    cmd += ["-d", json.dumps(payload)]
    return subprocess.run(cmd, capture_output=True, text=True, timeout=200).stdout


def _new_session():
    out = _curl({"jsonrpc": "2.0", "id": 1, "method": "initialize",
                 "params": {"protocolVersion": "2024-11-05", "capabilities": {},
                            "clientInfo": {"name": "risbacka-mcp", "version": "1.0"}}},
                dump_headers=True)
    for line in out.splitlines():
        if line.lower().startswith("mcp-session-id:"):
            sid = line.split(":", 1)[1].strip()
            with open(SIDFILE, "w") as handle:
                handle.write(sid)
            return sid
    raise RuntimeError("no session id in:\n" + out)


def session(fresh=False):
    if not fresh and os.path.exists(SIDFILE):
        return open(SIDFILE).read().strip()
    return _new_session()


def _parse(body):
    for line in body.splitlines():
        if line.startswith("data:"):
            return json.loads(line[5:].strip())
    return json.loads(body)


def rpc(method, params):
    _rid[0] += 1
    payload = {"jsonrpc": "2.0", "id": _rid[0], "method": method, "params": params}
    body = _curl(payload, session())
    if not body.strip() or "Missing required Mcp-Session-Id" in body:
        body = _curl(payload, session(fresh=True))  # Session expired; re-handshake.
    return _parse(body)


def call(name, args=None, toolset=None):
    """Invoke an Unreal tool, optionally inside a toolset."""
    inner = {"tool_name": name, "arguments": args or {}}
    if toolset:
        inner["toolset_name"] = toolset
    return rpc("tools/call", {"name": "call_tool", "arguments": inner})


def text(resp):
    """Flatten an MCP tool result to plain text."""
    if "error" in resp:
        return "ERROR: " + json.dumps(resp["error"])
    return "\n".join(c.get("text", "") for c in resp.get("result", {}).get("content", []))


def describe(toolset):
    return text(rpc("tools/call", {"name": "describe_toolset",
                                   "arguments": {"toolset_name": toolset}}))


def _unwrap(raw):
    try:
        return json.loads(raw).get("returnValue")
    except Exception:
        return None


def pyexec(code, timeout=30.0):
    """Run `code` in the editor's real Python via the bridge; return its result dict.

    The code may set a variable `output` to return a JSON-able value. Requires the
    bridge (Content/Python/init_unreal.py) to be active; see the companion doc.
    """
    cid = uuid.uuid4().hex
    call("write_file", {"file_path": _CMD, "content": json.dumps({"id": cid, "code": code})}, _A)
    deadline = time.time() + timeout
    while time.time() < deadline:
        raw = _unwrap(text(call("read_file", {"file_path": _OUT}, _A)))
        if raw:
            try:
                res = json.loads(raw)
            except Exception:
                res = None
            if res and res.get("id") == cid:
                return res
        time.sleep(1.0)
    return {"ok": False, "error": "bridge timeout (is init_unreal.py active? restart the editor)"}


def bridge_ping():
    """Cheap liveness check for the bridge."""
    return pyexec("output = {'alive': True, 'ue': unreal.SystemLibrary.get_engine_version()}", timeout=15.0)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    if sys.argv[1] == "describe":
        print(describe(sys.argv[2]))
    else:
        ts = sys.argv[2] if len(sys.argv) > 2 and sys.argv[2] != "-" else None
        args = json.loads(sys.argv[3]) if len(sys.argv) > 3 else {}
        print(text(call(sys.argv[1], args, ts)))
