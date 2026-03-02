"""Preview bridge server for Pascal desktop applications.

Serves a web page with live screenshots of a running Pascal/Delphi
application, allowing Claude's preview tools (preview_start,
preview_screenshot, preview_click) to see and interact with
desktop GUI apps through the browser viewport.

Also captures console output from launched Pascal programs and
displays it alongside the screenshot.
"""

from __future__ import annotations

import base64
import collections
import ctypes
import ctypes.wintypes
import io
import json
import subprocess
import sys
import time
import threading

from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import HTMLResponse, JSONResponse, Response
from starlette.routing import Route

from pascal_mcp.screenshot import (
    capture_window,
    list_windows,
    _find_window_by_title,
    _get_window_title,
    _bring_window_to_front,
)

# ---------------------------------------------------------------------------
# Global state
# ---------------------------------------------------------------------------
_target_title: str = ""
_target_hwnd: int | None = None

# Console output buffer (circular, max 500 lines)
_console_lines: collections.deque = collections.deque(maxlen=500)
_console_lock = threading.Lock()

# Track launched processes
_launched_processes: list[subprocess.Popen] = []


def _resolve_target() -> tuple[int | None, str]:
    """Resolve the current target window handle and title."""
    global _target_hwnd, _target_title

    if not _target_title:
        return None, ""

    hwnd = _find_window_by_title(_target_title)
    if hwnd is not None:
        _target_hwnd = hwnd
        return hwnd, _get_window_title(hwnd)

    _target_hwnd = None
    return None, _target_title


def add_console_message(text: str, level: str = "info") -> None:
    """Add a message to the console output buffer.

    Called by the MCP server when launching apps or capturing output.
    """
    timestamp = time.strftime("%H:%M:%S")
    with _console_lock:
        for line in text.splitlines():
            _console_lines.append({
                "time": timestamp,
                "level": level,
                "text": line,
            })


def _read_process_output(proc: subprocess.Popen, label: str) -> None:
    """Background thread to read stdout/stderr from a launched process."""
    def reader(stream, level):
        try:
            for line in iter(stream.readline, ""):
                if line:
                    add_console_message(f"[{label}] {line.rstrip()}", level)
        except Exception:
            pass

    if proc.stdout:
        t = threading.Thread(target=reader, args=(proc.stdout, "info"), daemon=True)
        t.start()
    if proc.stderr:
        t = threading.Thread(target=reader, args=(proc.stderr, "error"), daemon=True)
        t.start()


def launch_process(exe_path: str, title_hint: str = "") -> dict:
    """Launch an executable and start capturing its output.

    Returns a dict with process info.
    """
    global _target_title

    try:
        proc = subprocess.Popen(
            [exe_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            cwd=__import__("os").path.dirname(exe_path),
            creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if sys.platform == "win32" else 0,
        )
        _launched_processes.append(proc)

        label = title_hint or __import__("os").path.basename(exe_path)
        _read_process_output(proc, label)
        add_console_message(f"Launched {label} (PID {proc.pid})", "info")

        # Wait for window to appear
        time.sleep(1.0)

        if proc.poll() is not None:
            add_console_message(f"{label} exited with code {proc.returncode}", "error")
            return {"status": "exited", "pid": proc.pid, "exit_code": proc.returncode}

        # Auto-set target if not already set
        if not _target_title and title_hint:
            _target_title = title_hint

        return {"status": "running", "pid": proc.pid}

    except Exception as e:
        add_console_message(f"Failed to launch: {e}", "error")
        return {"status": "error", "message": str(e)}


# ---------------------------------------------------------------------------
# Win32 input structures (shared by mouse and keyboard helpers)
# ---------------------------------------------------------------------------

INPUT_MOUSE = 0
INPUT_KEYBOARD = 1

MOUSEEVENTF_MOVE = 0x0001
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004
MOUSEEVENTF_RIGHTDOWN = 0x0008
MOUSEEVENTF_RIGHTUP = 0x0010
MOUSEEVENTF_ABSOLUTE = 0x8000
MOUSEEVENTF_VIRTUALDESK = 0x4000

# Combined flags for multi-monitor absolute positioning
_ABS_FLAGS = MOUSEEVENTF_ABSOLUTE | MOUSEEVENTF_VIRTUALDESK

KEYEVENTF_UNICODE = 0x0004
KEYEVENTF_KEYUP = 0x0002
KEYEVENTF_EXTENDEDKEY = 0x0001

# Virtual key codes for special keys
VK_MAP = {
    "enter": 0x0D, "return": 0x0D, "tab": 0x09, "escape": 0x1B, "esc": 0x1B,
    "backspace": 0x08, "delete": 0x2E, "space": 0x20,
    "up": 0x26, "down": 0x28, "left": 0x25, "right": 0x27,
    "home": 0x24, "end": 0x23, "pageup": 0x21, "pagedown": 0x22,
    "f1": 0x70, "f2": 0x71, "f3": 0x72, "f4": 0x73, "f5": 0x74,
    "f6": 0x75, "f7": 0x76, "f8": 0x77, "f9": 0x78, "f10": 0x79,
    "f11": 0x7A, "f12": 0x7B,
    "ctrl": 0x11, "control": 0x11, "alt": 0x12, "shift": 0x10,
}


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [
        ("wVk", ctypes.c_ushort),
        ("wScan", ctypes.c_ushort),
        ("dwFlags", ctypes.c_ulong),
        ("time", ctypes.c_ulong),
        ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong)),
    ]


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [
        ("dx", ctypes.c_long),
        ("dy", ctypes.c_long),
        ("mouseData", ctypes.c_ulong),
        ("dwFlags", ctypes.c_ulong),
        ("time", ctypes.c_ulong),
        ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong)),
    ]


class _INPUT_UNION(ctypes.Union):
    _fields_ = [("mi", MOUSEINPUT), ("ki", KEYBDINPUT)]


class INPUT(ctypes.Structure):
    _fields_ = [("type", ctypes.c_ulong), ("ii", _INPUT_UNION)]


def _send_input(*inputs: INPUT) -> int:
    """Send one or more INPUT structs via SendInput."""
    arr = (INPUT * len(inputs))(*inputs)
    return ctypes.windll.user32.SendInput(len(inputs), arr, ctypes.sizeof(INPUT))


# ---------------------------------------------------------------------------
# Win32 helpers — window geometry
# ---------------------------------------------------------------------------

def _window_to_screen(hwnd: int, x: int, y: int) -> tuple[int, int]:
    """Convert window-relative (x, y) to screen coordinates."""
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    return rect.left + x, rect.top + y


def _client_to_screen(hwnd: int, x: int, y: int) -> tuple[int, int]:
    """Convert client-area (x, y) to screen coordinates using Win32 API.

    This properly handles DPI scaling, title bars, and borders.
    """
    pt = ctypes.wintypes.POINT(x, y)
    ctypes.windll.user32.ClientToScreen(hwnd, ctypes.byref(pt))
    return pt.x, pt.y


def _get_client_offset(hwnd: int) -> tuple[int, int]:
    """Get the offset from window origin to client area origin.

    Returns (offset_x, offset_y) — the position of the client area
    top-left corner relative to the window's top-left corner.
    This accounts for title bar height, borders, and DPI scaling.
    """
    # Client (0,0) in screen coordinates
    pt = ctypes.wintypes.POINT(0, 0)
    ctypes.windll.user32.ClientToScreen(hwnd, ctypes.byref(pt))
    # Window origin in screen coordinates
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    return pt.x - rect.left, pt.y - rect.top


def _get_window_rect(hwnd: int) -> tuple[int, int, int, int]:
    """Return (left, top, width, height) of a window."""
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    return rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top


# ---------------------------------------------------------------------------
# Win32 helpers — mouse actions
# ---------------------------------------------------------------------------

def _screen_to_absolute(sx: int, sy: int) -> tuple[int, int]:
    """Convert screen coordinates to absolute coordinates for SendInput.

    SendInput with MOUSEEVENTF_ABSOLUTE uses a coordinate space of
    0..65535 mapped across the entire virtual screen (all monitors).
    """
    # SM_XVIRTUALSCREEN (76), SM_YVIRTUALSCREEN (77) = virtual screen origin
    # SM_CXVIRTUALSCREEN (78), SM_CYVIRTUALSCREEN (79) = virtual screen size
    vx = ctypes.windll.user32.GetSystemMetrics(76)
    vy = ctypes.windll.user32.GetSystemMetrics(77)
    vw = ctypes.windll.user32.GetSystemMetrics(78)
    vh = ctypes.windll.user32.GetSystemMetrics(79)

    abs_x = int(((sx - vx) * 65535) / (vw - 1))
    abs_y = int(((sy - vy) * 65535) / (vh - 1))
    return abs_x, abs_y


def _click_window(
    hwnd: int, x: int, y: int,
    button: str = "left",
    double: bool = False,
) -> bool:
    """Send a mouse click to a window at (x, y) relative to window origin.

    Uses SendInput with MOUSEEVENTF_ABSOLUTE for reliable multi-monitor support.
    """
    if sys.platform != "win32":
        return False

    _bring_window_to_front(hwnd)
    time.sleep(0.1)

    # Re-read window position after bringing to front (may have changed)
    sx, sy = _window_to_screen(hwnd, x, y)
    abs_x, abs_y = _screen_to_absolute(sx, sy)

    if button == "right":
        down_flag = MOUSEEVENTF_RIGHTDOWN
        up_flag = MOUSEEVENTF_RIGHTUP
    else:
        down_flag = MOUSEEVENTF_LEFTDOWN
        up_flag = MOUSEEVENTF_LEFTUP

    clicks = 2 if double else 1
    for _ in range(clicks):
        # Move cursor to position using absolute coordinates
        inp_move = INPUT()
        inp_move.type = INPUT_MOUSE
        inp_move.ii.mi.dx = abs_x
        inp_move.ii.mi.dy = abs_y
        inp_move.ii.mi.dwFlags = MOUSEEVENTF_MOVE | _ABS_FLAGS
        _send_input(inp_move)
        time.sleep(0.03)

        # Mouse down
        inp_down = INPUT()
        inp_down.type = INPUT_MOUSE
        inp_down.ii.mi.dx = abs_x
        inp_down.ii.mi.dy = abs_y
        inp_down.ii.mi.dwFlags = down_flag | _ABS_FLAGS
        _send_input(inp_down)
        time.sleep(0.03)

        # Mouse up
        inp_up = INPUT()
        inp_up.type = INPUT_MOUSE
        inp_up.ii.mi.dx = abs_x
        inp_up.ii.mi.dy = abs_y
        inp_up.ii.mi.dwFlags = up_flag | _ABS_FLAGS
        _send_input(inp_up)
        time.sleep(0.05)

    time.sleep(0.1)
    return True


def _click_client(
    hwnd: int, x: int, y: int,
    button: str = "left",
    double: bool = False,
) -> bool:
    """Send a mouse click using client-area coordinates.

    Uses ClientToScreen for proper DPI and title bar offset handling.
    This is the preferred method when you know the DFM coordinates.
    """
    if sys.platform != "win32":
        return False

    _bring_window_to_front(hwnd)
    time.sleep(0.1)

    sx, sy = _client_to_screen(hwnd, x, y)
    abs_x, abs_y = _screen_to_absolute(sx, sy)

    if button == "right":
        down_flag = MOUSEEVENTF_RIGHTDOWN
        up_flag = MOUSEEVENTF_RIGHTUP
    else:
        down_flag = MOUSEEVENTF_LEFTDOWN
        up_flag = MOUSEEVENTF_LEFTUP

    clicks = 2 if double else 1
    for _ in range(clicks):
        inp_move = INPUT()
        inp_move.type = INPUT_MOUSE
        inp_move.ii.mi.dx = abs_x
        inp_move.ii.mi.dy = abs_y
        inp_move.ii.mi.dwFlags = MOUSEEVENTF_MOVE | _ABS_FLAGS
        _send_input(inp_move)
        time.sleep(0.03)

        inp_down = INPUT()
        inp_down.type = INPUT_MOUSE
        inp_down.ii.mi.dx = abs_x
        inp_down.ii.mi.dy = abs_y
        inp_down.ii.mi.dwFlags = down_flag | _ABS_FLAGS
        _send_input(inp_down)
        time.sleep(0.03)

        inp_up = INPUT()
        inp_up.type = INPUT_MOUSE
        inp_up.ii.mi.dx = abs_x
        inp_up.ii.mi.dy = abs_y
        inp_up.ii.mi.dwFlags = up_flag | _ABS_FLAGS
        _send_input(inp_up)
        time.sleep(0.05)

    time.sleep(0.1)
    return True


def _find_deepest_child(hwnd: int, screen_x: int, screen_y: int) -> int:
    """Find the deepest child window at a screen position.

    Recursively walks child windows using ChildWindowFromPoint
    to find the most specific target for mouse messages.
    Returns the original hwnd if no child is found.
    """
    CWP_SKIPINVISIBLE = 0x0001
    CWP_SKIPDISABLED = 0x0002
    CWP_SKIPTRANSPARENT = 0x0004

    current = hwnd
    for _ in range(10):  # Max depth to prevent infinite loops
        # Convert screen coords to current window's client coords
        pt = ctypes.wintypes.POINT(screen_x, screen_y)
        ctypes.windll.user32.ScreenToClient(current, ctypes.byref(pt))

        # Find child at this position (skip transparent/disabled)
        child = ctypes.windll.user32.ChildWindowFromPointEx(
            current, pt, CWP_SKIPTRANSPARENT,
        )

        if not child or child == current:
            break
        current = child

    return current


def _click_message(
    hwnd: int, x: int, y: int,
    button: str = "left",
    double: bool = False,
) -> dict:
    """Click via PostMessage using screenshot pixel coordinates.

    The screenshot from PrintWindow is in physical pixels relative to
    the window's top-left corner (matching GetWindowRect).

    Automatically finds the deepest child window at the click position
    (e.g., a WebView2 control inside an FMX window) and sends the
    click directly to it with properly translated coordinates.

    Returns a dict with status and debug info about the coordinate
    mapping so we can verify accuracy.
    """
    if sys.platform != "win32":
        return {"ok": False, "error": "Windows only"}

    WM_LBUTTONDOWN = 0x0201
    WM_LBUTTONUP = 0x0202
    WM_RBUTTONDOWN = 0x0204
    WM_RBUTTONUP = 0x0205
    WM_LBUTTONDBLCLK = 0x0203
    MK_LBUTTON = 0x0001
    MK_RBUTTON = 0x0002

    # --- Step 1: Get window geometry ---
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))

    # --- Step 2: Screenshot pixel → screen position ---
    screen_x = rect.left + x
    screen_y = rect.top + y

    # --- Step 3: Find the deepest child at this screen position ---
    # For VCL apps, this finds native controls (TButton, TEdit, etc.)
    # and we can send clicks directly to them for better accuracy.
    # For Chrome/WebView2 widgets, we keep the main window as target
    # because FMX handles focus routing to the embedded browser.
    child_hwnd = _find_deepest_child(hwnd, screen_x, screen_y)

    # Get child's class name to decide targeting strategy
    class_buf = ctypes.create_unicode_buffer(256)
    ctypes.windll.user32.GetClassNameW(child_hwnd, class_buf, 256)
    child_class = class_buf.value

    # Chrome/WebView2 controls don't process PostMessage clicks properly
    # for focus management — send to the main (FMX) window instead.
    chrome_classes = {"Chrome_WidgetWin_0", "Chrome_WidgetWin_1",
                      "Chrome_RenderWidgetHostHWND",
                      "Intermediate D3D Window"}
    if child_class in chrome_classes or child_hwnd == hwnd:
        target_hwnd = hwnd
        target_class = "main"
    else:
        target_hwnd = child_hwnd
        target_class = child_class

    # --- Step 4: Screen → target's client coords ---
    pt = ctypes.wintypes.POINT(screen_x, screen_y)
    ctypes.windll.user32.ScreenToClient(target_hwnd, ctypes.byref(pt))
    cx, cy = pt.x, pt.y

    # --- Debug info ---
    try:
        dpi = ctypes.windll.user32.GetDpiForWindow(hwnd)
    except Exception:
        dpi = 96

    debug = {
        "input_px": [x, y],
        "screen_pos": [screen_x, screen_y],
        "target_hwnd": str(target_hwnd),
        "target_class": target_class,
        "target_client": [cx, cy],
        "is_child": target_hwnd != hwnd,
        "window_origin": [rect.left, rect.top],
        "dpi": dpi,
    }

    # --- Step 5: Pack and send to target ---
    lparam = ((cy & 0xFFFF) << 16) | (cx & 0xFFFF)

    if button == "right":
        down_msg = WM_RBUTTONDOWN
        up_msg = WM_RBUTTONUP
        wparam = MK_RBUTTON
    else:
        down_msg = WM_LBUTTONDOWN
        up_msg = WM_LBUTTONUP
        wparam = MK_LBUTTON

    _bring_window_to_front(hwnd)
    time.sleep(0.1)

    clicks = 2 if double else 1
    for i in range(clicks):
        if i == 1 and button == "left":
            down_msg = WM_LBUTTONDBLCLK
        ctypes.windll.user32.PostMessageW(target_hwnd, down_msg, wparam, lparam)
        time.sleep(0.05)
        ctypes.windll.user32.PostMessageW(target_hwnd, up_msg, 0, lparam)
        time.sleep(0.05)

    time.sleep(0.1)
    return {"ok": True, "debug": debug}


def _drag_window(
    hwnd: int,
    x1: int, y1: int,
    x2: int, y2: int,
    steps: int = 20,
    duration: float = 0.3,
) -> bool:
    """Drag from (x1,y1) to (x2,y2) relative to the window origin.

    Uses SendInput with absolute coordinates for multi-monitor support.
    """
    if sys.platform != "win32":
        return False

    _bring_window_to_front(hwnd)
    time.sleep(0.1)

    sx1, sy1 = _window_to_screen(hwnd, x1, y1)
    sx2, sy2 = _window_to_screen(hwnd, x2, y2)
    abs_x1, abs_y1 = _screen_to_absolute(sx1, sy1)
    abs_x2, abs_y2 = _screen_to_absolute(sx2, sy2)

    # Move to start position
    inp = INPUT()
    inp.type = INPUT_MOUSE
    inp.ii.mi.dx = abs_x1
    inp.ii.mi.dy = abs_y1
    inp.ii.mi.dwFlags = MOUSEEVENTF_MOVE | _ABS_FLAGS
    _send_input(inp)
    time.sleep(0.05)

    # Press down
    inp = INPUT()
    inp.type = INPUT_MOUSE
    inp.ii.mi.dx = abs_x1
    inp.ii.mi.dy = abs_y1
    inp.ii.mi.dwFlags = MOUSEEVENTF_LEFTDOWN | _ABS_FLAGS
    _send_input(inp)
    time.sleep(0.05)

    # Smooth move
    step_delay = duration / max(steps, 1)
    for i in range(1, steps + 1):
        t = i / steps
        cx = int(abs_x1 + (abs_x2 - abs_x1) * t)
        cy = int(abs_y1 + (abs_y2 - abs_y1) * t)
        inp = INPUT()
        inp.type = INPUT_MOUSE
        inp.ii.mi.dx = cx
        inp.ii.mi.dy = cy
        inp.ii.mi.dwFlags = MOUSEEVENTF_MOVE | _ABS_FLAGS
        _send_input(inp)
        time.sleep(step_delay)

    # Release
    inp = INPUT()
    inp.type = INPUT_MOUSE
    inp.ii.mi.dx = abs_x2
    inp.ii.mi.dy = abs_y2
    inp.ii.mi.dwFlags = MOUSEEVENTF_LEFTUP | _ABS_FLAGS
    _send_input(inp)
    time.sleep(0.1)
    return True


def _move_window(hwnd: int, x: int, y: int) -> bool:
    """Move a window to screen position (x, y) without changing its size."""
    if sys.platform != "win32":
        return False
    _, _, w, h = _get_window_rect(hwnd)
    return bool(ctypes.windll.user32.MoveWindow(hwnd, x, y, w, h, True))


def _resize_window(hwnd: int, width: int, height: int) -> bool:
    """Resize a window without moving it."""
    if sys.platform != "win32":
        return False
    left, top, _, _ = _get_window_rect(hwnd)
    return bool(ctypes.windll.user32.MoveWindow(hwnd, left, top, width, height, True))


# ---------------------------------------------------------------------------
# Win32 helpers — keyboard
# ---------------------------------------------------------------------------

def _type_text(hwnd: int, text: str) -> bool:
    """Send unicode text to a window character by character."""
    if sys.platform != "win32":
        return False

    _bring_window_to_front(hwnd)

    for char in text:
        code = ord(char)
        inp_down = INPUT()
        inp_down.type = INPUT_KEYBOARD
        inp_down.ii.ki.wScan = code
        inp_down.ii.ki.dwFlags = KEYEVENTF_UNICODE
        inp_up = INPUT()
        inp_up.type = INPUT_KEYBOARD
        inp_up.ii.ki.wScan = code
        inp_up.ii.ki.dwFlags = KEYEVENTF_UNICODE | KEYEVENTF_KEYUP
        _send_input(inp_down, inp_up)
        time.sleep(0.02)

    return True


def _send_key(hwnd: int, key: str) -> bool:
    """Send a special key or key combination (e.g. 'enter', 'ctrl+a').

    Supports: enter, tab, escape, backspace, delete, arrows, F1-F12,
    and modifier combos like ctrl+a, ctrl+shift+s, alt+f4.
    """
    if sys.platform != "win32":
        return False

    _bring_window_to_front(hwnd)

    parts = [p.strip().lower() for p in key.split("+")]
    modifiers = []
    main_key = None

    for p in parts:
        if p in ("ctrl", "control", "alt", "shift"):
            modifiers.append(VK_MAP[p])
        elif p in VK_MAP:
            main_key = VK_MAP[p]
        elif len(p) == 1:
            # Single character — use virtual key code
            main_key = ord(p.upper())
        else:
            return False

    if main_key is None:
        return False

    # Press modifiers
    for vk in modifiers:
        inp = INPUT()
        inp.type = INPUT_KEYBOARD
        inp.ii.ki.wVk = vk
        _send_input(inp)
        time.sleep(0.02)

    # Press and release main key
    inp_down = INPUT()
    inp_down.type = INPUT_KEYBOARD
    inp_down.ii.ki.wVk = main_key
    inp_up = INPUT()
    inp_up.type = INPUT_KEYBOARD
    inp_up.ii.ki.wVk = main_key
    inp_up.ii.ki.dwFlags = KEYEVENTF_KEYUP
    _send_input(inp_down)
    time.sleep(0.03)
    _send_input(inp_up)
    time.sleep(0.02)

    # Release modifiers in reverse
    for vk in reversed(modifiers):
        inp = INPUT()
        inp.type = INPUT_KEYBOARD
        inp.ii.ki.wVk = vk
        inp.ii.ki.dwFlags = KEYEVENTF_KEYUP
        _send_input(inp)
        time.sleep(0.02)

    return True


# ---------------------------------------------------------------------------
# Win32 helpers — direct control interaction
# ---------------------------------------------------------------------------

BM_CLICK = 0x00F5
WM_LBUTTONDOWN = 0x0201
WM_LBUTTONUP = 0x0202


def _click_control_direct(child_hwnd: int) -> bool:
    """Send a BM_CLICK message directly to a control by its HWND.

    This bypasses cursor positioning entirely — works regardless of
    DPI, multi-monitor setup, or foreground restrictions.
    """
    if sys.platform != "win32":
        return False
    ctypes.windll.user32.PostMessageW(child_hwnd, BM_CLICK, 0, 0)
    time.sleep(0.1)
    return True


# ---------------------------------------------------------------------------
# Win32 helpers — control enumeration
# ---------------------------------------------------------------------------

def _enum_child_controls(hwnd: int) -> list[dict]:
    """Enumerate all child controls of a window.

    Returns a list of controls with their class, text, position, and size
    in client coordinates of the parent window.
    """
    if sys.platform != "win32":
        return []

    controls: list[dict] = []

    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.wintypes.HWND, ctypes.wintypes.LPARAM)
    def enum_callback(child_hwnd, lparam):
        # Get class name
        class_buf = ctypes.create_unicode_buffer(256)
        ctypes.windll.user32.GetClassNameW(child_hwnd, class_buf, 256)
        class_name = class_buf.value

        # Get window text (caption)
        text_len = ctypes.windll.user32.GetWindowTextLengthW(child_hwnd)
        text = ""
        if text_len > 0:
            text_buf = ctypes.create_unicode_buffer(text_len + 1)
            ctypes.windll.user32.GetWindowTextW(child_hwnd, text_buf, text_len + 1)
            text = text_buf.value

        # Get control rect in screen coords, then convert to parent client coords
        rect = ctypes.wintypes.RECT()
        ctypes.windll.user32.GetWindowRect(child_hwnd, ctypes.byref(rect))

        # Convert screen coords to parent's client coords
        pt_tl = ctypes.wintypes.POINT(rect.left, rect.top)
        pt_br = ctypes.wintypes.POINT(rect.right, rect.bottom)
        ctypes.windll.user32.ScreenToClient(hwnd, ctypes.byref(pt_tl))
        ctypes.windll.user32.ScreenToClient(hwnd, ctypes.byref(pt_br))

        is_visible = bool(ctypes.windll.user32.IsWindowVisible(child_hwnd))

        controls.append({
            "hwnd": str(child_hwnd),
            "class": class_name,
            "text": text,
            "x": pt_tl.x,
            "y": pt_tl.y,
            "width": pt_br.x - pt_tl.x,
            "height": pt_br.y - pt_tl.y,
            "center_x": pt_tl.x + (pt_br.x - pt_tl.x) // 2,
            "center_y": pt_tl.y + (pt_br.y - pt_tl.y) // 2,
            "visible": is_visible,
        })
        return True

    ctypes.windll.user32.EnumChildWindows(hwnd, enum_callback, 0)
    return controls


# ---------------------------------------------------------------------------
# HTTP Endpoints
# ---------------------------------------------------------------------------

async def homepage(request: Request) -> HTMLResponse:
    """Serve the live screenshot viewer HTML page."""
    return HTMLResponse(PAGE_HTML)


async def api_screenshot(request: Request) -> Response:
    """Return a PNG screenshot of the target window."""
    title = request.query_params.get("title", _target_title)
    if not title:
        return JSONResponse(
            {"error": "No target window set. POST to /api/target first."},
            status_code=400,
        )

    result = capture_window(title)
    if result is None:
        return JSONResponse(
            {"error": f"Window not found: {title}"},
            status_code=404,
        )

    b64_data, actual_title, width, height = result
    png_bytes = base64.b64decode(b64_data)

    return Response(
        content=png_bytes,
        media_type="image/png",
        headers={
            "X-Window-Title": actual_title,
            "X-Window-Width": str(width),
            "X-Window-Height": str(height),
            "Cache-Control": "no-cache, no-store",
        },
    )


async def api_windows(request: Request) -> JSONResponse:
    """List visible windows."""
    filter_text = request.query_params.get("filter", "")
    windows = list_windows(filter_text)
    return JSONResponse({"windows": windows, "current_target": _target_title})


async def api_target(request: Request) -> JSONResponse:
    """Set the target window to capture."""
    global _target_title, _target_hwnd

    body = await request.json()
    title = body.get("title", "")

    if not title:
        return JSONResponse({"error": "title is required"}, status_code=400)

    _target_title = title
    hwnd, actual = _resolve_target()
    add_console_message(f"Target set to: {actual or title}", "info")

    if hwnd is None:
        return JSONResponse({
            "status": "warning",
            "message": f"Window '{title}' not found yet. Will retry on next screenshot.",
            "target": title,
        })

    return JSONResponse({
        "status": "ok",
        "target": actual,
        "hwnd": str(hwnd),
    })


async def api_click(request: Request) -> JSONResponse:
    """Send a click to the target window at (x, y).

    Body options:
      {"x": N, "y": N}                    - window-relative coords (from screenshot)
      {"x": N, "y": N, "client": true}    - client-area coords (DPI-aware)
      {"x": N, "y": N, "message": true}   - window coords via WM messages (best for FMX/WebView)
      {"hwnd": "12345"}                    - direct BM_CLICK to a control by hwnd
                                             (get hwnd from /api/controls endpoint)
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()

    # Direct control click by hwnd (most reliable)
    control_hwnd = body.get("hwnd", "")
    if control_hwnd:
        success = _click_control_direct(int(control_hwnd))
        add_console_message(f"Direct click on control hwnd={control_hwnd}", "info")
        return JSONResponse({"status": "ok" if success else "failed", "hwnd": control_hwnd})

    x = int(body.get("x", 0))
    y = int(body.get("y", 0))
    button = body.get("button", "left")
    double = body.get("double", False)
    use_client = body.get("client", False)
    use_message = body.get("message", False)

    if use_message:
        result = _click_message(hwnd, x, y, button=button, double=double)
        coord_type = "message"
        success = result.get("ok", False)
        debug = result.get("debug", {})
    elif use_client:
        success = _click_client(hwnd, x, y, button=button, double=double)
        coord_type = "client"
        debug = {}
    else:
        success = _click_window(hwnd, x, y, button=button, double=double)
        coord_type = "window"
        debug = {}

    action = f"{'Double-' if double else ''}{'Right-' if button == 'right' else ''}Click"
    client_info = f" -> {debug.get('target_class', '?')}({debug.get('target_client', '?')})" if debug else ""
    add_console_message(f"{action} at {coord_type}({x}, {y}){client_info}", "info")

    resp = {"status": "ok" if success else "failed", "x": x, "y": y, "mode": coord_type}
    if debug:
        resp["debug"] = debug
    return JSONResponse(resp)


async def api_debug_coords(request: Request) -> JSONResponse:
    """Debug endpoint: show coordinate mapping WITHOUT clicking.

    Body: {"x": N, "y": N}  (window/screenshot coords)

    Returns all intermediate coordinate values so we can diagnose
    where the DPI offset is introduced.
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    x = int(body.get("x", 0))
    y = int(body.get("y", 0))

    # Window rect (physical pixels for DPI-aware process)
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    win_rect = {"left": rect.left, "top": rect.top, "right": rect.right, "bottom": rect.bottom}
    win_w = rect.right - rect.left
    win_h = rect.bottom - rect.top

    # Client rect
    crect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetClientRect(hwnd, ctypes.byref(crect))
    client_rect = {"width": crect.right, "height": crect.bottom}

    # Client offset
    off_x, off_y = _get_client_offset(hwnd)

    # Window-to-screen (simple addition)
    screen_via_window = {"x": rect.left + x, "y": rect.top + y}

    # Client-to-screen (via Win32 API)
    cx = x - off_x
    cy = y - off_y
    pt = ctypes.wintypes.POINT(cx, cy)
    ctypes.windll.user32.ClientToScreen(hwnd, ctypes.byref(pt))
    screen_via_client = {"x": pt.x, "y": pt.y}

    # DPI info
    try:
        dpi = ctypes.windll.user32.GetDpiForWindow(hwnd)
    except Exception:
        dpi = 96

    # Child window at position
    child_hwnd = ctypes.windll.user32.WindowFromPoint(pt)
    child_class = ctypes.create_unicode_buffer(256)
    ctypes.windll.user32.GetClassNameW(child_hwnd, child_class, 256)
    child_pt = ctypes.wintypes.POINT(pt.x, pt.y)
    ctypes.windll.user32.ScreenToClient(child_hwnd, ctypes.byref(child_pt))

    # Enumerate monitors
    monitors = []
    MONITORINFOEXW = type('MONITORINFOEXW', (ctypes.Structure,), {
        '_fields_': [
            ('cbSize', ctypes.wintypes.DWORD),
            ('rcMonitor', ctypes.wintypes.RECT),
            ('rcWork', ctypes.wintypes.RECT),
            ('dwFlags', ctypes.wintypes.DWORD),
            ('szDevice', ctypes.c_wchar * 32),
        ]
    })

    def _enum_callback(hMonitor, hdcMonitor, lprcMonitor, dwData):
        info = MONITORINFOEXW()
        info.cbSize = ctypes.sizeof(MONITORINFOEXW)
        ctypes.windll.user32.GetMonitorInfoW(hMonitor, ctypes.byref(info))
        try:
            mon_dpi_x = ctypes.c_uint()
            mon_dpi_y = ctypes.c_uint()
            ctypes.windll.shcore.GetDpiForMonitor(hMonitor, 0, ctypes.byref(mon_dpi_x), ctypes.byref(mon_dpi_y))
            mon_dpi = mon_dpi_x.value
        except Exception:
            mon_dpi = 96
        m = info.rcMonitor
        monitors.append({
            "device": info.szDevice,
            "rect": {"left": m.left, "top": m.top, "right": m.right, "bottom": m.bottom},
            "width": m.right - m.left,
            "height": m.bottom - m.top,
            "dpi": mon_dpi,
            "scale": round(mon_dpi / 96.0, 2),
            "primary": bool(info.dwFlags & 1),
        })
        return True

    MONITORENUMPROC = ctypes.WINFUNCTYPE(ctypes.c_int, ctypes.c_void_p, ctypes.c_void_p, ctypes.POINTER(ctypes.wintypes.RECT), ctypes.c_long)
    ctypes.windll.user32.EnumDisplayMonitors(None, None, MONITORENUMPROC(_enum_callback), 0)

    # Virtual screen info
    vscreen = {
        "x": ctypes.windll.user32.GetSystemMetrics(76),  # SM_XVIRTUALSCREEN
        "y": ctypes.windll.user32.GetSystemMetrics(77),  # SM_YVIRTUALSCREEN
        "width": ctypes.windll.user32.GetSystemMetrics(78),  # SM_CXVIRTUALSCREEN
        "height": ctypes.windll.user32.GetSystemMetrics(79),  # SM_CYVIRTUALSCREEN
    }

    # DWM extended frame bounds (actual visible area, no invisible shadow)
    ext_rect = ctypes.wintypes.RECT()
    dwm_frame = {}
    try:
        DWMWA_EXTENDED_FRAME_BOUNDS = 9
        hr = ctypes.windll.dwmapi.DwmGetWindowAttribute(
            hwnd, DWMWA_EXTENDED_FRAME_BOUNDS,
            ctypes.byref(ext_rect), ctypes.sizeof(ext_rect),
        )
        if hr == 0:
            dwm_frame = {
                "extended_rect": {
                    "left": ext_rect.left, "top": ext_rect.top,
                    "right": ext_rect.right, "bottom": ext_rect.bottom,
                },
                "invisible_border": {
                    "left": ext_rect.left - rect.left,
                    "top": ext_rect.top - rect.top,
                    "right": rect.right - ext_rect.right,
                    "bottom": rect.bottom - ext_rect.bottom,
                },
            }
    except Exception:
        dwm_frame = {"error": "DwmGetWindowAttribute not available"}

    # ScreenToClient mapping (what _click_message will use)
    screen_x = rect.left + x
    screen_y = rect.top + y
    stc_pt = ctypes.wintypes.POINT(screen_x, screen_y)
    ctypes.windll.user32.ScreenToClient(hwnd, ctypes.byref(stc_pt))

    return JSONResponse({
        "input": {"x": x, "y": y},
        "window_rect": win_rect,
        "window_size": {"w": win_w, "h": win_h},
        "client_rect": client_rect,
        "client_offset": {"x": off_x, "y": off_y},
        "dwm_frame": dwm_frame,
        "click_mapping": {
            "screenshot_px": [x, y],
            "screen_pos": [screen_x, screen_y],
            "screen_to_client": [stc_pt.x, stc_pt.y],
            "manual_offset": [cx, cy],
            "match": (stc_pt.x == cx and stc_pt.y == cy),
        },
        "screen_via_window": screen_via_window,
        "screen_via_client": screen_via_client,
        "screen_match": screen_via_window == screen_via_client,
        "dpi": dpi,
        "dpi_scale": dpi / 96.0,
        "child_at_point": {
            "hwnd": str(child_hwnd),
            "class": child_class.value,
            "local_coords": {"x": child_pt.x, "y": child_pt.y},
        },
        "monitors": monitors,
        "virtual_screen": vscreen,
    })


async def api_cursor_test(request: Request) -> JSONResponse:
    """Calibration endpoint: move cursor to calculated position from screenshot coords.

    Does NOT click — just moves the cursor so you can visually verify
    where it lands relative to the target window.

    Body: {"x": N, "y": N}  (screenshot pixel coords)

    Returns the calculated screen position, the actual cursor position
    after moving, and the DWM frame adjustment values.
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    x = int(body.get("x", 0))
    y = int(body.get("y", 0))

    # Get window rect
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))

    # DWM extended frame bounds
    ext_rect = ctypes.wintypes.RECT()
    dwm_left = 0
    dwm_top = 0
    try:
        hr = ctypes.windll.dwmapi.DwmGetWindowAttribute(
            hwnd, 9, ctypes.byref(ext_rect), ctypes.sizeof(ext_rect))
        if hr == 0:
            dwm_left = ext_rect.left - rect.left
            dwm_top = ext_rect.top - rect.top
    except Exception:
        pass

    # Calculate screen position (same as _click_message)
    screen_x = rect.left + x
    screen_y = rect.top + y

    # ScreenToClient (what PostMessage will use)
    stc_pt = ctypes.wintypes.POINT(screen_x, screen_y)
    ctypes.windll.user32.ScreenToClient(hwnd, ctypes.byref(stc_pt))

    # Move cursor to the calculated screen position
    _bring_window_to_front(hwnd)
    time.sleep(0.1)
    ctypes.windll.user32.SetCursorPos(screen_x, screen_y)
    time.sleep(0.1)

    # Read back actual cursor position
    actual_pt = ctypes.wintypes.POINT()
    ctypes.windll.user32.GetCursorPos(ctypes.byref(actual_pt))

    return JSONResponse({
        "input_px": [x, y],
        "calculated_screen": [screen_x, screen_y],
        "actual_cursor": [actual_pt.x, actual_pt.y],
        "cursor_offset": [actual_pt.x - screen_x, actual_pt.y - screen_y],
        "client_coords_for_postmessage": [stc_pt.x, stc_pt.y],
        "window_origin": [rect.left, rect.top],
        "dwm_invisible_border": [dwm_left, dwm_top],
    })


async def api_type(request: Request) -> JSONResponse:
    """Send text or keystrokes to the target window.

    Body: {"text": "hello"} for typing text, or
          {"key": "enter"} / {"key": "ctrl+a"} for special keys.
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    text = body.get("text", "")
    key = body.get("key", "")

    if key:
        success = _send_key(hwnd, key)
        add_console_message(f"Key '{key}' -> {'ok' if success else 'failed'}", "info")
        return JSONResponse({"status": "ok" if success else "failed", "key": key})

    if text:
        success = _type_text(hwnd, text)
        add_console_message(f"Type '{text}' -> {'ok' if success else 'failed'}", "info")
        return JSONResponse({"status": "ok" if success else "failed", "text": text})

    return JSONResponse({"error": "Provide 'text' or 'key'"}, status_code=400)


async def api_drag(request: Request) -> JSONResponse:
    """Drag from (x1,y1) to (x2,y2) relative to the target window.

    Body: {"x1": N, "y1": N, "x2": N, "y2": N}
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    x1 = int(body.get("x1", 0))
    y1 = int(body.get("y1", 0))
    x2 = int(body.get("x2", 0))
    y2 = int(body.get("y2", 0))

    success = _drag_window(hwnd, x1, y1, x2, y2)
    add_console_message(f"Drag ({x1},{y1}) -> ({x2},{y2})", "info")
    return JSONResponse({"status": "ok" if success else "failed"})


async def api_move(request: Request) -> JSONResponse:
    """Move the target window to a screen position.

    Body: {"x": N, "y": N}
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    x = int(body.get("x", 0))
    y = int(body.get("y", 0))

    success = _move_window(hwnd, x, y)
    add_console_message(f"Move window to ({x}, {y})", "info")
    return JSONResponse({"status": "ok" if success else "failed"})


async def api_resize(request: Request) -> JSONResponse:
    """Resize the target window.

    Body: {"width": N, "height": N}
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    body = await request.json()
    width = int(body.get("width", 800))
    height = int(body.get("height", 600))

    success = _resize_window(hwnd, width, height)
    add_console_message(f"Resize window to {width}x{height}", "info")
    return JSONResponse({"status": "ok" if success else "failed"})


async def api_window_info(request: Request) -> JSONResponse:
    """Get the target window's position, size, and title.

    Also returns client_offset_x/y which is the pixel offset from the
    window origin to the client area (accounts for title bar + borders).
    To convert a DFM coordinate to screenshot coordinate:
        screenshot_x = client_offset_x + dfm_x
        screenshot_y = client_offset_y + dfm_y
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    left, top, w, h = _get_window_rect(hwnd)
    offset_x, offset_y = _get_client_offset(hwnd)
    return JSONResponse({
        "title": title,
        "hwnd": str(hwnd),
        "x": left, "y": top,
        "width": w, "height": h,
        "client_offset_x": offset_x,
        "client_offset_y": offset_y,
    })


async def api_controls(request: Request) -> JSONResponse:
    """List all child controls (buttons, inputs, labels) of the target window.

    Returns each control's class, text/caption, position, size, and center
    point in client coordinates. Use center_x/center_y with the click
    endpoint (client: true) to click on a specific control.
    """
    hwnd, title = _resolve_target()
    if hwnd is None:
        return JSONResponse({"error": "No target window"}, status_code=400)

    controls = _enum_child_controls(hwnd)
    return JSONResponse({
        "window": title,
        "controls": controls,
        "hint": "Use center_x/center_y with /api/click {client: true} to click a control",
    })


async def api_console(request: Request) -> JSONResponse:
    """Return console output messages."""
    since = int(request.query_params.get("since", "0"))
    with _console_lock:
        lines = list(_console_lines)
    # Return lines after the 'since' index
    return JSONResponse({"lines": lines[since:], "total": len(lines)})


async def api_console_write(request: Request) -> JSONResponse:
    """Add a message to the console (for MCP tools to report status)."""
    body = await request.json()
    text = body.get("text", "")
    level = body.get("level", "info")
    if text:
        add_console_message(text, level)
    return JSONResponse({"status": "ok"})


async def api_launch(request: Request) -> JSONResponse:
    """Launch an executable and start capturing output."""
    body = await request.json()
    exe_path = body.get("exe_path", "")
    title_hint = body.get("title", "")

    if not exe_path:
        return JSONResponse({"error": "exe_path is required"}, status_code=400)

    result = launch_process(exe_path, title_hint)
    return JSONResponse(result)


# ---------------------------------------------------------------------------
# HTML Page
# ---------------------------------------------------------------------------

PAGE_HTML = """\
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Pascal App Preview</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
         background: #1e1e2e; color: #cdd6f4; display: flex; flex-direction: column;
         height: 100vh; overflow: hidden; }
  #toolbar {
    display: flex; align-items: center; gap: 8px; flex-shrink: 0;
    padding: 6px 10px; background: #313244; border-bottom: 1px solid #45475a;
  }
  #toolbar label { font-size: 12px; color: #a6adc8; }
  #toolbar select, #toolbar input, #toolbar button {
    font-size: 12px; padding: 3px 6px; border-radius: 4px; border: 1px solid #585b70;
    background: #1e1e2e; color: #cdd6f4;
  }
  #toolbar button { cursor: pointer; background: #89b4fa; color: #1e1e2e;
                     border-color: #89b4fa; font-weight: 600; }
  #toolbar button:hover { background: #74c7ec; }
  #status { margin-left: auto; font-size: 11px; color: #a6adc8; }

  #main { display: flex; flex: 1; overflow: hidden; }

  #viewer { flex: 1; overflow: auto; display: flex; justify-content: center;
            align-items: flex-start; padding: 8px; }
  #screenshot { cursor: crosshair; max-width: 100%; max-height: 100%;
                image-rendering: auto; border: 1px solid #45475a; }
  #screenshot.no-target { opacity: 0.3; cursor: default; }

  #console-panel {
    width: 100%; max-height: 180px; flex-shrink: 0;
    background: #11111b; border-top: 1px solid #45475a;
    display: flex; flex-direction: column;
  }
  #console-header {
    display: flex; align-items: center; gap: 8px;
    padding: 4px 10px; background: #181825; border-bottom: 1px solid #313244;
    cursor: pointer; user-select: none;
  }
  #console-header span { font-size: 12px; font-weight: 600; color: #a6adc8; }
  #console-header .badge { background: #585b70; color: #cdd6f4; border-radius: 8px;
                            padding: 0 6px; font-size: 10px; min-width: 16px;
                            text-align: center; }
  #console-header .badge.has-errors { background: #f38ba8; color: #11111b; }
  #console-body { overflow-y: auto; flex: 1; padding: 4px 0; font-family: "Cascadia Code",
                   "Fira Code", "Consolas", monospace; font-size: 12px; }
  .log-line { padding: 1px 10px; white-space: pre-wrap; word-break: break-all; }
  .log-line .time { color: #585b70; margin-right: 8px; }
  .log-line.info { color: #cdd6f4; }
  .log-line.error { color: #f38ba8; }
  .log-line.warn { color: #fab387; }
  .log-line.success { color: #a6e3a1; }
</style>
</head>
<body>

<div id="toolbar">
  <label for="windowSelect">Window:</label>
  <select id="windowSelect"><option value="">Loading...</option></select>
  <input id="titleInput" type="text" placeholder="Window title..." size="25">
  <button id="setTargetBtn">Set Target</button>
  <span id="status">No target</span>
</div>

<div id="main">
  <div id="viewer">
    <img id="screenshot" class="no-target" alt="No screenshot yet"
         src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVQI12NgAAIABQABNjN9GQAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAABJRU5ErkJggg==">
  </div>
</div>

<div id="console-panel">
  <div id="console-header">
    <span>Console</span>
    <span class="badge" id="consoleBadge">0</span>
  </div>
  <div id="console-body"></div>
</div>

<script>
const img = document.getElementById("screenshot");
const select = document.getElementById("windowSelect");
const titleInput = document.getElementById("titleInput");
const setBtn = document.getElementById("setTargetBtn");
const statusEl = document.getElementById("status");
const consoleBody = document.getElementById("console-body");
const consoleBadge = document.getElementById("consoleBadge");

let refreshInterval = null;
let imgNaturalW = 0, imgNaturalH = 0;
let consoleLineCount = 0;
let hasErrors = false;

// Set target window
async function setTarget(title) {
  if (!title) return;
  try {
    const resp = await fetch("/api/target", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({title}),
    });
    const data = await resp.json();
    statusEl.textContent = data.target || title;
    img.classList.remove("no-target");
    startRefresh();
  } catch (e) { statusEl.textContent = "Error: " + e.message; }
}

// Refresh screenshot
async function refreshScreenshot() {
  try {
    const resp = await fetch("/api/screenshot?" + Date.now());
    if (!resp.ok) return;
    const blob = await resp.blob();
    const url = URL.createObjectURL(blob);
    const oldUrl = img.src;
    img.src = url;
    if (oldUrl.startsWith("blob:")) URL.revokeObjectURL(oldUrl);
    imgNaturalW = parseInt(resp.headers.get("X-Window-Width") || "0");
    imgNaturalH = parseInt(resp.headers.get("X-Window-Height") || "0");
    statusEl.textContent = resp.headers.get("X-Window-Title") +
      " (" + imgNaturalW + "x" + imgNaturalH + ")";
  } catch (e) { /* skip frame */ }
}

function startRefresh() {
  if (refreshInterval) clearInterval(refreshInterval);
  refreshScreenshot();
  refreshInterval = setInterval(refreshScreenshot, 1000);
}

// Console output polling
async function pollConsole() {
  try {
    const resp = await fetch("/api/console?since=" + consoleLineCount);
    const data = await resp.json();
    if (data.lines.length > 0) {
      for (const line of data.lines) {
        const div = document.createElement("div");
        div.className = "log-line " + line.level;
        div.innerHTML = '<span class="time">' + line.time + '</span>' +
          line.text.replace(/</g, "&lt;").replace(/>/g, "&gt;");
        consoleBody.appendChild(div);
        if (line.level === "error") hasErrors = true;
      }
      consoleBody.scrollTop = consoleBody.scrollHeight;
      consoleLineCount = data.total;
      consoleBadge.textContent = consoleLineCount;
      if (hasErrors) consoleBadge.classList.add("has-errors");
    }
  } catch (e) {}
}

// Poll server for target and window list
let updatingSelect = false;
async function pollTarget() {
  try {
    const resp = await fetch("/api/windows");
    const data = await resp.json();
    updatingSelect = true;
    select.innerHTML = '<option value="">-- select window --</option>';
    for (const w of data.windows) {
      const opt = document.createElement("option");
      opt.value = w.title;
      opt.textContent = w.title;
      if (w.title === data.current_target) opt.selected = true;
      select.appendChild(opt);
    }
    updatingSelect = false;
    if (data.current_target && !refreshInterval) {
      statusEl.textContent = data.current_target;
      img.classList.remove("no-target");
      startRefresh();
    }
  } catch (e) { updatingSelect = false; }
}

// Click on the screenshot -> forward to real window
img.addEventListener("click", async (e) => {
  if (img.classList.contains("no-target")) return;
  const rect = img.getBoundingClientRect();
  const scaleX = imgNaturalW / rect.width;
  const scaleY = imgNaturalH / rect.height;
  const x = Math.round((e.clientX - rect.left) * scaleX);
  const y = Math.round((e.clientY - rect.top) * scaleY);
  try {
    await fetch("/api/click", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({x, y}),
    });
    setTimeout(refreshScreenshot, 300);
  } catch (e) { console.error("Click failed", e); }
});

// UI event handlers
setBtn.addEventListener("click", () => {
  const title = titleInput.value || select.value;
  if (title) setTarget(title);
});
select.addEventListener("change", () => {
  if (select.value && !updatingSelect) {
    titleInput.value = select.value;
    setTarget(select.value);
  }
});

// Auto-select if URL has ?target=...
const params = new URLSearchParams(location.search);
if (params.get("target")) {
  const t = params.get("target");
  titleInput.value = t;
  setTarget(t);
}

// Start polling
pollTarget();
pollConsole();
setInterval(pollTarget, 3000);
setInterval(pollConsole, 1000);
</script>
</body>
</html>
"""


# ---------------------------------------------------------------------------
# Starlette App
# ---------------------------------------------------------------------------

app = Starlette(
    routes=[
        Route("/", homepage),
        Route("/api/screenshot", api_screenshot),
        Route("/api/windows", api_windows),
        Route("/api/target", api_target, methods=["POST"]),
        Route("/api/click", api_click, methods=["POST"]),
        Route("/api/debug-coords", api_debug_coords, methods=["POST"]),
        Route("/api/cursor-test", api_cursor_test, methods=["POST"]),
        Route("/api/type", api_type, methods=["POST"]),
        Route("/api/drag", api_drag, methods=["POST"]),
        Route("/api/move", api_move, methods=["POST"]),
        Route("/api/resize", api_resize, methods=["POST"]),
        Route("/api/window-info", api_window_info),
        Route("/api/controls", api_controls),
        Route("/api/console", api_console),
        Route("/api/console/write", api_console_write, methods=["POST"]),
        Route("/api/launch", api_launch, methods=["POST"]),
    ],
)


def main():
    """Entry point for the preview bridge server."""
    import os
    import uvicorn

    # PORT env var is set by Claude's preview system (autoPort).
    port = int(os.environ.get("PORT", "18080"))

    global _target_title
    target = os.environ.get("PASCAL_PREVIEW_TARGET", "")
    if target:
        _target_title = target

    add_console_message("Pascal Preview Bridge started", "success")
    if target:
        add_console_message(f"Initial target: {target}", "info")

    uvicorn.run(app, host="127.0.0.1", port=port, log_level="warning")


if __name__ == "__main__":
    main()
