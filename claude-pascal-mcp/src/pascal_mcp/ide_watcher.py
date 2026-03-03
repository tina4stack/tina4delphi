"""IDE detection, project discovery, and file change tracking.

Provides tools for Claude to follow along with what the user is doing
in their Delphi/RAD Studio IDE — detecting the active project and file,
tracking file changes, and reading/writing project source files.
"""

from __future__ import annotations

import os
import re
import shutil
import tempfile
from dataclasses import dataclass, field
from pathlib import Path


# ---------------------------------------------------------------------------
# Data classes
# ---------------------------------------------------------------------------

@dataclass
class IDEContext:
    """Information parsed from the IDE window title bar."""
    ide_version: str = ""
    project_name: str = ""
    active_file: str = ""
    state: str = "unknown"  # editing, running, debugging, designing, unknown
    modified: bool = False
    window_title: str = ""


@dataclass
class ProjectInfo:
    """Information about a discovered Delphi project."""
    project_dir: str
    dpr_path: str | None = None
    dproj_path: str | None = None
    source_files: list[str] = field(default_factory=list)


@dataclass
class ChangeReport:
    """Report of file changes since last snapshot."""
    modified: list[str] = field(default_factory=list)
    added: list[str] = field(default_factory=list)
    deleted: list[str] = field(default_factory=list)

    @property
    def has_changes(self) -> bool:
        return bool(self.modified or self.added or self.deleted)


# ---------------------------------------------------------------------------
# Module-level state
# ---------------------------------------------------------------------------

_current_project: ProjectInfo | None = None
_file_tracker: object | None = None  # FileTracker, set at runtime
_known_project_dirs: dict[str, str] = {}  # project_name -> project_dir


# ---------------------------------------------------------------------------
# IDE Title Bar Parser
# ---------------------------------------------------------------------------

# RAD Studio title patterns:
#   "Embarcadero RAD Studio 12.2 Athens - ProjectName - uMain.pas"
#   "Embarcadero RAD Studio 12.2 Athens - ProjectName [Running]"
#   "Delphi 12.2 - ProjectName - uMain.pas [Modified]"
#   "Embarcadero RAD Studio 12.2 Athens - ProjectName"

_IDE_PATTERNS = [
    # Embarcadero RAD Studio with version and codename
    # "Embarcadero RAD Studio 12.2 Athens - ProjectName - uMain.pas [Modified]"
    re.compile(
        r"Embarcadero RAD Studio\s+(?P<version>[\d.]+)\s+\w+"
        r"\s*-\s*(?P<project>[^\-\[\]]+?)"
        r"(?:\s*-\s*(?P<file>[^\[\]]+?))?"
        r"(?:\s*\[(?P<state>[^\]]+)\])?\s*$"
    ),
    # RAD Studio with project first (newer format)
    # "ProjectName - RAD Studio 13 - Project34.dproj"
    re.compile(
        r"(?P<project>[^\-\[\]]+?)"
        r"\s*-\s*RAD Studio\s+(?P<version>[\d.]+)"
        r"(?:\s*-\s*(?P<file>[^\[\]]+?))?"
        r"(?:\s*\[(?P<state>[^\]]+)\])?\s*$"
    ),
    # Delphi with version
    # "Delphi 12.2 - ProjectName - uMain.pas [Modified]"
    re.compile(
        r"Delphi\s+(?P<version>[\d.]+)"
        r"\s*-\s*(?P<project>[^\-\[\]]+?)"
        r"(?:\s*-\s*(?P<file>[^\[\]]+?))?"
        r"(?:\s*\[(?P<state>[^\]]+)\])?\s*$"
    ),
]

_STATE_MAP = {
    "running": "running",
    "debugging": "debugging",
    "modified": "editing",
    "designing": "designing",
}


def parse_ide_title(title: str) -> IDEContext:
    """Parse a RAD Studio / Delphi IDE window title bar.

    Returns an IDEContext with extracted information.
    """
    ctx = IDEContext(window_title=title)

    for pattern in _IDE_PATTERNS:
        m = pattern.match(title)
        if m:
            ctx.ide_version = m.group("version").strip()
            ctx.project_name = m.group("project").strip()
            ctx.active_file = (m.group("file") or "").strip()
            raw_state = (m.group("state") or "").strip().lower()

            if raw_state:
                ctx.state = _STATE_MAP.get(raw_state, raw_state)
                ctx.modified = "modified" in raw_state
            elif ctx.active_file:
                ctx.state = "editing"
            else:
                ctx.state = "unknown"
            break

    return ctx


def detect_ide_window() -> IDEContext | None:
    """Find a running Delphi/RAD Studio IDE window and parse its title.

    Filters out browser tabs and other non-IDE windows that may mention
    'Delphi' or 'Embarcadero' in their titles.

    Returns IDEContext or None if no IDE window is found.
    """
    from pascal_mcp.screenshot import list_windows

    # Patterns that identify actual IDE windows (not browsers/Slack)
    ide_indicators = [
        "RAD Studio",
        "Embarcadero RAD Studio",
    ]
    # Words that indicate this is NOT the IDE (browser, Slack, etc.)
    non_ide_indicators = [
        "Edge", "Chrome", "Firefox", "Brave", "Opera",
        "Slack", "Teams", "Discord",
        " - Personal -", " - Work -",
        "pages -",
    ]

    windows = list_windows()

    # First pass: look for windows with RAD Studio in title
    for w in windows:
        title = w["title"]
        # Skip browser/chat windows
        if any(ni.lower() in title.lower() for ni in non_ide_indicators):
            continue
        for indicator in ide_indicators:
            if indicator.lower() in title.lower():
                ctx = parse_ide_title(title)
                if ctx.project_name:  # Only return if we could parse something useful
                    return ctx

    # Second pass: look for "Delphi" (less specific, higher false positive risk)
    for w in windows:
        title = w["title"]
        if any(ni.lower() in title.lower() for ni in non_ide_indicators):
            continue
        if "delphi" in title.lower():
            ctx = parse_ide_title(title)
            if ctx.project_name:
                return ctx

    return None


# ---------------------------------------------------------------------------
# Project Discovery
# ---------------------------------------------------------------------------

# Extensions to track in projects
TRACKED_EXTENSIONS = {
    ".pas", ".dfm", ".fmx", ".lfm", ".inc", ".dpr", ".dproj",
}

# Directories to skip when scanning projects
SKIP_DIRS = {
    "__history", "__recovery", ".git", "win32", "win64",
    "debug", "release", "dcu", "bin", "obj", ".svn",
    "node_modules", "__pycache__",
}

# Default roots to search for projects
DEFAULT_SEARCH_ROOTS = [
    os.path.expanduser("~/Documents"),
    os.path.expanduser("~/Desktop"),
    r"D:\projects",
    r"C:\projects",
]


def _scan_source_files(project_dir: str) -> list[str]:
    """Scan a project directory for tracked source files.

    Returns relative paths from the project directory.
    """
    files = []
    for root, dirs, filenames in os.walk(project_dir):
        # Skip unwanted directories (modify in-place to prune os.walk)
        dirs[:] = [
            d for d in dirs
            if d.lower() not in SKIP_DIRS
        ]

        for fname in filenames:
            ext = os.path.splitext(fname)[1].lower()
            if ext in TRACKED_EXTENSIONS:
                full_path = os.path.join(root, fname)
                rel_path = os.path.relpath(full_path, project_dir)
                files.append(rel_path)

    return sorted(files)


def find_project(
    project_name: str,
    search_roots: list[str] | None = None,
    project_dir: str | None = None,
) -> ProjectInfo | None:
    """Find a Delphi project by name.

    Searches for {name}.dpr or {name}.dproj in the given search roots
    (or default locations). Caches found directories for instant re-lookup.

    Args:
        project_name: Name of the project (without extension).
        search_roots: Directories to search in. Uses defaults if None.
        project_dir: If provided, use this directory directly instead of searching.

    Returns:
        ProjectInfo or None if not found.
    """
    # Direct directory provided
    if project_dir and os.path.isdir(project_dir):
        return _build_project_info(project_dir, project_name)

    # Check cache first
    if project_name in _known_project_dirs:
        cached_dir = _known_project_dirs[project_name]
        if os.path.isdir(cached_dir):
            return _build_project_info(cached_dir, project_name)
        else:
            del _known_project_dirs[project_name]

    # Search for the project
    roots = search_roots or DEFAULT_SEARCH_ROOTS
    target_dpr = f"{project_name}.dpr"
    target_dproj = f"{project_name}.dproj"

    for root in roots:
        if not os.path.isdir(root):
            continue

        for dirpath, dirs, files in os.walk(root):
            # Limit depth to 4 levels
            depth = dirpath[len(root):].count(os.sep)
            if depth >= 4:
                dirs.clear()
                continue

            # Skip build/temp directories
            dirs[:] = [d for d in dirs if d.lower() not in SKIP_DIRS]

            for fname in files:
                if fname.lower() == target_dpr.lower() or fname.lower() == target_dproj.lower():
                    project_dir = dirpath
                    _known_project_dirs[project_name] = project_dir
                    return _build_project_info(project_dir, project_name)

    return None


def _build_project_info(project_dir: str, project_name: str) -> ProjectInfo:
    """Build a ProjectInfo from a project directory."""
    dpr_path = None
    dproj_path = None

    for fname in os.listdir(project_dir):
        name_lower = fname.lower()
        if name_lower == f"{project_name.lower()}.dpr":
            dpr_path = os.path.join(project_dir, fname)
        elif name_lower == f"{project_name.lower()}.dproj":
            dproj_path = os.path.join(project_dir, fname)

    # If exact name not found, look for any .dpr/.dproj
    if not dpr_path:
        for fname in os.listdir(project_dir):
            if fname.lower().endswith(".dpr"):
                dpr_path = os.path.join(project_dir, fname)
                break
    if not dproj_path:
        for fname in os.listdir(project_dir):
            if fname.lower().endswith(".dproj"):
                dproj_path = os.path.join(project_dir, fname)
                break

    source_files = _scan_source_files(project_dir)

    return ProjectInfo(
        project_dir=project_dir,
        dpr_path=dpr_path,
        dproj_path=dproj_path,
        source_files=source_files,
    )


# ---------------------------------------------------------------------------
# File Change Tracker
# ---------------------------------------------------------------------------

class FileTracker:
    """Track file changes in a project directory using mtime comparison.

    Usage:
        tracker = FileTracker("/path/to/project")
        tracker.take_snapshot()
        # ... user edits files ...
        changes = tracker.get_changes()  # returns ChangeReport
    """

    def __init__(self, project_dir: str):
        self.project_dir = project_dir
        self._snapshot: dict[str, float] = {}  # rel_path -> mtime

    def take_snapshot(self) -> int:
        """Scan all tracked files and record their modification times.

        Returns the number of files tracked.
        """
        self._snapshot = {}
        for root, dirs, filenames in os.walk(self.project_dir):
            dirs[:] = [d for d in dirs if d.lower() not in SKIP_DIRS]

            for fname in filenames:
                ext = os.path.splitext(fname)[1].lower()
                if ext in TRACKED_EXTENSIONS:
                    full_path = os.path.join(root, fname)
                    rel_path = os.path.relpath(full_path, self.project_dir)
                    try:
                        self._snapshot[rel_path] = os.path.getmtime(full_path)
                    except OSError:
                        pass

        return len(self._snapshot)

    def get_changes(self) -> ChangeReport:
        """Compare current file state to the last snapshot.

        Returns a ChangeReport with modified, added, and deleted files.
        Each call updates the baseline so subsequent calls only show new changes.
        """
        report = ChangeReport()
        current: dict[str, float] = {}

        for root, dirs, filenames in os.walk(self.project_dir):
            dirs[:] = [d for d in dirs if d.lower() not in SKIP_DIRS]

            for fname in filenames:
                ext = os.path.splitext(fname)[1].lower()
                if ext in TRACKED_EXTENSIONS:
                    full_path = os.path.join(root, fname)
                    rel_path = os.path.relpath(full_path, self.project_dir)
                    try:
                        current[rel_path] = os.path.getmtime(full_path)
                    except OSError:
                        pass

        # Find changes
        for path, mtime in current.items():
            if path not in self._snapshot:
                report.added.append(path)
            elif mtime != self._snapshot[path]:
                report.modified.append(path)

        for path in self._snapshot:
            if path not in current:
                report.deleted.append(path)

        # Update baseline
        self._snapshot = current

        return report

    def update_file_snapshot(self, rel_path: str) -> None:
        """Update the snapshot for a single file.

        Call this after writing a file so it doesn't show as a change.
        """
        full_path = os.path.join(self.project_dir, rel_path)
        try:
            self._snapshot[rel_path] = os.path.getmtime(full_path)
        except OSError:
            pass

    @property
    def tracked_count(self) -> int:
        return len(self._snapshot)


# ---------------------------------------------------------------------------
# High-level operations (used by MCP tools)
# ---------------------------------------------------------------------------

def get_ide_context() -> IDEContext | None:
    """Detect the IDE and return context about what's open."""
    return detect_ide_window()


def start_watching(
    project_name: str | None = None,
    project_dir: str | None = None,
    search_roots: list[str] | None = None,
) -> tuple[ProjectInfo, int] | None:
    """Start tracking a project for file changes.

    Either provide project_name (to search) or project_dir (direct path).
    Returns (ProjectInfo, file_count) or None if not found.
    """
    global _current_project, _file_tracker

    if project_dir:
        project = _build_project_info(
            project_dir,
            project_name or os.path.basename(project_dir),
        )
    elif project_name:
        project = find_project(project_name, search_roots)
    else:
        return None

    if project is None:
        return None

    _current_project = project
    _file_tracker = FileTracker(project.project_dir)
    file_count = _file_tracker.take_snapshot()

    return project, file_count


def get_changes() -> ChangeReport | None:
    """Get file changes since last check.

    Returns None if no project is being watched.
    """
    if _file_tracker is None:
        return None
    return _file_tracker.get_changes()


def read_project_file(file_path: str) -> str | None:
    """Read a source file from the current project.

    Args:
        file_path: Relative path from project root, or absolute path.

    Returns:
        File contents as string, or None if not found.
    """
    if _current_project is None:
        return None

    # Resolve relative path
    if not os.path.isabs(file_path):
        full_path = os.path.join(_current_project.project_dir, file_path)
    else:
        full_path = file_path

    try:
        with open(full_path, "r", encoding="utf-8", errors="replace") as f:
            return f.read()
    except OSError:
        return None


def write_project_file(file_path: str, content: str) -> str:
    """Write/update a source file in the current project.

    Creates a .bak backup of existing files before overwriting.
    Updates the file tracker so the write doesn't appear as a change.

    Args:
        file_path: Relative path from project root, or absolute path.
        content: The new file content.

    Returns:
        Status message.
    """
    if _current_project is None:
        return "No project is being watched. Call watch_project first."

    # Resolve relative path
    if not os.path.isabs(file_path):
        full_path = os.path.join(_current_project.project_dir, file_path)
        rel_path = file_path
    else:
        full_path = file_path
        rel_path = os.path.relpath(full_path, _current_project.project_dir)

    # Create backup if file exists
    if os.path.exists(full_path):
        bak_path = full_path + ".bak"
        try:
            shutil.copy2(full_path, bak_path)
        except OSError:
            pass

    # Write the file
    try:
        os.makedirs(os.path.dirname(full_path), exist_ok=True)
        with open(full_path, "w", encoding="utf-8") as f:
            f.write(content)
    except OSError as e:
        return f"Failed to write {file_path}: {e}"

    # Update tracker so this write doesn't show as a change
    if _file_tracker is not None:
        _file_tracker.update_file_snapshot(rel_path)

    line_count = content.count("\n") + (1 if content and not content.endswith("\n") else 0)
    return f"Written {file_path} ({line_count} lines)"


def compile_project_in_temp() -> str:
    """Compile the current project in a temporary folder.

    Copies all source files to a temp directory, compiles there,
    and returns the compiler output. Never touches the user's build.

    Returns:
        Compilation result as a formatted string.
    """
    if _current_project is None:
        return "No project is being watched. Call watch_project first."

    from pascal_mcp.compiler import compile_project, _ensure_res_files, _select_compiler, detect_compilers

    # Copy project files to temp directory
    temp_dir = tempfile.mkdtemp(prefix="pascal_check_")

    try:
        # Collect all files to compile
        files: dict[str, str] = {}
        project_dir = _current_project.project_dir

        for rel_path in _current_project.source_files:
            full_path = os.path.join(project_dir, rel_path)
            try:
                with open(full_path, "r", encoding="utf-8", errors="replace") as f:
                    files[rel_path] = f.read()
            except OSError:
                continue

        if not files:
            return "No source files found in the project."

        # Also copy .res files if they exist
        for fname in os.listdir(project_dir):
            if fname.lower().endswith(".res"):
                src = os.path.join(project_dir, fname)
                dst = os.path.join(temp_dir, fname)
                try:
                    shutil.copy2(src, dst)
                except OSError:
                    pass

        result = compile_project(files, output_dir=temp_dir)

        parts = [f"Compiler: {result.compiler_used}"]
        parts.append(f"Success: {result.success}")
        parts.append(f"Exit code: {result.exit_code}")

        if result.stdout.strip():
            parts.append(f"\n--- Compiler Output ---\n{result.stdout.strip()}")
        if result.stderr.strip():
            parts.append(f"\n--- Compiler Messages ---\n{result.stderr.strip()}")

        return "\n".join(parts)

    finally:
        # Clean up temp directory
        try:
            shutil.rmtree(temp_dir, ignore_errors=True)
        except Exception:
            pass


def get_project_overview() -> str:
    """Generate a summary of the current project.

    Includes file tree, form summaries, and unit dependencies.

    Returns:
        Formatted project overview string.
    """
    if _current_project is None:
        return "No project is being watched. Call watch_project first."

    project = _current_project
    parts = []

    # Project header
    project_name = os.path.basename(project.project_dir)
    parts.append(f"Project: {project_name}")
    parts.append(f"Directory: {project.project_dir}")
    if project.dpr_path:
        parts.append(f"Main file: {os.path.basename(project.dpr_path)}")
    parts.append("")

    # File tree grouped by extension
    files_by_ext: dict[str, list[str]] = {}
    for rel_path in project.source_files:
        ext = os.path.splitext(rel_path)[1].lower()
        files_by_ext.setdefault(ext, []).append(rel_path)

    ext_labels = {
        ".dpr": "Project files",
        ".dproj": "Project config",
        ".pas": "Pascal units",
        ".dfm": "VCL forms",
        ".fmx": "FMX forms",
        ".lfm": "Lazarus forms",
        ".inc": "Include files",
    }

    parts.append(f"Source files ({len(project.source_files)} total):")
    for ext in [".dpr", ".dproj", ".pas", ".dfm", ".fmx", ".lfm", ".inc"]:
        file_list = files_by_ext.get(ext, [])
        if file_list:
            label = ext_labels.get(ext, ext)
            parts.append(f"\n  {label}:")
            for f in file_list:
                parts.append(f"    {f}")

    # Form summaries
    form_files = []
    for ext in (".dfm", ".fmx", ".lfm"):
        form_files.extend(files_by_ext.get(ext, []))

    if form_files:
        parts.append("\nForms:")
        from pascal_mcp.form_parser import parse_form_file, format_summary

        for form_rel in form_files:
            form_path = os.path.join(project.project_dir, form_rel)
            try:
                root = parse_form_file(form_path)
                if root:
                    summary = format_summary(root)
                    # Indent summary lines
                    for line in summary.splitlines():
                        parts.append(f"  {line}")
                    parts.append("")
            except Exception:
                parts.append(f"  {form_rel}: (could not parse)")

    # Unit dependencies (from uses clauses)
    pas_files = files_by_ext.get(".pas", [])
    if pas_files:
        parts.append("\nUnit dependencies:")
        for pas_rel in pas_files:
            pas_path = os.path.join(project.project_dir, pas_rel)
            try:
                with open(pas_path, "r", encoding="utf-8", errors="replace") as f:
                    content = f.read(8192)  # Read first 8KB for uses clause

                # Extract uses clause
                uses_match = re.search(
                    r"\buses\b\s+(.*?);",
                    content,
                    re.DOTALL | re.IGNORECASE,
                )
                if uses_match:
                    units_text = uses_match.group(1)
                    # Clean up: remove comments and 'in' clauses
                    units_text = re.sub(r"\{[^}]*\}", "", units_text)
                    units_text = re.sub(r"\(\*.*?\*\)", "", units_text, flags=re.DOTALL)
                    units_text = re.sub(r"in\s+'[^']*'", "", units_text)
                    units = [u.strip() for u in units_text.split(",") if u.strip()]
                    if units:
                        unit_name = os.path.splitext(os.path.basename(pas_rel))[0]
                        parts.append(f"  {unit_name} uses: {', '.join(units)}")
            except OSError:
                pass

    return "\n".join(parts)
