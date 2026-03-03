"""Window screenshot capture for running Pascal applications.

Uses the Windows API to find a window by title and capture just
that window using PrintWindow — no DPI scaling issues.
"""

from __future__ import annotations

import base64
import ctypes
import ctypes.wintypes
import io
import sys
import time

from PIL import Image


# Enable DPI awareness so we get real pixel coordinates
if sys.platform == "win32":
    try:
        ctypes.windll.shcore.SetProcessDpiAwareness(2)  # Per-monitor DPI aware
    except Exception:
        try:
            ctypes.windll.user32.SetProcessDPIAware()
        except Exception:
            pass


def _find_window_by_title(title: str) -> int | None:
    """Find a window handle by (partial) title match.

    Args:
        title: Full or partial window title to search for (case-insensitive).

    Returns:
        The window handle (HWND), or None if not found.
    """
    if sys.platform != "win32":
        return None

    results: list[tuple[int, str]] = []

    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.wintypes.HWND, ctypes.wintypes.LPARAM)
    def enum_callback(hwnd, lparam):
        length = ctypes.windll.user32.GetWindowTextLengthW(hwnd)
        if length > 0:
            buf = ctypes.create_unicode_buffer(length + 1)
            ctypes.windll.user32.GetWindowTextW(hwnd, buf, length + 1)
            window_title = buf.value
            if title.lower() in window_title.lower():
                if ctypes.windll.user32.IsWindowVisible(hwnd):
                    results.append((hwnd, window_title))
        return True

    ctypes.windll.user32.EnumWindows(enum_callback, 0)

    if not results:
        return None

    # Exact match first, then first partial
    for hwnd, window_title in results:
        if window_title.lower() == title.lower():
            return hwnd
    return results[0][0]


def _get_window_title(hwnd: int) -> str:
    """Get the title of a window by handle."""
    length = ctypes.windll.user32.GetWindowTextLengthW(hwnd)
    buf = ctypes.create_unicode_buffer(length + 1)
    ctypes.windll.user32.GetWindowTextW(hwnd, buf, length + 1)
    return buf.value


def _bring_window_to_front(hwnd: int) -> None:
    """Bring a window to the foreground reliably.

    Uses AttachThreadInput to temporarily connect our thread to the
    target window's thread, which allows SetForegroundWindow to work
    even when our process is not the current foreground process.
    """
    user32 = ctypes.windll.user32
    kernel32 = ctypes.windll.kernel32

    SW_RESTORE = 9
    if user32.IsIconic(hwnd):
        user32.ShowWindow(hwnd, SW_RESTORE)

    # Get thread IDs
    our_thread = kernel32.GetCurrentThreadId()
    target_thread = user32.GetWindowThreadProcessId(hwnd, None)

    # Attach our thread input to the target's thread
    attached = False
    if our_thread != target_thread:
        attached = bool(user32.AttachThreadInput(our_thread, target_thread, True))

    try:
        user32.BringWindowToTop(hwnd)
        user32.SetForegroundWindow(hwnd)
        # Also set focus at the Win32 level
        user32.SetFocus(hwnd)
    finally:
        if attached:
            user32.AttachThreadInput(our_thread, target_thread, False)

    time.sleep(0.3)


def _capture_with_printwindow(hwnd: int) -> Image.Image | None:
    """Capture a window using the Win32 PrintWindow API.

    This captures the window content directly from the window manager,
    avoiding DPI scaling issues with screen coordinates.
    """
    # Get window dimensions
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    width = rect.right - rect.left
    height = rect.bottom - rect.top

    if width <= 0 or height <= 0:
        return None

    # Create a device context and bitmap
    hwnd_dc = ctypes.windll.user32.GetWindowDC(hwnd)
    if not hwnd_dc:
        return None

    try:
        mem_dc = ctypes.windll.gdi32.CreateCompatibleDC(hwnd_dc)
        if not mem_dc:
            return None

        try:
            bitmap = ctypes.windll.gdi32.CreateCompatibleBitmap(hwnd_dc, width, height)
            if not bitmap:
                return None

            try:
                ctypes.windll.gdi32.SelectObject(mem_dc, bitmap)

                # PrintWindow with PW_RENDERFULLCONTENT (flag 2) for best results
                PW_RENDERFULLCONTENT = 2
                result = ctypes.windll.user32.PrintWindow(hwnd, mem_dc, PW_RENDERFULLCONTENT)

                if not result:
                    # Fallback: try without the flag
                    result = ctypes.windll.user32.PrintWindow(hwnd, mem_dc, 0)

                if not result:
                    return None

                # Read bitmap data into a PIL Image
                # Set up BITMAPINFOHEADER
                class BITMAPINFOHEADER(ctypes.Structure):
                    _fields_ = [
                        ("biSize", ctypes.c_uint32),
                        ("biWidth", ctypes.c_int32),
                        ("biHeight", ctypes.c_int32),
                        ("biPlanes", ctypes.c_uint16),
                        ("biBitCount", ctypes.c_uint16),
                        ("biCompression", ctypes.c_uint32),
                        ("biSizeImage", ctypes.c_uint32),
                        ("biXPelsPerMeter", ctypes.c_int32),
                        ("biYPelsPerMeter", ctypes.c_int32),
                        ("biClrUsed", ctypes.c_uint32),
                        ("biClrImportant", ctypes.c_uint32),
                    ]

                bmi = BITMAPINFOHEADER()
                bmi.biSize = ctypes.sizeof(BITMAPINFOHEADER)
                bmi.biWidth = width
                bmi.biHeight = -height  # Negative = top-down DIB
                bmi.biPlanes = 1
                bmi.biBitCount = 32
                bmi.biCompression = 0  # BI_RGB

                # Allocate buffer for pixel data
                buf_size = width * height * 4
                buf = ctypes.create_string_buffer(buf_size)

                ctypes.windll.gdi32.GetDIBits(
                    mem_dc, bitmap, 0, height,
                    buf, ctypes.byref(bmi), 0  # DIB_RGB_COLORS
                )

                # Convert BGRA to RGBA
                img = Image.frombuffer("RGBA", (width, height), buf, "raw", "BGRA", 0, 1)
                # Convert to RGB (drop alpha)
                return img.convert("RGB")

            finally:
                ctypes.windll.gdi32.DeleteObject(bitmap)
        finally:
            ctypes.windll.gdi32.DeleteDC(mem_dc)
    finally:
        ctypes.windll.user32.ReleaseDC(hwnd, hwnd_dc)


def get_window_rect(hwnd: int) -> tuple[int, int, int, int]:
    """Get the window rectangle in physical pixels (DPI-aware).

    Returns:
        Tuple of (left, top, right, bottom) in screen coordinates.
    """
    rect = ctypes.wintypes.RECT()
    ctypes.windll.user32.GetWindowRect(hwnd, ctypes.byref(rect))
    return (rect.left, rect.top, rect.right, rect.bottom)


def get_dpi_scale(hwnd: int) -> float:
    """Get the DPI scale factor for a window.

    Returns:
        Scale factor (e.g. 1.5 for 150% scaling). Falls back to 1.0.
    """
    if sys.platform != "win32":
        return 1.0
    try:
        # GetDpiForWindow (Windows 10 1607+)
        dpi = ctypes.windll.user32.GetDpiForWindow(hwnd)
        if dpi > 0:
            return dpi / 96.0
    except Exception:
        pass
    try:
        # Fallback: monitor DPI
        monitor = ctypes.windll.user32.MonitorFromWindow(hwnd, 1)
        dpi_x = ctypes.c_uint()
        ctypes.windll.shcore.GetDpiForMonitor(
            monitor, 0, ctypes.byref(dpi_x), ctypes.byref(ctypes.c_uint())
        )
        if dpi_x.value > 0:
            return dpi_x.value / 96.0
    except Exception:
        pass
    return 1.0


def _find_child_at_point(hwnd: int, x: int, y: int) -> int:
    """Find the deepest child window at a client-area point.

    Args:
        hwnd: Parent window handle.
        x, y: Coordinates in the parent's client area.

    Returns:
        Handle of the deepest child window at that point, or hwnd if none.
    """
    user32 = ctypes.windll.user32

    # Convert client coords to screen coords
    point = ctypes.wintypes.POINT(x, y)
    user32.ClientToScreen(hwnd, ctypes.byref(point))

    # Find the deepest child at this screen point
    child = user32.WindowFromPoint(point)
    if child and child != hwnd:
        return child
    return hwnd


def _make_lparam(x: int, y: int) -> int:
    """Pack x,y into an LPARAM (low word = x, high word = y)."""
    return (y << 16) | (x & 0xFFFF)


def click_window(
    title: str,
    x: int,
    y: int,
    double_click: bool = False,
) -> str | None:
    """Click at a position within a window, using screenshot pixel coordinates.

    The x,y coordinates are in screenshot pixel space (what you see in the
    screenshot image). Sends WM_LBUTTONDOWN/UP messages directly to the
    target child control — does NOT require foreground focus.

    Args:
        title: Window title to find (case-insensitive partial match).
        x: X coordinate in screenshot pixels (from left edge of window).
        y: Y coordinate in screenshot pixels (from top edge of window).
        double_click: If True, perform a double-click.

    Returns:
        Success message, or error string.
    """
    if sys.platform != "win32":
        return "click_window is only supported on Windows"

    hwnd = _find_window_by_title(title)
    if hwnd is None:
        return None

    user32 = ctypes.windll.user32
    actual_title = _get_window_title(hwnd)
    dpi_scale = get_dpi_scale(hwnd)

    # Screenshot pixels -> client area pixels (account for DPI)
    client_x = int(x / dpi_scale)
    client_y = int(y / dpi_scale)

    # Find the child control at this position
    child = _find_child_at_point(hwnd, client_x, client_y)

    # Convert parent client coords to child client coords
    parent_point = ctypes.wintypes.POINT(client_x, client_y)
    user32.ClientToScreen(hwnd, ctypes.byref(parent_point))
    child_point = ctypes.wintypes.POINT(parent_point.x, parent_point.y)
    user32.ScreenToClient(child, ctypes.byref(child_point))

    lparam = _make_lparam(child_point.x, child_point.y)

    # Send mouse messages directly to the child control
    WM_LBUTTONDOWN = 0x0201
    WM_LBUTTONUP = 0x0202
    WM_LBUTTONDBLCLK = 0x0203
    MK_LBUTTON = 0x0001

    if double_click:
        user32.PostMessageW(child, WM_LBUTTONDOWN, MK_LBUTTON, lparam)
        time.sleep(0.02)
        user32.PostMessageW(child, WM_LBUTTONUP, 0, lparam)
        time.sleep(0.02)
        user32.PostMessageW(child, WM_LBUTTONDBLCLK, MK_LBUTTON, lparam)
        time.sleep(0.02)
        user32.PostMessageW(child, WM_LBUTTONUP, 0, lparam)
    else:
        user32.PostMessageW(child, WM_LBUTTONDOWN, MK_LBUTTON, lparam)
        time.sleep(0.02)
        user32.PostMessageW(child, WM_LBUTTONUP, 0, lparam)

    # Also set focus to the child (for keyboard input)
    # Use WM_SETFOCUS via the parent, and SetFocus via AttachThreadInput
    kernel32 = ctypes.windll.kernel32
    our_thread = kernel32.GetCurrentThreadId()
    target_thread = user32.GetWindowThreadProcessId(child, None)
    attached = False
    if our_thread != target_thread:
        attached = bool(user32.AttachThreadInput(our_thread, target_thread, True))
    try:
        user32.SetFocus(child)
    finally:
        if attached:
            user32.AttachThreadInput(our_thread, target_thread, False)

    time.sleep(0.3)

    child_class = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(child, child_class, 256)

    return (
        f"Clicked '{actual_title}' at screenshot ({x},{y}) -> "
        f"child 0x{child:X} ({child_class.value}) at ({child_point.x},{child_point.y}) "
        f"[DPI: {dpi_scale}]"
    )


def type_in_window(
    title: str,
    text: str,
    clear_first: bool = False,
) -> str | None:
    """Type text into the focused control of a window.

    Sends WM_CHAR messages directly to the window — does NOT require
    foreground focus. Use click_window first to focus a specific control.

    Args:
        title: Window title to find (case-insensitive partial match).
        text: The text to type.
        clear_first: If True, send Ctrl+A + Delete first to clear existing text.

    Returns:
        Success message, or None if window not found.
    """
    if sys.platform != "win32":
        return "type_in_window is only supported on Windows"

    hwnd = _find_window_by_title(title)
    if hwnd is None:
        return None

    user32 = ctypes.windll.user32
    actual_title = _get_window_title(hwnd)

    # Find the currently focused child within this window
    # Use AttachThreadInput to query focus from the target thread
    kernel32 = ctypes.windll.kernel32
    our_thread = kernel32.GetCurrentThreadId()
    target_thread = user32.GetWindowThreadProcessId(hwnd, None)

    target_control = hwnd
    attached = False
    if our_thread != target_thread:
        attached = bool(user32.AttachThreadInput(our_thread, target_thread, True))
    try:
        focused = user32.GetFocus()
        if focused:
            target_control = focused
    finally:
        if attached:
            user32.AttachThreadInput(our_thread, target_thread, False)

    WM_CHAR = 0x0102
    WM_KEYDOWN = 0x0100
    WM_KEYUP = 0x0101

    if clear_first:
        # Use EM_SETSEL to select all text, then delete it
        EM_SETSEL = 0x00B1
        VK_DELETE = 0x2E
        user32.SendMessageW(target_control, EM_SETSEL, 0, -1)  # Select all
        time.sleep(0.02)
        user32.PostMessageW(target_control, WM_KEYDOWN, VK_DELETE, 0)
        user32.PostMessageW(target_control, WM_KEYUP, VK_DELETE, 0)
        time.sleep(0.05)

    # Send each character via WM_CHAR
    for ch in text:
        user32.PostMessageW(target_control, WM_CHAR, ord(ch), 0)
        time.sleep(0.01)

    target_class = ctypes.create_unicode_buffer(256)
    user32.GetClassNameW(target_control, target_class, 256)

    return (
        f"Typed {len(text)} char(s) into '{actual_title}' "
        f"control 0x{target_control:X} ({target_class.value})"
    )


def list_windows(filter_text: str = "") -> list[dict[str, str]]:
    """List visible windows, optionally filtered by title.

    Args:
        filter_text: Optional text to filter window titles (case-insensitive).

    Returns:
        List of dicts with 'hwnd' and 'title' keys.
    """
    if sys.platform != "win32":
        return []

    windows: list[dict[str, str]] = []

    @ctypes.WINFUNCTYPE(ctypes.c_bool, ctypes.wintypes.HWND, ctypes.wintypes.LPARAM)
    def enum_callback(hwnd, lparam):
        if ctypes.windll.user32.IsWindowVisible(hwnd):
            length = ctypes.windll.user32.GetWindowTextLengthW(hwnd)
            if length > 0:
                buf = ctypes.create_unicode_buffer(length + 1)
                ctypes.windll.user32.GetWindowTextW(hwnd, buf, length + 1)
                window_title = buf.value
                if not filter_text or filter_text.lower() in window_title.lower():
                    windows.append({
                        "hwnd": str(hwnd),
                        "title": window_title,
                    })
        return True

    ctypes.windll.user32.EnumWindows(enum_callback, 0)
    return windows


def capture_window(
    title: str,
    bring_to_front: bool = False,
) -> tuple[str, str, int, int] | None:
    """Capture a screenshot of a specific window by title.

    Uses PrintWindow to capture the window content directly without
    needing to bring it to the foreground — this avoids stealing focus
    and disrupting the user's desktop experience.

    Args:
        title: Full or partial window title to capture (case-insensitive).
        bring_to_front: If True, bring the window to the foreground first.
            Default False to avoid disrupting the user.

    Returns:
        Tuple of (base64_png_data, window_title, width, height),
        or None if the window was not found.
    """
    if sys.platform != "win32":
        return None

    hwnd = _find_window_by_title(title)
    if hwnd is None:
        return None

    actual_title = _get_window_title(hwnd)

    # Only bring to front if explicitly requested (e.g. before a click)
    if bring_to_front:
        _bring_window_to_front(hwnd)

    # Capture using PrintWindow API (works without foreground)
    img = _capture_with_printwindow(hwnd)
    if img is None:
        return None

    width, height = img.size

    # Convert to base64 PNG
    buffer = io.BytesIO()
    img.save(buffer, format="PNG", optimize=True)
    b64_data = base64.standard_b64encode(buffer.getvalue()).decode("ascii")

    return (b64_data, actual_title, width, height)
