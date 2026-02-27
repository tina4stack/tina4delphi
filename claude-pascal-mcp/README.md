# Claude Pascal MCP Server

An MCP (Model Context Protocol) server that lets Claude compile and run Pascal, Delphi, and Lazarus code. Supports Free Pascal (fpc), Delphi 32-bit (dcc32), and Delphi 64-bit (dcc64) compilers.

## Features

- **Compiler Detection** — automatically finds Pascal compilers on your system
- **Compile** — compile Pascal source code and get compiler output/errors
- **Run** — compile and execute code, capturing program output
- **Syntax Check** — fast syntax-only validation without linking
- **FPC Installer** — download and install Free Pascal if no compiler is available

## Tools

| Tool | Description |
|------|-------------|
| `get_compiler_info` | Detect available compilers and show versions |
| `compile_pascal` | Compile source code, return errors/warnings |
| `run_pascal` | Compile and execute, return program output |
| `check_syntax` | Syntax check only (no linking) |
| `setup_fpc` | Download and install Free Pascal (fallback) |

## Installation

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) package manager

### Quick Start

```bash
# Clone the repository
git clone https://github.com/niclasborgworx/claude-pascal-mcp.git
cd claude-pascal-mcp

# Install dependencies
uv sync

# Run the server (stdio mode)
uv run pascal-mcp
```

### Register with Claude Code

```bash
claude mcp add --transport stdio pascal-dev -- uv run --directory /path/to/claude-pascal-mcp pascal-mcp
```

Or add to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "pascal-dev": {
      "command": "uv",
      "args": ["run", "--directory", "/path/to/claude-pascal-mcp", "pascal-mcp"]
    }
  }
}
```

### Register with Claude Desktop

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "pascal-dev": {
      "command": "uv",
      "args": ["run", "--directory", "C:/path/to/claude-pascal-mcp", "pascal-mcp"]
    }
  }
}
```

## Supported Compilers

The server automatically detects compilers in this priority order:

1. **Free Pascal (fpc)** — open source, cross-platform
2. **Delphi 64-bit (dcc64)** — RAD Studio command-line compiler
3. **Delphi 32-bit (dcc32)** — RAD Studio command-line compiler

Detection checks the system PATH first, then known installation directories:

- `C:\FPC\*\bin\*\fpc.exe`
- `C:\Lazarus\fpc\*\bin\*\fpc.exe`
- `C:\Program Files (x86)\Embarcadero\Studio\*\bin\dcc*.exe`

## Usage Examples

Once registered, Claude can use the tools directly:

> "Compile this Pascal code and tell me if there are any errors"

> "Run this program and show me the output"

> "Check if Free Pascal is installed on my system"

## License

MIT
