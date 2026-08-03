#!/usr/bin/env python3
"""Main Risbacka client for Unreal MCP and the editor Python bridge.

The client is agent-neutral and dependency-free. Configuration precedence:

1. CLI options (``--url`` / ``--saved-dir``)
2. ``RISBACKA_MCP_URL`` / ``RISBACKA_MCP_SAVED``
3. ``Scripts/UnrealMCP/client.json`` (shared by every agent)
4. A repository ``.mcp.json`` entry named ``unreal-mcp``
5. A repository ``.codex/config.toml`` entry named ``unreal-mcp``
6. Local Unreal defaults and automatic ``.uproject`` discovery

Examples:

  python Scripts/UnrealMCP/ue.py status
  python Scripts/UnrealMCP/ue.py toolsets
  python Scripts/UnrealMCP/ue.py call get_asset_class \
    --toolset editor_toolset.toolsets.asset.AssetTools \
    --arg asset_path=/Game/CodexTestEnum
  python Scripts/UnrealMCP/ue.py ping
  python Scripts/UnrealMCP/ue.py pyexec --code "output = 6 * 7"
"""

from __future__ import annotations

import argparse
import http.client
import json
import os
import sys
import time
import urllib.parse
import uuid
from pathlib import Path
from typing import Any

try:
    import tomllib
except ImportError:  # pragma: no cover - Python 3.11+ is recommended.
    tomllib = None


PROTOCOL_VERSION = "2025-06-18"
DEFAULT_MCP_URL = "http://127.0.0.1:8123/mcp"
ASSET_TOOLSET = "editor_toolset.toolsets.asset.AssetTools"
CLIENT_NAME = "risbacka-unreal-mcp"
CLIENT_VERSION = "2.0.0"

# Compatibility with the original ue.py helper.
_A = ASSET_TOOLSET


class McpError(RuntimeError):
    """Base error for MCP transport, protocol, and tool failures."""


class McpHttpError(McpError):
    """HTTP error carrying the response status."""

    def __init__(self, status: int, detail: str):
        super().__init__(f"MCP HTTP {status}: {detail}")
        self.status = status
        self.detail = detail


def find_repo_root(start: Path | None = None) -> Path:
    current = (start or Path.cwd()).resolve()
    if current.is_file():
        current = current.parent
    for candidate in (current, *current.parents):
        if (candidate / "AGENTS.md").is_file() and (candidate / "RisbackaJam26Game").is_dir():
            return candidate
    script_root = Path(__file__).resolve().parents[2]
    if (script_root / "AGENTS.md").is_file():
        return script_root
    raise McpError("Could not locate the Risbacka repository root")


def _url_from_mcp_json(repo_root: Path) -> str | None:
    config_path = repo_root / ".mcp.json"
    if not config_path.is_file():
        return None
    try:
        config = json.loads(config_path.read_text(encoding="utf-8"))
        server = config.get("mcpServers", {}).get("unreal-mcp", {})
        return server.get("url")
    except (OSError, TypeError, json.JSONDecodeError):
        return None


def _shared_config(repo_root: Path) -> dict[str, Any]:
    config_path = repo_root / "Scripts" / "UnrealMCP" / "client.json"
    if not config_path.is_file():
        return {}
    try:
        config = json.loads(config_path.read_text(encoding="utf-8"))
        return config if isinstance(config, dict) else {}
    except (OSError, json.JSONDecodeError):
        return {}


def _url_from_codex_config(repo_root: Path) -> str | None:
    if tomllib is None:
        return None
    config_path = repo_root / ".codex" / "config.toml"
    if not config_path.is_file():
        return None
    try:
        with config_path.open("rb") as handle:
            config = tomllib.load(handle)
        return config.get("mcp_servers", {}).get("unreal-mcp", {}).get("url")
    except (OSError, TypeError):
        return None


def resolve_url(repo_root: Path, explicit: str | None = None) -> str:
    return (
        explicit
        or os.environ.get("RISBACKA_MCP_URL")
        or os.environ.get("RISBACKA_UNREAL_MCP_URL")
        or _shared_config(repo_root).get("url")
        or _url_from_mcp_json(repo_root)
        or _url_from_codex_config(repo_root)
        or DEFAULT_MCP_URL
    )


def resolve_saved_dir(repo_root: Path, explicit: str | None = None) -> str:
    configured = (
        explicit
        or os.environ.get("RISBACKA_MCP_SAVED")
        or os.environ.get("RISBACKA_UNREAL_SAVED_DIR")
        or _shared_config(repo_root).get("saved_dir")
    )
    if configured:
        configured_path = Path(configured)
        if not configured_path.is_absolute():
            configured_path = repo_root / configured_path
        return configured_path.resolve().as_posix().rstrip("/\\")
    projects = sorted(repo_root.glob("*/*.uproject"))
    if len(projects) != 1:
        raise McpError(
            "Could not uniquely locate the Unreal project. Pass --saved-dir or set "
            "RISBACKA_MCP_SAVED."
        )
    return (projects[0].parent / "Saved" / "rtapy").resolve().as_posix()


def parse_response(body: bytes, content_type: str) -> dict[str, Any] | None:
    if not body.strip():
        return None
    text_body = body.decode("utf-8")
    if "text/event-stream" in content_type or text_body.lstrip().startswith(
        ("event:", "data:")
    ):
        data_lines = [
            line[5:].lstrip()
            for line in text_body.splitlines()
            if line.startswith("data:")
        ]
        if not data_lines:
            raise McpError("MCP returned an SSE response without a data event")
        return json.loads("\n".join(data_lines))
    return json.loads(text_body)


def read_sse_response(response: Any) -> dict[str, Any]:
    """Read one complete SSE event without waiting for Unreal's keep-alive timeout."""
    data_lines: list[str] = []
    while True:
        raw_line = response.readline()
        if not raw_line:
            break
        line = raw_line.decode("utf-8").rstrip("\r\n")
        if line.startswith("data:"):
            data_lines.append(line[5:].lstrip())
        elif not line and data_lines:
            return json.loads("\n".join(data_lines))
    raise McpError("MCP SSE stream ended without a data event")


class McpHttpClient:
    """Synchronous, single-call-at-a-time Streamable HTTP MCP client."""

    def __init__(self, url: str, timeout: float = 30.0):
        self.url = url
        self.timeout = timeout
        parsed = urllib.parse.urlsplit(url)
        if parsed.scheme not in {"http", "https"} or not parsed.hostname:
            raise McpError(f"Unsupported MCP URL: {url}")
        self._connection_type = (
            http.client.HTTPSConnection
            if parsed.scheme == "https"
            else http.client.HTTPConnection
        )
        self._host = parsed.hostname
        self._port = parsed.port
        self._request_target = urllib.parse.urlunsplit(
            ("", "", parsed.path or "/", parsed.query, "")
        )
        self.session_id: str | None = None
        self.protocol_version = PROTOCOL_VERSION
        self.request_id = 0
        self.server_info: dict[str, Any] = {}

    def _post(self, payload: dict[str, Any]) -> dict[str, Any] | None:
        headers = {
            "Accept": "application/json, text/event-stream",
            "Content-Type": "application/json",
        }
        if self.session_id:
            headers["Mcp-Session-Id"] = self.session_id
            headers["Mcp-Protocol-Version"] = self.protocol_version
        connection = self._connection_type(self._host, self._port, timeout=self.timeout)
        try:
            connection.request(
                "POST",
                self._request_target,
                body=json.dumps(payload).encode("utf-8"),
                headers=headers,
            )
            response = connection.getresponse()
            session_id = response.getheader("Mcp-Session-Id")
            if session_id:
                self.session_id = session_id
            content_type = response.getheader("Content-Type", "")
            if response.status >= 400:
                detail = response.read().decode("utf-8", errors="replace")
                raise McpHttpError(response.status, detail)
            if "text/event-stream" in content_type:
                return read_sse_response(response)
            return parse_response(response.read(), content_type)
        except McpError:
            raise
        except (OSError, http.client.HTTPException) as error:
            raise McpError(f"Cannot reach Unreal MCP at {self.url}: {error}") from error
        finally:
            connection.close()

    def request(
        self,
        method: str,
        params: dict[str, Any],
        *,
        retry_stale_session: bool = True,
    ) -> Any:
        self.request_id += 1
        request_id = self.request_id
        payload = {
            "jsonrpc": "2.0",
            "id": request_id,
            "method": method,
            "params": params,
        }
        try:
            response = self._post(payload)
        except McpHttpError as error:
            if error.status == 404 and retry_stale_session and method != "initialize":
                self.session_id = None
                self.initialize()
                return self.request(method, params, retry_stale_session=False)
            raise
        if response is None:
            raise McpError(f"MCP returned no response for {method}")
        if "error" in response:
            raise McpError(f"MCP {method} failed: {json.dumps(response['error'])}")
        return response.get("result")

    def notify(self, method: str, params: dict[str, Any] | None = None) -> None:
        payload: dict[str, Any] = {"jsonrpc": "2.0", "method": method}
        if params is not None:
            payload["params"] = params
        self._post(payload)

    def initialize(self) -> dict[str, Any]:
        result = self.request(
            "initialize",
            {
                "protocolVersion": PROTOCOL_VERSION,
                "capabilities": {},
                "clientInfo": {"name": CLIENT_NAME, "version": CLIENT_VERSION},
            },
            retry_stale_session=False,
        )
        self.protocol_version = result.get("protocolVersion", PROTOCOL_VERSION)
        self.server_info = result.get("serverInfo", {})
        self.notify("notifications/initialized")
        return result

    def ensure_initialized(self) -> None:
        if not self.session_id:
            self.initialize()

    def call_mcp_tool(self, name: str, arguments: dict[str, Any] | None = None) -> Any:
        self.ensure_initialized()
        result = self.request(
            "tools/call", {"name": name, "arguments": arguments or {}}
        )
        if result.get("isError"):
            raise McpError(extract_text(result))
        return result

    def call_unreal_tool(
        self,
        tool_name: str,
        arguments: dict[str, Any] | None = None,
        toolset_name: str | None = None,
    ) -> Any:
        wrapper_arguments: dict[str, Any] = {
            "tool_name": tool_name,
            "arguments": arguments or {},
        }
        if toolset_name:
            wrapper_arguments["toolset_name"] = toolset_name
        result = self.call_mcp_tool("call_tool", wrapper_arguments)
        return decode_tool_payload(result)


def extract_text(result: dict[str, Any]) -> str:
    return "\n".join(
        item.get("text", "")
        for item in result.get("content", [])
        if item.get("type") == "text"
    )


def decode_tool_payload(result: dict[str, Any]) -> Any:
    raw_text = extract_text(result)
    if not raw_text:
        return result
    try:
        return json.loads(raw_text)
    except json.JSONDecodeError:
        return raw_text


def execute_python(
    client: McpHttpClient,
    code: str,
    saved_dir: str,
    timeout: float = 30.0,
) -> dict[str, Any]:
    command_id = uuid.uuid4().hex
    bridge_dir = saved_dir.rstrip("/\\")
    client.call_unreal_tool(
        "write_file",
        {
            "file_path": bridge_dir + "/cmd.json",
            "content": json.dumps({"id": command_id, "code": code}),
        },
        ASSET_TOOLSET,
    )
    deadline = time.monotonic() + timeout
    last_error = ""
    while time.monotonic() < deadline:
        try:
            response = client.call_unreal_tool(
                "read_file",
                {"file_path": bridge_dir + "/out.json"},
                ASSET_TOOLSET,
            )
            raw_result = (
                response.get("returnValue") if isinstance(response, dict) else response
            )
            bridge_result = json.loads(raw_result)
            if bridge_result.get("id") == command_id:
                return bridge_result
        except (McpError, TypeError, json.JSONDecodeError) as error:
            last_error = str(error)
        time.sleep(0.5)
    detail = f" Last read error: {last_error}" if last_error else ""
    raise McpError(
        "Python bridge timed out. Confirm Content/Python/init_unreal.py loaded at "
        f"editor startup.{detail}"
    )


_default_client: McpHttpClient | None = None
_default_repo_root: Path | None = None
_default_saved_dir: str | None = None


def configure(
    *,
    url: str | None = None,
    saved_dir: str | None = None,
    timeout: float = 30.0,
) -> McpHttpClient:
    """Configure the module-level compatibility helpers and return their client."""
    global _default_client, _default_repo_root, _default_saved_dir
    _default_repo_root = find_repo_root(Path(__file__))
    _default_saved_dir = resolve_saved_dir(_default_repo_root, saved_dir)
    _default_client = McpHttpClient(resolve_url(_default_repo_root, url), timeout)
    return _default_client


def _client() -> McpHttpClient:
    return _default_client or configure()


def call(name: str, args: dict[str, Any] | None = None, toolset: str | None = None) -> Any:
    """Invoke an Unreal tool and return its decoded payload."""
    return _client().call_unreal_tool(name, args, toolset)


def text(response: Any) -> str:
    """Return a stable text form for old scripts that used ``text(call(...))``."""
    if isinstance(response, str):
        return response
    return json.dumps(response, separators=(",", ":"), default=str)


def describe(toolset: str) -> str:
    result = _client().call_mcp_tool(
        "describe_toolset", {"toolset_name": toolset}
    )
    return extract_text(result)


def pyexec(code: str, timeout: float = 30.0) -> dict[str, Any]:
    global _default_saved_dir
    active_client = _client()
    if _default_saved_dir is None:
        repo_root = _default_repo_root or find_repo_root(Path(__file__))
        _default_saved_dir = resolve_saved_dir(repo_root)
    return execute_python(active_client, code, _default_saved_dir, timeout)


def bridge_ping() -> dict[str, Any]:
    return pyexec(
        "output = {"
        "'alive': True, "
        "'ue': unreal.SystemLibrary.get_engine_version(), "
        "'enum_lib': hasattr(unreal, 'PythonEnumLib'), "
        "'struct_lib': hasattr(unreal, 'PythonStructLib')"
        "}",
        timeout=15.0,
    )


def parse_json_object(value: str) -> dict[str, Any]:
    parsed = json.loads(value)
    if not isinstance(parsed, dict):
        raise argparse.ArgumentTypeError("arguments must decode to a JSON object")
    return parsed


def parse_key_value(value: str) -> tuple[str, Any]:
    if "=" not in value:
        raise argparse.ArgumentTypeError("--arg must use key=value")
    key, raw_value = value.split("=", 1)
    if not key:
        raise argparse.ArgumentTypeError("--arg key cannot be empty")
    try:
        parsed_value = json.loads(raw_value)
    except json.JSONDecodeError:
        parsed_value = raw_value
    return key, parsed_value


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", help="MCP URL; overrides config and environment")
    parser.add_argument(
        "--saved-dir", help="Editor host's <Project>/Saved/rtapy directory"
    )
    parser.add_argument("--timeout", type=float, default=30.0)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("status", help="Initialize and show server/config details")
    commands.add_parser("toolsets", help="List available Unreal toolsets")

    describe_parser = commands.add_parser("describe", help="Describe one toolset")
    describe_parser.add_argument("toolset")

    call_parser = commands.add_parser("call", help="Call an Unreal MCP tool")
    call_parser.add_argument("tool_name")
    call_parser.add_argument("--toolset")
    call_parser.add_argument("--arguments", type=parse_json_object, default={})
    call_parser.add_argument(
        "--arg",
        action="append",
        type=parse_key_value,
        default=[],
        help="PowerShell-friendly key=value argument; may be repeated",
    )

    commands.add_parser("ping", help="Ping Unreal through the Python bridge")
    pyexec_parser = commands.add_parser(
        "pyexec", help="Execute trusted editor Python through the bridge"
    )
    source = pyexec_parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--code")
    source.add_argument("--file", type=Path)
    source.add_argument("--stdin", action="store_true")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    repo_root = find_repo_root(Path(__file__))
    url = resolve_url(repo_root, args.url)
    saved_dir = resolve_saved_dir(repo_root, args.saved_dir)
    client = McpHttpClient(url, args.timeout)
    initialized = client.initialize()

    if args.command == "status":
        output = {
            "url": url,
            "saved_dir": saved_dir,
            "session_id": client.session_id,
            "protocol_version": client.protocol_version,
            "server": initialized,
        }
    elif args.command == "toolsets":
        output = decode_tool_payload(client.call_mcp_tool("list_toolsets"))
    elif args.command == "describe":
        output = extract_text(
            client.call_mcp_tool(
                "describe_toolset", {"toolset_name": args.toolset}
            )
        )
    elif args.command == "call":
        arguments = dict(args.arguments)
        arguments.update(args.arg)
        output = client.call_unreal_tool(args.tool_name, arguments, args.toolset)
    elif args.command == "ping":
        output = execute_python(client, bridge_ping_code(), saved_dir, 15.0)
    elif args.command == "pyexec":
        if args.file:
            source_code = args.file.read_text(encoding="utf-8")
        elif args.stdin:
            source_code = sys.stdin.read()
        else:
            source_code = args.code
        output = execute_python(client, source_code, saved_dir, args.timeout)
    else:  # pragma: no cover
        raise McpError(f"Unsupported command: {args.command}")

    print(json.dumps(output, indent=2, default=str))
    return 0


def bridge_ping_code() -> str:
    return (
        "output = {"
        "'alive': True, "
        "'ue': unreal.SystemLibrary.get_engine_version(), "
        "'enum_lib': hasattr(unreal, 'PythonEnumLib'), "
        "'struct_lib': hasattr(unreal, 'PythonStructLib')"
        "}"
    )


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (McpError, OSError, json.JSONDecodeError) as error:
        print(f"error: {error}", file=sys.stderr)
        raise SystemExit(1)
