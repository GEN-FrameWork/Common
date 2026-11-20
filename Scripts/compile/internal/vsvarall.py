\
#!/usr/bin/env python3
"""Prepare a Visual Studio environment by calling vcvarsall.bat.

This helper is intended to live under internal/ and be reusable from other
Python scripts. It also supports standalone execution.

Default environment inputs:
- TARGET
- USE_CLANG_EXTCFG
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, Optional

SUPPORTED_YEARS = ("2022",)
SUPPORTED_EDITIONS = ("Community", "Professional", "Enterprise")
SUPPORTED_TARGETS = ("INTEL32", "INTEL64", "ANDROID32", "ANDROID64")
SUPPORTED_COMPILERS = ("MSC", "CLANG")


@dataclass(frozen=True)
class VSResolution:
    year: str
    edition: str
    compiler: str
    target: str
    vcplatform: str
    vcvarsall_bat: Path


def normalize_target(target: Optional[str]) -> str:
    value = (target or os.environ.get("TARGET", "INTEL64")).strip().upper()
    if value not in SUPPORTED_TARGETS:
        raise ValueError(f"Unsupported TARGET: {value}")
    return value


def normalize_compiler(compiler: Optional[str]) -> str:
    if compiler:
        value = compiler.strip().upper()
    else:
        # Match compile.py: clang-cl unless the batch explicitly asked for MSVC.
        use_clang = os.environ.get("USE_CLANG_EXTCFG", "").strip().upper()
        value = "MSC" if use_clang == "NOTCLANG" else "CLANG"

    if value not in SUPPORTED_COMPILERS:
        raise ValueError(f"Unsupported compiler: {value}")
    return value


def detect_vs_edition(year: str = "2022", base_dir: Optional[Path] = None) -> str:
    if year not in SUPPORTED_YEARS:
        raise ValueError(f"Unsupported Visual Studio year: {year}")

    root = base_dir or Path(r"C:\Program Files\Microsoft Visual Studio") / year
    detected: list[str] = []

    for edition in SUPPORTED_EDITIONS:
        if (root / edition).exists():
            detected.append(edition)

    if detected:
        return detected[-1]

    return "Enterprise"


def determine_vcplatform(target: str, compiler: str) -> str:
    normalized_target = normalize_target(target)
    _ = normalize_compiler(compiler)

    mapping = {
        "INTEL32": "amd64_x86",
        "INTEL64": "amd64",
        "ANDROID32": "amd64",
        "ANDROID64": "amd64",
    }
    return mapping[normalized_target]


def find_vcvarsall_bat(year: str = "2022", edition: Optional[str] = None) -> Path:
    resolved_edition = edition or detect_vs_edition(year)
    vcvarsall_bat = (
        Path(r"C:\Program Files\Microsoft Visual Studio")
        / year
        / resolved_edition
        / "VC"
        / "Auxiliary"
        / "Build"
        / "vcvarsall.bat"
    )
    if not vcvarsall_bat.exists():
        raise FileNotFoundError(f"vcvarsall.bat not found: {vcvarsall_bat}")
    return vcvarsall_bat


def resolve_vs_environment(
    target: Optional[str] = None,
    compiler: Optional[str] = None,
    year: str = "2022",
    edition: Optional[str] = None,
) -> VSResolution:
    normalized_target = normalize_target(target)
    normalized_compiler = normalize_compiler(compiler)
    resolved_edition = edition or detect_vs_edition(year)
    vcplatform = determine_vcplatform(normalized_target, normalized_compiler)
    vcvarsall_bat = find_vcvarsall_bat(year=year, edition=resolved_edition)

    return VSResolution(
        year=year,
        edition=resolved_edition,
        compiler=normalized_compiler,
        target=normalized_target,
        vcplatform=vcplatform,
        vcvarsall_bat=vcvarsall_bat,
    )


def parse_set_output(output: str) -> Dict[str, str]:
    environment: Dict[str, str] = {}
    for line in output.splitlines():
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        if key:
            environment[key] = value
    return environment


def capture_vcvars_environment(resolution: VSResolution) -> Dict[str, str]:
    if os.name != "nt":
        raise OSError("vsvarall.py only executes vcvarsall.bat on Windows")

    script_content = "\r\n".join([
        "@echo off",
        f'call "{resolution.vcvarsall_bat}" {resolution.vcplatform}',
        "if errorlevel 1 exit /b %errorlevel%",
        "set",
        "",
    ])

    temp_script_path: Optional[Path] = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            suffix=".cmd",
            delete=False,
            encoding="utf-8",
            newline="\r\n",
        ) as temp_script:
            temp_script.write(script_content)
            temp_script_path = Path(temp_script.name)

        completed = subprocess.run(
            ["cmd.exe", "/d", "/c", str(temp_script_path)],
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )

        if completed.returncode != 0:
            stderr_text = completed.stderr.strip() or completed.stdout.strip()
            raise RuntimeError(
                f"vcvarsall.bat failed with code {completed.returncode}: {stderr_text}"
            )
    finally:
        if temp_script_path and temp_script_path.exists():
            temp_script_path.unlink()

    environment = parse_set_output(completed.stdout)
    environment["TARGET"] = resolution.target
    environment["VS_COMPILER"] = resolution.compiler
    environment["VS_YEAR"] = resolution.year
    environment["VS_EDITION"] = resolution.edition
    environment["VCVARS_PLATFORM"] = resolution.vcplatform
    return environment


def print_summary(resolution: VSResolution) -> None:
    print(f"VS year       : {resolution.year}")
    print(f"VS edition    : {resolution.edition}")
    print(f"Compiler      : {resolution.compiler}")
    print(f"Target        : {resolution.target}")
    print(f"vcplatform    : {resolution.vcplatform}")
    print(f"vcvarsall.bat : {resolution.vcvarsall_bat}")


def build_argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Prepare Visual Studio environment using vcvarsall.bat"
    )
    parser.add_argument("--year", default="2022", help="Visual Studio year (default: 2022)")
    parser.add_argument("--edition", choices=SUPPORTED_EDITIONS, help="Force Visual Studio edition")
    parser.add_argument("--target", help="Override TARGET")
    parser.add_argument("--compiler", choices=SUPPORTED_COMPILERS, help="Override compiler")
    parser.add_argument("--output-json", help="Write captured environment to a JSON file")
    parser.add_argument("--print-env", action="store_true", help="Print captured environment as KEY=VALUE lines")
    parser.add_argument("--self-test", action="store_true", help="Run internal logic tests")
    return parser


def run_self_tests() -> int:
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        base = Path(tmp) / "2022"
        (base / "Community").mkdir(parents=True)
        assert detect_vs_edition("2022", base) == "Community"
        (base / "Professional").mkdir(parents=True)
        assert detect_vs_edition("2022", base) == "Professional"
        (base / "Enterprise").mkdir(parents=True)
        assert detect_vs_edition("2022", base) == "Enterprise"

    assert determine_vcplatform("INTEL32", "MSC") == "amd64_x86"
    assert determine_vcplatform("INTEL64", "MSC") == "amd64"
    assert determine_vcplatform("ANDROID32", "MSC") == "amd64"
    assert determine_vcplatform("ANDROID64", "CLANG") == "amd64"

    parsed = parse_set_output("PATH=C:\\Tools\nINCLUDE=C:\\Inc\n")
    assert parsed["PATH"] == r"C:\Tools"
    assert parsed["INCLUDE"] == r"C:\Inc"

    print("Self-test passed.")
    return 0


def main(argv: Optional[Iterable[str]] = None) -> int:
    parser = build_argument_parser()
    args = parser.parse_args(list(argv) if argv is not None else None)

    if args.self_test:
        return run_self_tests()

    resolution = resolve_vs_environment(
        target=args.target,
        compiler=args.compiler,
        year=args.year,
        edition=args.edition,
    )
    print_summary(resolution)

    if os.name != "nt":
        print("Note: environment capture is only executed on Windows.")
        return 0

    environment = capture_vcvars_environment(resolution)

    if args.output_json:
        output_path = Path(args.output_json)
        output_path.write_text(
            json.dumps(environment, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )
        print(f"Environment JSON written to: {output_path}")

    if args.print_env:
        for key in sorted(environment):
            print(f"{key}={environment[key]}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
