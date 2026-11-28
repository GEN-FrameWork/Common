#!/usr/bin/env python3
"""GEN Framework installer — INSTALL / UPDATE commands (GitLab HTTPS)."""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

GITLAB_GROUP = "https://gitlab.genframework.com/gen_framework"
BRANCH = "develop"

# Local folder names (PascalCase). GitLab project slugs are lowercase.
REPOS = (
    "Common",
    "GEN",
    "ThirdPartyLibraries",
    "Examples",
    "Resources",
    "Tests",
    "Utilities",
    "Documents",
)

GEN_REPO_URL = f"{GITLAB_GROUP}/gen.git"
ANDROID_TARGET = "ANDROID_NDK-SDK"
ANDROID_SCRIPT_REL = Path("Common") / "Scripts" / "android_ndk-sdk"
COMPILE_SCRIPT_REL = Path("Common") / "Scripts" / "compile"
LISTAPP_NAME = "listapp.txt"

# COMPILE target -> path segment in listapp relative paths (None = all apps).
# App names are never hardcoded: each COMPILE run re-reads listapp.txt from
# the destination tree via that tree's compile loader.
COMPILE_TARGETS: dict[str, str | None] = {
    "EXAMPLES": "Examples",
    "TESTS": "Tests",
    "UTILITIES": "Utilities",
    "ALL": None,
}


def print_help() -> None:
    script = "install.bat" if os.name == "nt" else "install.bash"
    print(
        f"""
GEN Framework installer

Usage:
  {script} <COMMAND> <TARGET> <absolute_path>

Commands (uppercase):
  INSTALL GEN <absolute_path>
      Create <absolute_path> if needed and clone the develop branch of all
      gen_framework repositories over HTTPS from GitLab.

  UPDATE GEN <absolute_path>
      Require that <absolute_path> already exists, then git pull develop on
      each repository.

  INSTALL ANDROID_NDK-SDK <absolute_path>
      Install the Android SDK/NDK for the current host OS (Windows or Linux)
      into <absolute_path>/ThirdPartyLibraries. Requires that ThirdPartyLibraries
      already exists. Uses Common/Scripts/android_ndk-sdk from that tree.

  COMPILE EXAMPLES|TESTS|UTILITIES|ALL <absolute_path>
      Compile selected applications from listapp.txt via Common/Scripts/compile
      (compile.bat / compile.bash). On Linux, compile is invoked with DOCKER.
      Android is included automatically when the matching SDK/NDK is installed.
      EXAMPLES / TESTS / UTILITIES filter by repo folder; ALL compiles every
      entry in listapp.txt.

Examples:
  Windows:  install.bat INSTALL GEN C:/GENFrameWork
            install.bat UPDATE GEN C:/GENFrameWork
            install.bat INSTALL ANDROID_NDK-SDK C:/GENFrameWork
            install.bat COMPILE EXAMPLES C:/GENFrameWork
            install.bat COMPILE TESTS C:/GENFrameWork
            install.bat COMPILE UTILITIES C:/GENFrameWork
            install.bat COMPILE ALL C:/GENFrameWork
  Linux:    install.bash INSTALL GEN /home/user/genframework
            install.bash UPDATE GEN /home/user/genframework
            install.bash INSTALL ANDROID_NDK-SDK /home/user/genframework
            install.bash COMPILE EXAMPLES /home/user/genframework
            install.bash COMPILE ALL /home/user/genframework

Repositories ({BRANCH} via HTTPS):
  {", ".join(REPOS)}

Source: {GITLAB_GROUP}
""".strip()
    )


def fail(message: str, code: int = 1) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(code)


def require_git() -> None:
    if shutil.which("git") is None:
        fail("git is not available in PATH. Install Git and retry.")


def run_git(args: list[str], *, cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    cmd = ["git", *args]
    print(f"  > {' '.join(cmd)}")
    result = subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        text=True,
        capture_output=True,
    )
    if result.stdout.strip():
        print(result.stdout.rstrip())
    if result.returncode != 0:
        err = (result.stderr or result.stdout or "").strip()
        fail(f"git {' '.join(args)} failed" + (f":\n{err}" if err else "."))
    elif result.stderr.strip():
        # git often writes progress to stderr even on success
        print(result.stderr.rstrip())
    return result


def version_sort_key(tag: str) -> tuple:
    """Numeric key from tag name (handles Version_0.30_0_..., Version.0.26.0_...)."""
    nums = [int(n) for n in re.findall(r"\d+", tag)]
    return tuple(nums) if nums else (0,)


def format_version_label(tag: str) -> str:
    """Display tag without Version/Vertion prefix; underscores become spaces."""
    label = re.sub(r"(?i)^ver(?:s|t)ion[._]*", "", tag)
    return label.replace("_", " ").strip()


def fetch_latest_gen_tag() -> str | None:
    """Return the latest GEN tag on the remote, or None if none / unreachable.

    Silent on success; prints a warning only when the query fails.
    """
    cmd = ["git", "ls-remote", "--tags", "--refs", GEN_REPO_URL]
    result = subprocess.run(cmd, text=True, capture_output=True)
    if result.returncode != 0:
        err = (result.stderr or "").strip()
        print(f"WARNING: could not list GEN tags ({err or 'unknown error'}).")
        print(f"  > {' '.join(cmd)}")
        return None

    tags: list[str] = []
    for line in result.stdout.splitlines():
        line = line.strip()
        if not line:
            continue
        # <sha>\trefs/tags/<name>
        parts = line.split()
        if len(parts) < 2:
            continue
        ref = parts[-1]
        prefix = "refs/tags/"
        if ref.startswith(prefix):
            tags.append(ref[len(prefix) :])

    if not tags:
        return None
    return max(tags, key=version_sort_key)


def print_gen_operation_header(operation: str, root: Path) -> None:
    """Blank line, version + operation lines, blank line."""
    tag = fetch_latest_gen_tag()
    label = format_version_label(tag) if tag else "(no tags on remote)"
    print()
    print(f"Latest GEN version available: {label}")
    print(f"{operation} -> {root}")
    print()


def resolve_absolute_path(raw: str) -> Path:
    path = Path(raw).expanduser()
    if not path.is_absolute():
        fail(f"path must be absolute: {raw}")
    return path.resolve()


def repo_url(name: str) -> str:
    return f"{GITLAB_GROUP}/{name.lower()}.git"


def install_gen(root: Path) -> None:
    print_gen_operation_header("INSTALL GEN", root)
    root.mkdir(parents=True, exist_ok=True)

    for name in REPOS:
        dest = root / name
        if dest.exists():
            fail(
                f"'{dest}' already exists. Remove it or use UPDATE GEN on an "
                "existing framework tree."
            )
        print(f"Cloning {name} ({BRANCH})...")
        run_git(
            [
                "clone",
                "--branch",
                BRANCH,
                "--single-branch",
                repo_url(name),
                str(dest),
            ]
        )
        print()

    print(f"INSTALL GEN completed: {root}")


def update_gen(root: Path) -> None:
    if not root.exists():
        fail(f"directory does not exist (cannot UPDATE): {root}")
    if not root.is_dir():
        fail(f"not a directory: {root}")

    print_gen_operation_header("UPDATE GEN", root)

    for name in REPOS:
        dest = root / name
        if not dest.is_dir():
            fail(f"missing repository folder: {dest}")
        if not (dest / ".git").exists():
            fail(f"not a git repository: {dest}")

        print(f"Updating {name} ({BRANCH})...")
        run_git(["fetch", "origin"], cwd=dest)
        run_git(["checkout", BRANCH], cwd=dest)
        run_git(["pull", "origin", BRANCH], cwd=dest)
        print()

    print(f"UPDATE GEN completed: {root}")


def android_installer_script(root: Path) -> Path:
    folder = root / ANDROID_SCRIPT_REL
    if os.name == "nt":
        return folder / "InstallAndroidNDK-SDK.bat"
    return folder / "InstallAndroidNDK-SDK.bash"


def install_android_ndk_sdk(root: Path) -> None:
    third_party = root / "ThirdPartyLibraries"
    if not third_party.is_dir():
        fail(
            f"ThirdPartyLibraries not found under '{root}'. "
            "Run INSTALL GEN first (or pass a framework tree that already has it)."
        )

    script = android_installer_script(root)
    if not script.is_file():
        fail(
            f"Android installer script not found: {script}. "
            "Ensure Common/Scripts/android_ndk-sdk is present in that tree."
        )

    host = "Windows" if os.name == "nt" else "Linux"
    print()
    print(f"INSTALL ANDROID_NDK-SDK ({host}) -> {third_party}")
    print(f"  using {script}")
    print()

    if os.name == "nt":
        cmd = ["cmd", "/c", str(script)]
    else:
        cmd = ["bash", str(script)]

    result = subprocess.run(cmd, cwd=str(script.parent))
    if result.returncode != 0:
        fail(f"Android NDK/SDK installer failed with exit code {result.returncode}.")

    print()
    print(f"INSTALL ANDROID_NDK-SDK completed: {third_party}")


def compile_script(root: Path) -> Path:
    folder = root / COMPILE_SCRIPT_REL
    if os.name == "nt":
        return folder / "compile.bat"
    return folder / "compile.bash"


def load_listapp_entries(compile_dir: Path, listapp_path: Path) -> list:
    """Load apps with the destination tree's compile loader (live listapp.txt)."""
    shared_path = compile_dir / "internal" / "shared.py"
    if not shared_path.is_file():
        fail(f"compile shared module not found: {shared_path}")

    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "gen_install_compile_shared",
        shared_path,
    )
    if spec is None or spec.loader is None:
        fail(f"unable to load compile shared module: {shared_path}")

    module = importlib.util.module_from_spec(spec)
    # dataclasses require the module to be present in sys.modules during exec.
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module.load_listapp(listapp_path)


def apps_for_compile_target(compile_dir: Path, listapp_path: Path, target: str) -> list[str]:
    """Filter the current listapp.txt by Examples / Tests / Utilities / ALL."""
    entries = load_listapp_entries(compile_dir, listapp_path)
    if not entries:
        fail(f"no applications found in {listapp_path}")

    folder = COMPILE_TARGETS[target]
    if folder is None:
        return [entry.name for entry in entries]

    marker = f"/{folder}/"
    selected = [
        entry.name
        for entry in entries
        if marker in entry.relative_path.replace("\\", "/")
    ]
    if not selected:
        fail(f"no {target} applications found in {listapp_path}")
    return selected


def compile_apps(root: Path, target: str) -> None:
    if target not in COMPILE_TARGETS:
        fail(
            f"unknown COMPILE target '{target}'. "
            f"Use {'|'.join(COMPILE_TARGETS)}."
        )

    if not root.is_dir():
        fail(f"directory does not exist: {root}")

    compile_dir = root / COMPILE_SCRIPT_REL
    script = compile_script(root)
    listapp_path = compile_dir / LISTAPP_NAME

    if not script.is_file():
        fail(
            f"compile script not found: {script}. "
            "Ensure Common/Scripts/compile is present in that tree."
        )
    if not listapp_path.is_file():
        fail(f"listapp not found: {listapp_path}")

    # Always re-read listapp.txt from the destination tree at call time.
    app_names = apps_for_compile_target(compile_dir, listapp_path, target)
    host = "Windows" if os.name == "nt" else "Linux"
    # Linux builds go through the compile DOCKER path; Windows is native.
    compile_args = [*app_names] if os.name == "nt" else ["DOCKER", *app_names]

    print()
    print(f"COMPILE {target} ({host}) -> {root}")
    print(f"  using {script}")
    print(f"  listapp: {listapp_path}")
    print(f"  compile args: {' '.join(compile_args)}")
    print(f"  applications ({len(app_names)}): {' '.join(app_names)}")
    print()

    if os.name == "nt":
        cmd = ["cmd", "/c", str(script), *compile_args]
    else:
        cmd = ["bash", str(script), *compile_args]

    # cwd must be the compile directory so PATHLISTAPP / listapp resolve correctly.
    result = subprocess.run(cmd, cwd=str(compile_dir))
    if result.returncode != 0:
        fail(f"COMPILE {target} failed with exit code {result.returncode}.")

    print()
    print(f"COMPILE {target} completed: {root}")


def main(argv: list[str]) -> int:
    if len(argv) == 0:
        print_help()
        return 0

    command = argv[0]
    if command != command.upper():
        fail(f"unknown command '{command}'. Commands must be uppercase. Run without args for help.")

    if command == "INSTALL":
        if len(argv) < 3:
            fail("usage: INSTALL GEN|ANDROID_NDK-SDK <absolute_path>")
        target = argv[1]
        path = resolve_absolute_path(argv[2])
        if target == "GEN":
            require_git()
            install_gen(path)
            return 0
        if target == ANDROID_TARGET:
            install_android_ndk_sdk(path)
            return 0
        fail(f"unknown INSTALL target '{target}'. Use GEN or ANDROID_NDK-SDK.")

    if command == "UPDATE":
        if len(argv) < 3 or argv[1] != "GEN":
            fail("usage: UPDATE GEN <absolute_path>")
        require_git()
        update_gen(resolve_absolute_path(argv[2]))
        return 0

    if command == "COMPILE":
        if len(argv) < 3:
            fail(f"usage: COMPILE {'|'.join(COMPILE_TARGETS)} <absolute_path>")
        target = argv[1]
        path = resolve_absolute_path(argv[2])
        compile_apps(path, target)
        return 0

    fail(f"unknown command '{command}'. Run without args for help.")
    return 1


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        raise SystemExit(130)
