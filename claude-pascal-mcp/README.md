# Claude Pascal MCP Server

An MCP (Model Context Protocol) server that lets Claude compile, run, and interact with Pascal/Delphi desktop applications. Automatically detects any installed Pascal compiler — Free Pascal, Delphi, or RAD Studio.

## Features

- **Compiler Detection** — automatically finds Pascal compilers on your system (PATH + known install locations for Borland, CodeGear, and Embarcadero eras)
- **Compile** — compile single-file Pascal source or multi-file Delphi projects (VCL and FMX)
- **Run** — compile and execute console programs, capturing output (supports stdin for ReadLn)
- **Launch GUI Apps** — compile and launch VCL/FMX applications in background
- **Project Templates** — generate proper project structure automatically (DPR + PAS + DFM/FMX)
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
| `compile_delphi_project` | Compile Delphi/FPC project from templates (VCL, FMX, console, FPC) |
| `run_pascal` | Compile and execute console programs (supports stdin input) |
| `launch_app` | Compile and launch GUI app in background |
| `check_syntax` | Syntax check only (no linking) |
| `parse_form` | Parse DFM/FMX/LFM form files |
| `screenshot_app` | Capture screenshot of a running app window |
| `list_app_windows` | List visible windows on the desktop |
| `setup_fpc` | Download and install Free Pascal (fallback) |

## Project Templates

The `compile_delphi_project` tool generates proper project structure automatically. You specify components and events, and it creates the correct files.

Supported project types: `vcl`, `fmx`, `console`, `fpc`

### VCL Example

```
compile_delphi_project(
  project_name="HelloVCL",
  form_caption="Hello App",
  project_type="vcl",
  components='[
    {"type": "TEdit", "name": "edtName", "text": "",
     "left": 20, "top": 20, "width": 200, "height": 21},
    {"type": "TButton", "name": "btnHello", "caption": "Say Hello",
     "left": 20, "top": 50, "width": 100, "height": 30,
     "event": "btnHelloClick"}
  ]',
  events='[{"name": "btnHelloClick",
            "body": "ShowMessage(''Hello '' + edtName.Text + ''!'');"}]'
)
```

Generates: `HelloVCL.dpr`, `uMain.pas`, `uMain.dfm`

### FMX (FireMonkey) Example

```
compile_delphi_project(
  project_name="HelloFMX",
  form_caption="Hello FMX App",
  project_type="fmx",
  components='[
    {"type": "TEdit", "name": "edtName", "text": "",
     "left": 20, "top": 20, "width": 200, "height": 22},
    {"type": "TButton", "name": "btnHello", "caption": "Say Hello",
     "left": 20, "top": 55, "width": 100, "height": 30,
     "event": "btnHelloClick"}
  ]',
  events='[{"name": "btnHelloClick",
            "body": "ShowMessage(''Hello '' + edtName.Text + ''!'');"}]'
)
```

Generates: `HelloFMX.dpr`, `uMain.pas`, `uMain.fmx`

### Console Example (with ReadLn input)

```
compile_delphi_project(
  project_name="Greeter",
  project_type="console",
  var_declarations="  Name: string;",
  program_body="    Write('Enter your name: ');\n    ReadLn(Name);\n    WriteLn('Hello ' + Name + '!');"
)
```

Generates a standard Delphi console project with `{$APPTYPE CONSOLE}`, `{$R *.res}`, and proper `var` section — matching IDE-generated code.

You can also run console apps directly with stdin input:

```
run_pascal(
  source_code="program Greeter;\nvar Name: string;\nbegin\n  Write('Enter: ');\n  ReadLn(Name);\n  WriteLn('Hello ' + Name + '!');\nend.",
  stdin_input="World"
)
```

## Resource Files

FMX and console projects include `{$R *.res}` which requires a `.res` file at compile time. The server handles this automatically:

1. If `.rc` files are present and `brcc32` is available, they are compiled to `.res` (for custom icons, version info, etc.)
2. Otherwise, a minimal `.res` is generated directly — no external resource compiler needed

This means FMX projects compile out of the box without requiring `brcc32` or any manual resource setup.

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

## Installation

### Prerequisites

- Python 3.11+
- [uv](https://docs.astral.sh/uv/) package manager
- A Pascal compiler (Free Pascal, Delphi, or RAD Studio)

### Install as Claude Code Plugin (Recommended)

This server includes a `.claude-plugin/marketplace.json` and can be installed directly as a Claude Code plugin:

```bash
# From within Claude Code, add the plugin marketplace
/plugin marketplace add /path/to/claude-pascal-mcp

# Then install the plugin
/plugin install pascal-dev
```

### Alternative: Manual MCP Registration

```bash
claude mcp add --transport stdio pascal-dev -- uv run --directory /path/to/claude-pascal-mcp pascal-mcp
```

### Claude Desktop

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

The server automatically detects any installed Pascal compiler on your system. It searches the system PATH and common installation directories across all eras:

- **Free Pascal (fpc)** — open source, cross-platform
- **Delphi (dcc32/dcc64)** — Borland, CodeGear, and Embarcadero versions

You can also specify a full path to any compiler executable:
```
compile_pascal(source, compiler="C:\\Path\\To\\dcc64.exe")
```

## Examples

The `examples/` directory contains working sample projects:

- **HelloWorld** — Simple VCL console application
- **HelloFMX** — FMX (FireMonkey) GUI app with edit box and button

These can be opened directly in the Delphi IDE or compiled from the command line.

## License

MIT
