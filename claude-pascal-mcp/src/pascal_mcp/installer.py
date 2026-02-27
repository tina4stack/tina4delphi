"""FPC download and installation fallback.

Only used when no Pascal compiler is detected on the system.
Downloads the FPC installer from SourceForge and runs a silent install.
"""

import os
import subprocess
import sys
import tempfile

import httpx

# FPC 3.2.2 combined 32+64-bit installer for Windows
FPC_DOWNLOAD_URL = (
    "https://sourceforge.net/projects/freepascal/files/"
    "Win32/3.2.2/fpc-3.2.2.win32.and.win64.exe/download"
)
FPC_VERSION = "3.2.2"
FPC_DEFAULT_DIR = r"C:\FPC\3.2.2"
FPC_INSTALLER_SIZE_MB = 94  # approximate size for progress reporting


def _get_fpc_exe_path(install_dir: str = FPC_DEFAULT_DIR) -> str:
    """Get the expected FPC executable path after installation."""
    return os.path.join(install_dir, "bin", "x86_64-win64", "fpc.exe")


def _verify_fpc_installation(install_dir: str = FPC_DEFAULT_DIR) -> str | None:
    """Verify FPC is installed and return version, or None if not found."""
    fpc_exe = _get_fpc_exe_path(install_dir)
    if not os.path.exists(fpc_exe):
        # Try 32-bit path
        fpc_exe = os.path.join(install_dir, "bin", "i386-win32", "fpc.exe")
        if not os.path.exists(fpc_exe):
            return None

    try:
        result = subprocess.run(
            [fpc_exe, "-iV"],
            capture_output=True, text=True, timeout=10,
        )
        return result.stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError):
        return None


async def download_and_install_fpc(
    install_dir: str = FPC_DEFAULT_DIR,
) -> dict[str, str]:
    """Download FPC and run a silent installation.

    Args:
        install_dir: Target installation directory. Defaults to C:\\FPC\\3.2.2.

    Returns:
        A dict with keys: status, message, version, path.
    """
    if sys.platform != "win32":
        return {
            "status": "error",
            "message": (
                "Automatic FPC installation is currently only supported on Windows. "
                "On Linux/macOS, install FPC using your package manager:\n"
                "  - Ubuntu/Debian: sudo apt install fpc\n"
                "  - macOS: brew install fpc\n"
                "  - Arch: sudo pacman -S fpc"
            ),
        }

    # Check if already installed
    existing_version = _verify_fpc_installation(install_dir)
    if existing_version:
        return {
            "status": "already_installed",
            "message": f"FPC {existing_version} is already installed.",
            "version": existing_version,
            "path": _get_fpc_exe_path(install_dir),
        }

    # Download the installer
    installer_path = os.path.join(tempfile.gettempdir(), "fpc-installer.exe")

    try:
        async with httpx.AsyncClient(follow_redirects=True, timeout=300) as client:
            response = await client.get(FPC_DOWNLOAD_URL)
            response.raise_for_status()

            with open(installer_path, "wb") as f:
                f.write(response.content)

    except httpx.HTTPError as e:
        return {
            "status": "error",
            "message": f"Failed to download FPC installer: {e}",
        }

    # Run silent installation
    try:
        result = subprocess.run(
            [
                installer_path,
                "/VERYSILENT",
                "/SUPPRESSMSGBOXES",
                "/NORESTART",
                f"/DIR={install_dir}",
                f"/LOG={os.path.join(tempfile.gettempdir(), 'fpc_install.log')}",
            ],
            capture_output=True,
            text=True,
            timeout=300,  # 5 minutes max for installation
        )

        if result.returncode != 0:
            return {
                "status": "error",
                "message": (
                    f"FPC installer exited with code {result.returncode}.\n"
                    f"stdout: {result.stdout}\n"
                    f"stderr: {result.stderr}\n"
                    "You may need to run this with administrator privileges."
                ),
            }

    except subprocess.TimeoutExpired:
        return {
            "status": "error",
            "message": "FPC installation timed out after 5 minutes.",
        }
    finally:
        # Clean up installer
        try:
            os.unlink(installer_path)
        except OSError:
            pass

    # Verify installation
    version = _verify_fpc_installation(install_dir)
    if version:
        return {
            "status": "success",
            "message": f"FPC {version} installed successfully to {install_dir}.",
            "version": version,
            "path": _get_fpc_exe_path(install_dir),
        }
    else:
        return {
            "status": "error",
            "message": (
                f"FPC installer completed but could not verify the installation "
                f"at {install_dir}. Check the install log at "
                f"{os.path.join(tempfile.gettempdir(), 'fpc_install.log')}."
            ),
        }
