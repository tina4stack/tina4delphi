# Claude Pascal MCP Server

An MCP (Model Context Protocol) server that lets Claude compile, run, and inspect Pascal, Delphi, and Lazarus projects. Supports Free Pascal (fpc), Delphi 32-bit (dcc32), and Delphi 64-bit (dcc64) compilers.

## Features

- **Compiler Detection** — automatically finds Pascal compilers on your system
- **Compile** — compile Pascal source code and get compiler output/errors
- **Run** — compile and execute code, capturing program output
- **Syntax Check** — fast syntax-only validation without linking
- **Form Parser** — parse DFM (VCL), FMX (FireMonkey), and LFM (Lazarus) form files to understand UI structure
- **App Screenshots** — capture screenshots of running application windows for visual inspection
- **Window Listing** — list visible desktop windows to find running applications
- **FPC Installer** — download and install Free Pascal if no compiler is available

## Tools

| Tool | Description |
|------|-------------|
| `get_compiler_info` | Detect available compilers and show versions |
| `compile_pascal` | Compile source code, return errors/warnings |
| `run_pascal` | Compile and execute, return program output |
| `check_syntax` | Syntax check only (no linking) |
| `parse_form` | Parse .dfm/.fmx/.lfm form files into component trees |
| `screenshot_app` | Capture a screenshot of a running application window |
| `list_app_windows` | List visible windows on the desktop |
| `setup_fpc` | Download and install Free Pascal (fallback) |

## Installation

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) package manager

### Quick Start

```bash
# Clone the repository
git clone https://github.com/tina4stack/tina4delphi.git
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

## Form Parser

The `parse_form` tool reads Delphi/Lazarus form files and returns a structured view of the UI. Supports three output formats:

- **tree** (default) — indented component tree with key properties
- **summary** — high-level overview with component counts and event handlers
- **flat** — flat list of all components with position/size info

Supported file types:
- `.dfm` — Delphi VCL forms
- `.fmx` — Delphi FireMonkey forms
- `.lfm` — Lazarus forms

> "Parse the form file MainForm.dfm and show me the component tree"

> "Give me a summary of all event handlers in LoginForm.fmx"

## App Screenshots

The `screenshot_app` and `list_app_windows` tools let Claude visually inspect running applications:

1. Use `list_app_windows` to find the window title
2. Use `screenshot_app` with the title to capture a PNG screenshot

The screenshot is returned as an image that Claude can analyze directly.

> "List all open windows on my desktop"

> "Take a screenshot of my running application"

> "Screenshot the window titled 'Customer Form' and check the layout"

## Usage Examples

Once registered, Claude can use the tools directly:

> "Compile this Pascal code and tell me if there are any errors"

> "Run this program and show me the output"

> "Check if Free Pascal is installed on my system"

> "Parse MainForm.dfm and tell me what components are on the form"

> "Take a screenshot of my running app and check the UI"

## License

MIT
