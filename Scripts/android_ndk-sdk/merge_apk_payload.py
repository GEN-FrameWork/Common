#!/usr/bin/env python3
"""Insert lib/ and assets/ from a package dir into an unaligned APK.

Used by GEN_Main_Android_BuildPackage.cmake on hosts without PowerShell
(Linux). Mirrors the PowerShell ZipArchive merge used on Windows.
"""

from __future__ import annotations

import os
import shutil
import sys
import tempfile
import zipfile


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        print("Usage: merge_apk_payload.py <unaligned.apk> <package_dir>", file=sys.stderr)
        return 2

    apk = os.path.abspath(argv[1])
    pkg = os.path.abspath(argv[2])
    pkg_root = pkg if pkg.endswith(os.sep) else pkg + os.sep

    adds: dict[str, str] = {}
    for top in ("lib", "assets"):
        root = os.path.join(pkg, top)
        if not os.path.isdir(root):
            continue
        for dirpath, _dirnames, filenames in os.walk(root):
            for name in filenames:
                full = os.path.abspath(os.path.join(dirpath, name))
                if not full.startswith(pkg_root):
                    raise SystemExit(f"Entry outside the package directory: {full}")
                rel = full[len(pkg_root) :].replace(os.sep, "/")
                adds[rel] = full

    fd, tmp = tempfile.mkstemp(suffix=".apk")
    os.close(fd)
    try:
        with zipfile.ZipFile(apk, "r") as zin, zipfile.ZipFile(tmp, "w") as zout:
            skip = set(adds.keys())
            for info in zin.infolist():
                if info.filename in skip:
                    continue
                zout.writestr(info, zin.read(info.filename))
            for rel, full in sorted(adds.items()):
                compress = zipfile.ZIP_STORED if rel.startswith("lib/") else zipfile.ZIP_DEFLATED
                zout.write(full, rel, compress_type=compress)
        shutil.move(tmp, apk)
    finally:
        if os.path.exists(tmp):
            os.remove(tmp)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
