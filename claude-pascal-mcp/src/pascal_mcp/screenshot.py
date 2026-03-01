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
    """Bring a window to the foreground so it can be captured cleanly."""
    SW_RESTORE = 9
    if ctypes.windll.user32.IsIconic(hwnd):
        ctypes.windll.user32.ShowWindow(hwnd, SW_RESTORE)

    ctypes.windll.user32.SetForegroundWindow(hwnd)
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


def capture_window(title: str) -> tuple[str, str, int, int] | None:
    """Capture a screenshot of a specific window by title.

    Finds the window, brings it to the foreground, and uses PrintWindow
    to capture the window content directly (avoiding DPI issues).

    Args:
        title: Full or partial window title to capture (case-insensitive).

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

    # Bring to front so it paints
    _bring_window_to_front(hwnd)

    # Capture using PrintWindow API
    img = _capture_with_printwindow(hwnd)
    if img is None:
        return None

    width, height = img.size

    # Convert to base64 PNG
    buffer = io.BytesIO()
    img.save(buffer, format="PNG", optimize=True)
    b64_data = base64.standard_b64encode(buffer.getvalue()).decode("ascii")

    return (b64_data, actual_title, width, height)
