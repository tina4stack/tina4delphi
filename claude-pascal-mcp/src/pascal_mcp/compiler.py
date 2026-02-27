"""Pascal compiler detection, compilation, and execution."""

import glob
import os
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path


@dataclass
class CompilerInfo:
    """Information about a detected Pascal compiler."""
    name: str
    path: str
    version: str
    compiler_type: str  # "fpc", "dcc32", "dcc64"


@dataclass
class CompileResult:
    """Result of a compilation or execution."""
    success: bool
    exit_code: int
    stdout: str
    stderr: str
    compiler_used: str
    exe_path: str | None = None


# Known installation locations on Windows
KNOWN_FPC_LOCATIONS = [
    r"C:\FPC\*\bin\x86_64-win64\fpc.exe",
    r"C:\FPC\*\bin\i386-win32\fpc.exe",
    r"C:\Lazarus\fpc\*\bin\x86_64-win64\fpc.exe",
    r"C:\Lazarus\fpc\*\bin\i386-win32\fpc.exe",
]

KNOWN_DCC_LOCATIONS = [
    r"C:\Program Files (x86)\Embarcadero\Studio\*\bin\dcc64.exe",
    r"C:\Program Files (x86)\Embarcadero\Studio\*\bin\dcc32.EXE",
]


def _find_in_known_locations(patterns: list[str]) -> list[str]:
    """Search known installation paths using glob patterns."""
    found = []
    for pattern in patterns:
        matches = glob.glob(pattern)
        found.extend(matches)
    return found


def _get_fpc_version(fpc_path: str) -> str:
    """Get FPC version string."""
    try:
        result = subprocess.run(
            [fpc_path, "-iV"],
            capture_output=True, text=True, timeout=10
        )
        return result.stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError):
        return "unknown"


def _get_dcc_version(dcc_path: str) -> str:
    """Get DCC version string from its output."""
    try:
        result = subprocess.run(
            [dcc_path, "--version"],
            capture_output=True, text=True, timeout=10
        )
        output = result.stdout + result.stderr
        # DCC prints version info on first line of stderr typically
        for line in output.splitlines():
            if "Embarcadero" in line or "Borland" in line or "CodeGear" in line:
                return line.strip()
            if "Delphi" in line or "dcc" in line.lower():
                return line.strip()
        # Fallback: return first non-empty line
        for line in output.splitlines():
            stripped = line.strip()
            if stripped:
                return stripped
        return "installed"
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError):
        return "unknown"


def detect_compilers() -> list[CompilerInfo]:
    """Detect all available Pascal compilers on the system.

    Checks PATH first, then known installation locations.
    Returns a list of CompilerInfo for each compiler found.
    """
    compilers: list[CompilerInfo] = []
    seen_paths: set[str] = set()

    def _norm(p: str) -> str:
        return os.path.normcase(os.path.abspath(p))

    # Check PATH for fpc
    fpc_path = shutil.which("fpc")
    if fpc_path:
        key = _norm(fpc_path)
        if key not in seen_paths:
            seen_paths.add(key)
            fpc_path = os.path.abspath(fpc_path)
            version = _get_fpc_version(fpc_path)
            compilers.append(CompilerInfo(
                name="Free Pascal Compiler",
                path=fpc_path,
                version=version,
                compiler_type="fpc",
            ))

    # Check PATH for dcc32 and dcc64
    for compiler_type in ("dcc64", "dcc32"):
        dcc_path = shutil.which(compiler_type)
        if dcc_path:
            key = _norm(dcc_path)
            if key not in seen_paths:
                seen_paths.add(key)
                dcc_path = os.path.abspath(dcc_path)
                version = _get_dcc_version(dcc_path)
                name = "Delphi 64-bit" if "64" in compiler_type else "Delphi 32-bit"
                compilers.append(CompilerInfo(
                    name=f"{name} Compiler",
                    path=dcc_path,
                    version=version,
                    compiler_type=compiler_type,
                ))

    # Check known FPC locations
    if sys.platform == "win32":
        for fpc_path in _find_in_known_locations(KNOWN_FPC_LOCATIONS):
            key = _norm(fpc_path)
            if key not in seen_paths:
                seen_paths.add(key)
                fpc_path = os.path.abspath(fpc_path)
                version = _get_fpc_version(fpc_path)
                compilers.append(CompilerInfo(
                    name="Free Pascal Compiler",
                    path=fpc_path,
                    version=version,
                    compiler_type="fpc",
                ))

        # Check known DCC locations
        for dcc_path in _find_in_known_locations(KNOWN_DCC_LOCATIONS):
            key = _norm(dcc_path)
            if key not in seen_paths:
                seen_paths.add(key)
                version = _get_dcc_version(dcc_path)
                compiler_type = "dcc64" if "dcc64" in dcc_path.lower() else "dcc32"
                name = "Delphi 64-bit" if "64" in compiler_type else "Delphi 32-bit"
                compilers.append(CompilerInfo(
                    name=f"{name} Compiler",
                    path=dcc_path,
                    version=version,
                    compiler_type=compiler_type,
                ))

    return compilers


def _select_compiler(
    compilers: list[CompilerInfo],
    preferred: str | None = None,
) -> CompilerInfo | None:
    """Select a compiler from the available ones.

    Args:
        compilers: List of detected compilers.
        preferred: Optional preferred compiler type (fpc, dcc32, dcc64).

    Returns:
        The selected CompilerInfo, or None if no compiler is available.
    """
    if not compilers:
        return None

    if preferred:
        for c in compilers:
            if c.compiler_type == preferred:
                return c

    # Default priority: fpc > dcc64 > dcc32
    priority = {"fpc": 0, "dcc64": 1, "dcc32": 2}
    return min(compilers, key=lambda c: priority.get(c.compiler_type, 99))


def _find_dcc_lib_paths(compiler: CompilerInfo) -> list[str]:
    """Find Delphi RTL/VCL library paths for the given DCC compiler.

    Derives the library search paths from the compiler's install location.
    For dcc64, uses win64/release; for dcc32, uses win32/release.
    """
    # Derive Studio root from compiler path
    # e.g., C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\dcc64.exe
    #     -> C:\Program Files (x86)\Embarcadero\Studio\37.0
    compiler_dir = os.path.dirname(compiler.path)  # .../bin or .../bin64
    studio_root = os.path.dirname(compiler_dir)

    if compiler.compiler_type == "dcc64":
        platform = "win64"
    else:
        platform = "win32"

    lib_paths = []
    lib_base = os.path.join(studio_root, "lib", platform)

    # Add release path (primary) and debug path (fallback)
    for variant in ("release", "debug"):
        path = os.path.join(lib_base, variant)
        if os.path.isdir(path):
            lib_paths.append(path)

    return lib_paths


def _build_compile_args(
    compiler: CompilerInfo,
    source_path: str,
    output_dir: str,
    syntax_only: bool = False,
) -> list[str]:
    """Build the compiler command-line arguments."""
    args = [compiler.path]

    if compiler.compiler_type == "fpc":
        if syntax_only:
            args.append("-s")
        args.extend([
            f"-FE{output_dir}",  # output directory for exe
            f"-FU{output_dir}",  # output directory for units
            source_path,
        ])
    elif compiler.compiler_type in ("dcc32", "dcc64"):
        if syntax_only:
            args.append("-Q")

        # Add RTL/VCL unit search paths
        lib_paths = _find_dcc_lib_paths(compiler)
        for lib_path in lib_paths:
            args.append(f"-U{lib_path}")

        args.extend([
            f"-E{output_dir}",  # exe output directory
            f"-N{output_dir}",  # unit output directory
            "-CC",  # console application
            "-NSSystem;System.Win;Winapi",  # namespace search
            source_path,
        ])

    return args


def compile_source(
    source_code: str,
    compiler_type: str | None = None,
    syntax_only: bool = False,
) -> CompileResult:
    """Compile Pascal source code.

    Args:
        source_code: The Pascal source to compile.
        compiler_type: Preferred compiler (fpc, dcc32, dcc64). Auto-detects if None.
        syntax_only: If True, only check syntax without linking.

    Returns:
        CompileResult with compilation output.
    """
    compilers = detect_compilers()
    compiler = _select_compiler(compilers, compiler_type)

    if not compiler:
        return CompileResult(
            success=False,
            exit_code=-1,
            stdout="",
            stderr="No Pascal compiler found. Use the setup_fpc tool to install Free Pascal.",
            compiler_used="none",
        )

    # Create a temp directory for this compilation
    work_dir = tempfile.mkdtemp(prefix="pascal_mcp_")

    try:
        # Write source to temp file
        source_path = os.path.join(work_dir, "source.pas")
        with open(source_path, "w", encoding="utf-8") as f:
            f.write(source_code)

        # Build compiler command
        args = _build_compile_args(compiler, source_path, work_dir, syntax_only)

        # Run compiler
        result = subprocess.run(
            args,
            capture_output=True,
            text=True,
            timeout=30,
            cwd=work_dir,
        )

        # Find the compiled executable
        exe_path = None
        if not syntax_only and result.returncode == 0:
            if sys.platform == "win32":
                candidate = os.path.join(work_dir, "source.exe")
            else:
                candidate = os.path.join(work_dir, "source")
            if os.path.exists(candidate):
                exe_path = candidate

        return CompileResult(
            success=result.returncode == 0,
            exit_code=result.returncode,
            stdout=result.stdout,
            stderr=result.stderr,
            compiler_used=f"{compiler.name} ({compiler.compiler_type}) at {compiler.path}",
            exe_path=exe_path,
        )

    except subprocess.TimeoutExpired:
        return CompileResult(
            success=False,
            exit_code=-1,
            stdout="",
            stderr="Compilation timed out after 30 seconds.",
            compiler_used=f"{compiler.name} ({compiler.compiler_type})",
        )
    except Exception as e:
        return CompileResult(
            success=False,
            exit_code=-1,
            stdout="",
            stderr=f"Compilation error: {e}",
            compiler_used=f"{compiler.name} ({compiler.compiler_type})",
        )


def run_source(
    source_code: str,
    compiler_type: str | None = None,
    stdin_input: str = "",
    run_timeout: int = 10,
) -> CompileResult:
    """Compile and execute Pascal source code.

    Args:
        source_code: The Pascal source to compile and run.
        compiler_type: Preferred compiler (fpc, dcc32, dcc64). Auto-detects if None.
        stdin_input: Optional input to pass to the program's stdin.
        run_timeout: Maximum seconds for program execution (default 10).

    Returns:
        CompileResult with both compilation and execution output.
    """
    # First compile
    compile_result = compile_source(source_code, compiler_type, syntax_only=False)

    if not compile_result.success or not compile_result.exe_path:
        return compile_result

    # Then run
    try:
        run_result = subprocess.run(
            [compile_result.exe_path],
            capture_output=True,
            text=True,
            timeout=run_timeout,
            input=stdin_input if stdin_input else None,
            cwd=os.path.dirname(compile_result.exe_path),
        )

        # Combine compilation and execution output
        compile_output = ""
        if compile_result.stdout.strip():
            compile_output = f"[Compiler Output]\n{compile_result.stdout.strip()}\n\n"

        return CompileResult(
            success=run_result.returncode == 0,
            exit_code=run_result.returncode,
            stdout=f"{compile_output}[Program Output]\n{run_result.stdout}",
            stderr=run_result.stderr,
            compiler_used=compile_result.compiler_used,
            exe_path=compile_result.exe_path,
        )

    except subprocess.TimeoutExpired:
        return CompileResult(
            success=False,
            exit_code=-1,
            stdout=compile_result.stdout,
            stderr=f"Program execution timed out after {run_timeout} seconds.",
            compiler_used=compile_result.compiler_used,
        )
    except Exception as e:
        return CompileResult(
            success=False,
            exit_code=-1,
            stdout=compile_result.stdout,
            stderr=f"Execution error: {e}",
            compiler_used=compile_result.compiler_used,
        )
    finally:
        # Clean up the temp directory
        work_dir = os.path.dirname(compile_result.exe_path)
        try:
            shutil.rmtree(work_dir, ignore_errors=True)
        except Exception:
            pass


def cleanup_compile_result(result: CompileResult) -> None:
    """Clean up temporary files from a compile result."""
    if result.exe_path:
        work_dir = os.path.dirname(result.exe_path)
        try:
            shutil.rmtree(work_dir, ignore_errors=True)
        except Exception:
            pass
