# Claude Pascal MCP Server

An MCP (Model Context Protocol) server that lets Claude compile, run, and interact with Pascal/Delphi desktop applications. Supports Free Pascal (fpc), Delphi 32-bit (dcc32), and Delphi 64-bit (dcc64) compilers.

## Features

- **Compiler Detection** — automatically finds Pascal compilers on your system (PATH + known install locations)
- **Compile** — compile single-file Pascal source or multi-file Delphi projects
- **Run** — compile and execute console programs, capturing output
- **Launch GUI Apps** — compile and launch VCL/FMX applications in background
- **Project Templates** — generate proper Delphi project structure (DPR + PAS + DFM) automatically
- **Form Parser** — read and understand DFM/FMX/LFM form files
- **Window Screenshots** — capture running desktop app windows (non-intrusive, no focus stealing)
- **Preview Bridge** — live preview of running Pascal apps through Claude's preview system
- **Control Interaction** — click buttons, type text, send keys, move/resize windows
- **FPC Installer** — download and install Free Pascal if no compiler is available

## Tools

| Tool | Description |
|------|-------------|
| `get_compiler_info` | Detect available compilers and show versions |
| `compile_pascal` | Compile single-file source code |
| `compile_delphi_project` | Compile proper Delphi project from templates (DPR + PAS + DFM) |
| `run_pascal` | Compile and execute console programs |
| `launch_app` | Compile and launch GUI app in background |
| `check_syntax` | Syntax check only (no linking) |
| `parse_form` | Parse DFM/FMX/LFM form files |
| `screenshot_app` | Capture screenshot of a running app window |
| `list_app_windows` | List visible windows on the desktop |
| `setup_fpc` | Download and install Free Pascal (fallback) |

## Preview Bridge

The preview bridge lets Claude see and interact with running Pascal desktop applications through its web-based preview system. It serves live screenshots of desktop app windows as a web page.

### How it works

```
Claude Preview Tools (preview_start, preview_screenshot, preview_click)
        | HTTP
        v
Preview Bridge Server (Python/Starlette)
   /               -> HTML page with live screenshot viewer
   /api/screenshot  -> PNG of target window
   /api/controls    -> enumerate child controls with positions
   /api/click       -> click at coordinates or by control hwnd
   /api/type        -> send keystrokes to target window
   /api/move        -> move window to screen position
   /api/resize      -> resize window
        | Win32 PrintWindow API
        v
Running Pascal Desktop Application
```

### API Endpoints

| Route | Method | Description |
|-------|--------|-------------|
| `/` | GET | HTML page with auto-refreshing screenshot viewer |
| `/api/screenshot` | GET | PNG screenshot of target window |
| `/api/windows` | GET | List visible windows |
| `/api/target` | POST | Set target window by title |
| `/api/controls` | GET | Enumerate child controls (buttons, inputs, etc.) |
| `/api/click` | POST | Click by coordinates or direct control hwnd |
| `/api/type` | POST | Send text or key combos (e.g., `ctrl+a`, `enter`) |
| `/api/drag` | POST | Drag from one point to another |
| `/api/move` | POST | Move target window |
| `/api/resize` | POST | Resize target window |
| `/api/window-info` | GET | Window position, size, and client area offset |
| `/api/console` | GET | Console output from launched apps |
| `/api/launch` | POST | Launch an executable |

### Click Methods

The click endpoint supports three modes, from most to least reliable:

1. **Direct control click** (`{"hwnd": "12345"}`) — sends `BM_CLICK` directly to a control handle. Works regardless of DPI, monitors, or foreground state. Get hwnds from `/api/controls`.
2. **Client-area coordinates** (`{"x": 200, "y": 142, "client": true}`) — uses Win32 `ClientToScreen` for proper DPI handling.
3. **Window-relative coordinates** (`{"x": 312, "y": 261}`) — raw coordinates in the screenshot image space.

## Project Templates

The `compile_delphi_project` tool generates proper Delphi project structure automatically. You specify components and events, and it creates the correct DPR, PAS, and DFM files.

Templates automatically handle:
- **Modern Delphi** (RAD Studio): namespaced units (`Vcl.Forms`, `System.SysUtils`)
- **Legacy Delphi** (Delphi 7): non-namespaced units (`Forms`, `SysUtils`)
- Form definitions (DFM) with proper component declarations
- Event handler wiring between DFM and PAS files

### Example

```
compile_delphi_project(
  project_name="HelloWorld",
  form_caption="My App",
  components='[{"type": "TButton", "name": "btnHello", "caption": "Click Me",
                "left": 100, "top": 100, "width": 120, "height": 35,
                "event": "btnHelloClick"}]',
  events='[{"name": "btnHelloClick", "body": "ShowMessage(\'Hello!\');"}]',
  compiler="C:\\Path\\To\\dcc64.exe"
)
```

This generates:
- `HelloWorld.dpr` — project file with proper uses clause
- `uMain.pas` — unit with form class, component declarations, event handlers
- `uMain.dfm` — form definition with component properties

## Installation

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) package manager
- A Pascal compiler (Free Pascal, Delphi, or RAD Studio)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/tina4stack/tina4delphi.git
cd tina4delphi/claude-pascal-mcp

# Install dependencies
uv sync

# Run the MCP server (stdio mode)
uv run pascal-mcp

# Run the preview bridge (HTTP mode)
uv run pascal-preview
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

### Preview Bridge Setup

Add to `.claude/launch.json` in your project root:

```json
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "pascal-preview",
      "runtimeExecutable": "/path/to/claude-pascal-mcp/.venv/Scripts/pythonw.exe",
      "runtimeArgs": ["-m", "pascal_mcp.preview_bridge"],
      "port": 18080,
      "autoPort": true
    }
  ]
}
```

Then in Claude Code, use `preview_start("pascal-preview")` to open the preview panel.

## Supported Compilers

The server automatically detects compilers in this priority order:

1. **Free Pascal (fpc)** — open source, cross-platform
2. **Delphi 64-bit (dcc64)** — RAD Studio command-line compiler
3. **Delphi 32-bit (dcc32)** — RAD Studio / Delphi 7 command-line compiler

You can also specify a full path to any compiler executable:
```
compile_pascal(source, compiler="C:\\Program Files (x86)\\Embarcadero\\Studio\\37.0\\bin\\dcc64.exe")
```

Detection checks the system PATH first, then known installation directories:

- `C:\FPC\*\bin\*\fpc.exe`
- `C:\Lazarus\fpc\*\bin\*\fpc.exe`
- `C:\Program Files (x86)\Embarcadero\Studio\*\bin\dcc*.exe`

## License

MIT
