# Delphi MCP installation

The required server is [`tina4stack/claude-pascal-mcp`](https://github.com/tina4stack/claude-pascal-mcp), exposed to the agent as `pascal-dev`.

## Prerequisites

- Windows with RAD Studio/Delphi
- Python 3.11 or newer
- [`uv`](https://docs.astral.sh/uv/)

## Codex

Add this to the user Codex configuration and restart Codex:

```toml
[mcp_servers.pascal-dev]
command = "uvx"
args = ["--from", "git+https://github.com/tina4stack/claude-pascal-mcp", "pascal-mcp"]
```

For a local development clone:

```toml
[mcp_servers.pascal-dev]
command = "uv"
args = ["run", "--directory", "C:/path/to/claude-pascal-mcp", "pascal-mcp"]
```

## Claude Code

```bash
claude mcp add --transport stdio pascal-dev -- uvx --from git+https://github.com/tina4stack/claude-pascal-mcp pascal-mcp
```

## Cursor

Add this to `~/.cursor/mcp.json`, or to `.cursor/mcp.json` inside a project:

```json
{
  "mcpServers": {
    "pascal-dev": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--from", "git+https://github.com/tina4stack/claude-pascal-mcp", "pascal-mcp"]
    }
  }
}
```

## Project `.mcp.json` or Claude Desktop

```json
{
  "mcpServers": {
    "pascal-dev": {
      "command": "uvx",
      "args": ["--from", "git+https://github.com/tina4stack/claude-pascal-mcp", "pascal-mcp"]
    }
  }
}
```

Restart the host after registration, then call `mcp__pascal_dev__get_compiler_info`. The maintainer workflow remains read-only until the server responds and a supported compiler is listed.
