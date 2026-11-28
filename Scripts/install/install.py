#!/usr/bin/env python3
"""GEN Framework installer — INSTALL GEN / UPDATE GEN (develop via HTTPS)."""

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


def print_help() -> None:
    script = "install.bat" if os.name == "nt" else "install.bash"
    print(
        f"""
GEN Framework installer

Usage:
  {script} <COMMAND> [TARGET] <absolute_path>

Commands (uppercase):
  INSTALL GEN <absolute_path>
      Create <absolute_path> if needed and clone the develop branch of all
      gen_framework repositories over HTTPS from GitLab.

  UPDATE GEN <absolute_path>
      Require that <absolute_path> already exists, then git pull develop on
      each repository.

Examples:
  Windows:  install.bat INSTALL GEN C:/GENFrameWork
  Linux:    install.bash INSTALL GEN /home/user/genframework

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
    """Return the latest GEN tag on the remote, or None if none / unreachable."""
    cmd = ["git", "ls-remote", "--tags", "--refs", GEN_REPO_URL]
    print(f"  > {' '.join(cmd)}")
    result = subprocess.run(cmd, text=True, capture_output=True)
    if result.returncode != 0:
        err = (result.stderr or "").strip()
        print(f"WARNING: could not list GEN tags ({err or 'unknown error'}).")
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


def show_latest_version() -> None:
    print("Checking latest GEN version (remote tags)...")
    tag = fetch_latest_gen_tag()
    if tag:
        print(f"Latest GEN version available: {format_version_label(tag)}")
    else:
        print("Latest GEN version available: (no tags on remote)")
    print()


def resolve_absolute_path(raw: str) -> Path:
    path = Path(raw).expanduser()
    if not path.is_absolute():
        fail(f"path must be absolute: {raw}")
    return path.resolve()


def repo_url(name: str) -> str:
    return f"{GITLAB_GROUP}/{name.lower()}.git"


def install_gen(root: Path) -> None:
    show_latest_version()
    print(f"INSTALL GEN -> {root}")
    root.mkdir(parents=True, exist_ok=True)

    for name in REPOS:
        dest = root / name
        if dest.exists():
            fail(
                f"'{dest}' already exists. Remove it or use UPDATE GEN on an "
                "existing framework tree."
            )
        print(f"\nCloning {name} ({BRANCH})...")
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

    print(f"\nINSTALL GEN completed: {root}")


def update_gen(root: Path) -> None:
    if not root.exists():
        fail(f"directory does not exist (cannot UPDATE): {root}")
    if not root.is_dir():
        fail(f"not a directory: {root}")

    show_latest_version()
    print(f"UPDATE GEN -> {root}")

    for name in REPOS:
        dest = root / name
        if not dest.is_dir():
            fail(f"missing repository folder: {dest}")
        if not (dest / ".git").exists():
            fail(f"not a git repository: {dest}")

        print(f"\nUpdating {name} ({BRANCH})...")
        run_git(["fetch", "origin"], cwd=dest)
        run_git(["checkout", BRANCH], cwd=dest)
        run_git(["pull", "origin", BRANCH], cwd=dest)

    print(f"\nUPDATE GEN completed: {root}")


def main(argv: list[str]) -> int:
    if len(argv) == 0:
        print_help()
        return 0

    require_git()

    command = argv[0]
    if command != command.upper() or not command.isalpha():
        fail(f"unknown command '{command}'. Commands must be uppercase. Run without args for help.")

    if command == "INSTALL":
        if len(argv) < 3 or argv[1].upper() != "GEN":
            fail("usage: INSTALL GEN <absolute_path>")
        install_gen(resolve_absolute_path(argv[2]))
        return 0

    if command == "UPDATE":
        if len(argv) < 3 or argv[1].upper() != "GEN":
            fail("usage: UPDATE GEN <absolute_path>")
        update_gen(resolve_absolute_path(argv[2]))
        return 0

    fail(f"unknown command '{command}'. Run without args for help.")
    return 1


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        raise SystemExit(130)
