"""Delphi/Pascal project templates.

Provides embedded templates for creating proper Delphi project structures.
Templates handle the differences between Delphi versions (namespaced vs
non-namespaced units) and project types (VCL GUI, console, FPC).

Usage from MCP tools:
    files = generate_vcl_project("MyApp", "TMainForm", compiler_type="dcc64")
    # Returns dict of {filename: content} ready to write to disk
"""

from __future__ import annotations

# ---------------------------------------------------------------------------
# VCL GUI Application Templates
# ---------------------------------------------------------------------------

# Modern Delphi (RAD Studio / dcc64 / dcc32 with namespaced units)
VCL_DPR_MODERN = """\
program {project_name};

uses
  Vcl.Forms,
  {unit_name} in '{unit_name}.pas' {{{form_name}}};

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm({form_class}, {form_name});
  Application.Run;
end.
"""

VCL_PAS_MODERN = """\
unit {unit_name};

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls;

type
  {form_class} = class(TForm)
{component_declarations}
{event_declarations}
  private
    {{ Private declarations }}
  public
    {{ Public declarations }}
  end;

var
  {form_name}: {form_class};

implementation

{{$R *.dfm}}

{event_implementations}

end.
"""

# Legacy Delphi (Delphi 7 / older dcc32 without namespaced units)
VCL_DPR_LEGACY = """\
program {project_name};

uses
  Forms,
  {unit_name} in '{unit_name}.pas' {{{form_name}}};

begin
  Application.Initialize;
  Application.CreateForm({form_class}, {form_name});
  Application.Run;
end.
"""

VCL_PAS_LEGACY = """\
unit {unit_name};

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  {form_class} = class(TForm)
{component_declarations}
{event_declarations}
  private
    {{ Private declarations }}
  public
    {{ Public declarations }}
  end;

var
  {form_name}: {form_class};

implementation

{{$R *.dfm}}

{event_implementations}

end.
"""

# DFM form template (same for all Delphi versions)
VCL_DFM = """\
object {form_name}: {form_class}
  Left = 0
  Top = 0
  Caption = '{form_caption}'
  ClientHeight = {client_height}
  ClientWidth = {client_width}
  Position = poScreenCenter
{component_definitions}
end
"""

# ---------------------------------------------------------------------------
# Console Application Templates
# ---------------------------------------------------------------------------

CONSOLE_DPR_MODERN = """\
program {project_name};

{{$APPTYPE CONSOLE}}

uses
  System.SysUtils;

begin
  try
{program_body}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
"""

CONSOLE_DPR_LEGACY = """\
program {project_name};

{{$APPTYPE CONSOLE}}

uses
  SysUtils;

begin
  try
{program_body}
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
"""

# ---------------------------------------------------------------------------
# Free Pascal Templates
# ---------------------------------------------------------------------------

FPC_PROGRAM = """\
program {project_name};

{{$mode objfpc}}{{$H+}}

uses
  Classes, SysUtils;

begin
{program_body}
end.
"""

# ---------------------------------------------------------------------------
# Common DFM component snippets
# ---------------------------------------------------------------------------

DFM_BUTTON = """\
  object {name}: TButton
    Left = {left}
    Top = {top}
    Width = {width}
    Height = {height}
    Caption = '{caption}'
    TabOrder = {tab_order}
    OnClick = {event_name}
  end"""

DFM_EDIT = """\
  object {name}: TEdit
    Left = {left}
    Top = {top}
    Width = {width}
    Height = {height}
    TabOrder = {tab_order}
    Text = '{text}'
  end"""

DFM_LABEL = """\
  object {name}: TLabel
    Left = {left}
    Top = {top}
    Width = {width}
    Height = {height}
    Caption = '{caption}'
  end"""

DFM_MEMO = """\
  object {name}: TMemo
    Left = {left}
    Top = {top}
    Width = {width}
    Height = {height}
    TabOrder = {tab_order}
    Lines.Strings = (
      '')
  end"""


# ---------------------------------------------------------------------------
# Template generation helpers
# ---------------------------------------------------------------------------

def _is_legacy_compiler(compiler_type: str | None) -> bool:
    """Check if a compiler type needs legacy (non-namespaced) units.

    Delphi 7 (dcc32 from Borland path) uses non-namespaced units.
    Modern RAD Studio versions use namespaced units (Vcl.*, System.*, etc.).
    """
    if compiler_type is None:
        return False
    ct = compiler_type.lower()
    # If it's a path containing "borland" or "delphi7", it's legacy
    if "borland" in ct or "delphi7" in ct or "delphi 7" in ct:
        return True
    return False


def generate_vcl_project(
    project_name: str = "Project1",
    form_name: str = "Form1",
    form_class: str = "TForm1",
    form_caption: str = "My Application",
    unit_name: str = "uMain",
    client_width: int = 400,
    client_height: int = 300,
    components: list[dict] | None = None,
    events: list[dict] | None = None,
    compiler_type: str | None = None,
) -> dict[str, str]:
    """Generate a complete VCL GUI application project.

    Args:
        project_name: Name for the .dpr file (without extension).
        form_name: Variable name of the main form (e.g. 'Form1').
        form_class: Class name of the main form (e.g. 'TForm1').
        form_caption: Title bar text.
        unit_name: Name for the main unit file (without extension).
        client_width: Form client area width in pixels.
        client_height: Form client area height in pixels.
        components: List of component dicts with keys like:
            {"type": "TButton", "name": "btnOK", "left": 10, "top": 10,
             "width": 75, "height": 25, "caption": "OK", "event": "btnOKClick"}
        events: List of event handler dicts with keys:
            {"name": "btnOKClick", "body": "ShowMessage('OK clicked');"}
        compiler_type: Compiler type/path to determine legacy vs modern units.

    Returns:
        Dict mapping filenames to their content.
    """
    legacy = _is_legacy_compiler(compiler_type)
    components = components or []
    events = events or []

    # Build component declarations for the .pas type block
    comp_decls = []
    for comp in components:
        comp_decls.append(f"    {comp['name']}: {comp['type']};")

    # Build event declarations
    event_decls = []
    for evt in events:
        event_decls.append(f"    procedure {evt['name']}(Sender: TObject);")

    # Build event implementations
    event_impls = []
    for evt in events:
        body = evt.get("body", "  // TODO")
        event_impls.append(
            f"procedure {form_class}.{evt['name']}(Sender: TObject);\n"
            f"begin\n"
            f"  {body}\n"
            f"end;\n"
        )

    # Build DFM component definitions
    dfm_comps = []
    tab_order = 0
    for comp in components:
        ctype = comp["type"]
        if ctype == "TButton":
            dfm_comps.append(DFM_BUTTON.format(
                name=comp["name"],
                left=comp.get("left", 10),
                top=comp.get("top", 10),
                width=comp.get("width", 75),
                height=comp.get("height", 25),
                caption=comp.get("caption", comp["name"]),
                tab_order=tab_order,
                event_name=comp.get("event", f"{comp['name']}Click"),
            ))
            tab_order += 1
        elif ctype == "TEdit":
            dfm_comps.append(DFM_EDIT.format(
                name=comp["name"],
                left=comp.get("left", 10),
                top=comp.get("top", 10),
                width=comp.get("width", 121),
                height=comp.get("height", 21),
                tab_order=tab_order,
                text=comp.get("text", ""),
            ))
            tab_order += 1
        elif ctype == "TLabel":
            dfm_comps.append(DFM_LABEL.format(
                name=comp["name"],
                left=comp.get("left", 10),
                top=comp.get("top", 10),
                width=comp.get("width", 50),
                height=comp.get("height", 13),
                caption=comp.get("caption", comp["name"]),
            ))
        elif ctype == "TMemo":
            dfm_comps.append(DFM_MEMO.format(
                name=comp["name"],
                left=comp.get("left", 10),
                top=comp.get("top", 10),
                width=comp.get("width", 200),
                height=comp.get("height", 100),
                tab_order=tab_order,
            ))
            tab_order += 1

    # Format template variables
    fmt = {
        "project_name": project_name,
        "form_name": form_name,
        "form_class": form_class,
        "form_caption": form_caption,
        "unit_name": unit_name,
        "client_width": client_width,
        "client_height": client_height,
        "component_declarations": "\n".join(comp_decls) if comp_decls else "    { no components }",
        "event_declarations": "\n".join(event_decls) if event_decls else "",
        "event_implementations": "\n".join(event_impls),
        "component_definitions": "\n".join(dfm_comps),
    }

    # Select templates based on compiler version
    dpr_tmpl = VCL_DPR_LEGACY if legacy else VCL_DPR_MODERN
    pas_tmpl = VCL_PAS_LEGACY if legacy else VCL_PAS_MODERN

    return {
        f"{project_name}.dpr": dpr_tmpl.format(**fmt),
        f"{unit_name}.pas": pas_tmpl.format(**fmt),
        f"{unit_name}.dfm": VCL_DFM.format(**fmt),
    }


def generate_console_project(
    project_name: str = "Project1",
    program_body: str = "    Writeln('Hello, World!');",
    compiler_type: str | None = None,
) -> dict[str, str]:
    """Generate a console application project.

    Args:
        project_name: Name for the .dpr file (without extension).
        program_body: The Pascal code to put in the main begin..end block.
            Each line should be indented with 4 spaces.
        compiler_type: Compiler type/path to determine legacy vs modern units.

    Returns:
        Dict mapping filenames to their content.
    """
    legacy = _is_legacy_compiler(compiler_type)
    tmpl = CONSOLE_DPR_LEGACY if legacy else CONSOLE_DPR_MODERN

    return {
        f"{project_name}.dpr": tmpl.format(
            project_name=project_name,
            program_body=program_body,
        ),
    }


def generate_fpc_project(
    project_name: str = "Project1",
    program_body: str = "  Writeln('Hello, World!');",
) -> dict[str, str]:
    """Generate a Free Pascal project.

    Args:
        project_name: Name for the .pas file (without extension).
        program_body: The Pascal code for the main begin..end block.

    Returns:
        Dict mapping filenames to their content.
    """
    return {
        f"{project_name}.pas": FPC_PROGRAM.format(
            project_name=project_name,
            program_body=program_body,
        ),
    }
