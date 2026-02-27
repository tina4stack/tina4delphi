"""Claude Pascal MCP Server.

Exposes Pascal/Delphi compilation and execution tools via the
Model Context Protocol (MCP) for use with Claude.
"""

from mcp.server.fastmcp import FastMCP

from pascal_mcp.compiler import (
    cleanup_compile_result,
    compile_source,
    detect_compilers,
    run_source,
)
from pascal_mcp.form_parser import (
    format_component_list,
    format_summary,
    format_tree,
    parse_form_file,
)
from pascal_mcp.installer import download_and_install_fpc

mcp = FastMCP(
    "pascal-dev",
    instructions=(
        "Pascal/Delphi development tools. Use get_compiler_info to check "
        "available compilers. Use compile_pascal to compile code and see "
        "errors. Use run_pascal to compile and execute code. If no compiler "
        "is found, use setup_fpc to install Free Pascal. Use parse_form to "
        "read and understand DFM/FMX/LFM form files."
    ),
)


@mcp.tool()
async def get_compiler_info() -> str:
    """Detect available Pascal compilers and return their details.

    Checks for Free Pascal (fpc), Delphi 32-bit (dcc32), and Delphi 64-bit (dcc64)
    on the system PATH and in common installation directories.

    Returns a summary of all compilers found with name, version, and path.
    """
    compilers = detect_compilers()

    if not compilers:
        return (
            "No Pascal compilers found on this system.\n\n"
            "Available options:\n"
            "  - Use the setup_fpc tool to download and install Free Pascal\n"
            "  - Install Lazarus IDE (includes FPC): https://www.lazarus-ide.org\n"
            "  - Install RAD Studio: https://www.embarcadero.com/products/rad-studio"
        )

    lines = [f"Found {len(compilers)} Pascal compiler(s):\n"]
    for c in compilers:
        lines.append(f"  [{c.compiler_type}] {c.name}")
        lines.append(f"    Version: {c.version}")
        lines.append(f"    Path:    {c.path}")
        lines.append("")

    return "\n".join(lines)


@mcp.tool()
async def compile_pascal(
    source_code: str,
    compiler: str | None = None,
) -> str:
    """Compile Pascal source code and return compiler output.

    Use this to check if code compiles without running it. Returns compiler
    messages including any errors or warnings.

    Args:
        source_code: The complete Pascal source code to compile. Should include
            the program/unit header (e.g., 'program Hello;').
        compiler: Which compiler to use: 'fpc', 'dcc32', or 'dcc64'.
            If not specified, auto-selects the best available compiler.
    """
    result = compile_source(source_code, compiler_type=compiler)

    parts = [f"Compiler: {result.compiler_used}"]
    parts.append(f"Success: {result.success}")
    parts.append(f"Exit code: {result.exit_code}")

    if result.stdout.strip():
        parts.append(f"\n--- Compiler Output ---\n{result.stdout.strip()}")
    if result.stderr.strip():
        parts.append(f"\n--- Compiler Messages ---\n{result.stderr.strip()}")

    # Clean up temp files
    cleanup_compile_result(result)

    return "\n".join(parts)


@mcp.tool()
async def run_pascal(
    source_code: str,
    compiler: str | None = None,
    stdin_input: str = "",
) -> str:
    """Compile and execute Pascal source code, returning the program output.

    Compiles the source code, runs the resulting executable, and returns
    both compilation messages and program output (stdout/stderr).

    Args:
        source_code: The complete Pascal source code to compile and run.
            Should be a program (not a unit) with a begin..end block.
        compiler: Which compiler to use: 'fpc', 'dcc32', or 'dcc64'.
            If not specified, auto-selects the best available compiler.
        stdin_input: Optional text input to send to the program's stdin.
            Useful for programs that read from input.
    """
    result = run_source(
        source_code,
        compiler_type=compiler,
        stdin_input=stdin_input,
    )

    parts = [f"Compiler: {result.compiler_used}"]
    parts.append(f"Success: {result.success}")
    parts.append(f"Exit code: {result.exit_code}")

    if result.stdout.strip():
        parts.append(f"\n{result.stdout.strip()}")
    if result.stderr.strip():
        parts.append(f"\n--- Errors ---\n{result.stderr.strip()}")

    return "\n".join(parts)


@mcp.tool()
async def check_syntax(
    source_code: str,
    compiler: str | None = None,
) -> str:
    """Check Pascal syntax without producing an executable.

    Performs a syntax-only check (no linking). Faster than a full compile
    and useful for quickly validating code structure.

    Args:
        source_code: The Pascal source code to check.
        compiler: Which compiler to use: 'fpc', 'dcc32', or 'dcc64'.
            If not specified, auto-selects the best available compiler.
    """
    result = compile_source(source_code, compiler_type=compiler, syntax_only=True)

    parts = [f"Compiler: {result.compiler_used}"]

    if result.success:
        parts.append("Syntax check: PASSED")
    else:
        parts.append("Syntax check: FAILED")

    if result.stdout.strip():
        parts.append(f"\n{result.stdout.strip()}")
    if result.stderr.strip():
        parts.append(f"\n{result.stderr.strip()}")

    # Clean up temp files
    cleanup_compile_result(result)

    return "\n".join(parts)


@mcp.tool()
async def parse_form(
    file_path: str,
    output_format: str = "tree",
) -> str:
    """Parse a Delphi/Lazarus form file and return its component structure.

    Reads .dfm (VCL), .fmx (FireMonkey), or .lfm (Lazarus) form files
    and returns a structured view of all components, their properties,
    positions, sizes, and event handlers.

    Args:
        file_path: Absolute path to the .dfm, .fmx, or .lfm file.
        output_format: How to format the output:
            - 'tree': Indented component tree with key properties (default)
            - 'summary': High-level overview with component counts and events
            - 'flat': Flat list of all components with position/size info
    """
    try:
        root = parse_form_file(file_path)
    except ValueError as e:
        return str(e)

    if root is None:
        return f"Could not parse form file: {file_path}"

    if output_format == "summary":
        return format_summary(root)
    elif output_format == "flat":
        return format_component_list(root)
    else:
        return format_tree(root)


@mcp.tool()
async def setup_fpc(
    install_dir: str = r"C:\FPC\3.2.2",
) -> str:
    """Download and install Free Pascal Compiler (FPC).

    Only use this when no Pascal compiler is available on the system.
    Downloads FPC 3.2.2 from the official SourceForge mirror and performs
    a silent installation. May require administrator privileges.

    Args:
        install_dir: Where to install FPC. Defaults to C:\\FPC\\3.2.2.
            Avoid paths with spaces.
    """
    result = await download_and_install_fpc(install_dir)

    parts = [f"Status: {result['status']}"]
    parts.append(result["message"])

    if "version" in result:
        parts.append(f"Version: {result['version']}")
    if "path" in result:
        parts.append(f"Path: {result['path']}")

    return "\n".join(parts)


def main():
    """Entry point for the MCP server."""
    mcp.run(transport="stdio")


if __name__ == "__main__":
    main()
