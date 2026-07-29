import io
import json
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ue


class ConfigurationTests(unittest.TestCase):
    def test_environment_url_has_priority_over_agent_configs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".mcp.json").write_text(
                json.dumps(
                    {"mcpServers": {"unreal-mcp": {"url": "http://mcp-json/mcp"}}}
                ),
                encoding="utf-8",
            )
            with mock.patch.dict(
                os.environ, {"RISBACKA_MCP_URL": "http://environment/mcp"}, clear=False
            ):
                self.assertEqual(
                    ue.resolve_url(root),
                    "http://environment/mcp",
                )

    def test_shared_mcp_json_precedes_codex_fallback(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".mcp.json").write_text(
                json.dumps(
                    {"mcpServers": {"unreal-mcp": {"url": "http://shared/mcp"}}}
                ),
                encoding="utf-8",
            )
            codex_dir = root / ".codex"
            codex_dir.mkdir()
            (codex_dir / "config.toml").write_text(
                '[mcp_servers.unreal-mcp]\nurl = "http://codex/mcp"\n',
                encoding="utf-8",
            )
            with mock.patch.dict(
                os.environ,
                {
                    "RISBACKA_MCP_URL": "",
                    "RISBACKA_UNREAL_MCP_URL": "",
                },
                clear=False,
            ):
                self.assertEqual(ue.resolve_url(root), "http://shared/mcp")

    def test_agent_neutral_client_config_precedes_agent_configs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            shared_dir = root / "Scripts" / "UnrealMCP"
            shared_dir.mkdir(parents=True)
            (shared_dir / "client.json").write_text(
                json.dumps(
                    {
                        "url": "http://agent-neutral/mcp",
                        "saved_dir": "Game/Saved/rtapy",
                    }
                ),
                encoding="utf-8",
            )
            (root / ".mcp.json").write_text(
                json.dumps(
                    {"mcpServers": {"unreal-mcp": {"url": "http://mcp-json/mcp"}}}
                ),
                encoding="utf-8",
            )
            with mock.patch.dict(
                os.environ,
                {
                    "RISBACKA_MCP_URL": "",
                    "RISBACKA_UNREAL_MCP_URL": "",
                    "RISBACKA_MCP_SAVED": "",
                    "RISBACKA_UNREAL_SAVED_DIR": "",
                },
                clear=False,
            ):
                self.assertEqual(ue.resolve_url(root), "http://agent-neutral/mcp")
                self.assertEqual(
                    ue.resolve_saved_dir(root),
                    (root / "Game" / "Saved" / "rtapy").resolve().as_posix(),
                )

    def test_saved_directory_is_discovered_from_uproject(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            project_dir = root / "Game"
            project_dir.mkdir()
            (project_dir / "Game.uproject").touch()
            with mock.patch.dict(
                os.environ,
                {
                    "RISBACKA_MCP_SAVED": "",
                    "RISBACKA_UNREAL_SAVED_DIR": "",
                },
                clear=False,
            ):
                expected = (project_dir / "Saved" / "rtapy").resolve().as_posix()
                self.assertEqual(ue.resolve_saved_dir(root), expected)


class ProtocolTests(unittest.TestCase):
    def test_sse_reader_returns_first_complete_event_without_waiting_for_eof(self):
        response = io.BytesIO(
            b"event: message\r\n"
            b'data: {"jsonrpc":"2.0","id":7,"result":{"ok":true}}\r\n'
            b"\r\n"
            b"event: ignored\r\n"
        )
        self.assertEqual(
            ue.read_sse_response(response),
            {"jsonrpc": "2.0", "id": 7, "result": {"ok": True}},
        )

    def test_stale_session_404_reinitializes_once(self):
        class FakeClient(ue.McpHttpClient):
            def __init__(self):
                super().__init__("http://127.0.0.1:8000/mcp")
                self.session_id = "stale"
                self.calls = []

            def _post(self, payload):
                self.calls.append(payload["method"])
                if len(self.calls) == 1:
                    raise ue.McpHttpError(404, "unknown session")
                if payload["method"] == "initialize":
                    self.session_id = "fresh"
                    return {
                        "jsonrpc": "2.0",
                        "id": payload["id"],
                        "result": {
                            "protocolVersion": ue.PROTOCOL_VERSION,
                            "serverInfo": {},
                        },
                    }
                if payload["method"] == "notifications/initialized":
                    return None
                return {
                    "jsonrpc": "2.0",
                    "id": payload["id"],
                    "result": {"tools": []},
                }

        client = FakeClient()
        self.assertEqual(client.request("tools/list", {}), {"tools": []})
        self.assertEqual(
            client.calls,
            [
                "tools/list",
                "initialize",
                "notifications/initialized",
                "tools/list",
            ],
        )


class CliParsingTests(unittest.TestCase):
    def test_power_shell_friendly_arguments_parse_json_scalars_and_strings(self):
        self.assertEqual(ue.parse_key_value("recursive=true"), ("recursive", True))
        self.assertEqual(
            ue.parse_key_value("asset_path=/Game/Test"),
            ("asset_path", "/Game/Test"),
        )


if __name__ == "__main__":
    unittest.main()
