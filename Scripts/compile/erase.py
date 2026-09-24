#!/usr/bin/env python3
"""Cross-platform Python replacement for erase.bash."""

from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

from defaultenv import build_default_settings
from internal.shared import (
    cancellation_exit_code,
    cancellation_requested,
    classify_arguments,
    compute_tool_paths,
    load_listapp,
    run_command,
    select_app_entries,
    start_keyboard_cancel_monitor,
    stop_keyboard_cancel_monitor,
)

# Every build output root compile.py can produce. Native targets land under
# 'Windows' or 'Linux' depending on which host built them (INTEL64, for
# instance, can exist under both), while every Android target always lands
# under 'Android' regardless of the build host (see
# internal.shared.target_so_path). Erase must check all three roots so it
# removes everything assigned to a platform no matter where it was built or
# where erase.py itself is being run from.
BUILD_ROOTS = ('Windows', 'Linux', 'Android')

PLATFORM_VALUES = {'INTEL32', 'INTEL64', 'ARM32', 'ARM64', 'RPI32', 'RPI64', 'ANDROID32', 'ANDROID64'}
MODE_VALUES = {'DEBUG', 'RELEASE'}


def main(argv: list[str] | None = None) -> int:
    start_keyboard_cancel_monitor()
    try:
        argv = list(sys.argv[1:] if argv is None else argv)
        settings = build_default_settings(Path.cwd(), os.environ)

        try:
            classified = classify_arguments(argv)
        except ValueError as exc:
            print(str(exc))
            return 1

        for key, value in classified.variable_params.items():
            if key == 'PATHLISTAPP':
                settings[key] = value
        if not settings['PATHLISTAPP'].endswith(os.sep):
            settings['PATHLISTAPP'] = f"{settings['PATHLISTAPP']}{os.sep}"

        in_container = settings.get('IN_CONTAINER', '0') == '1'
        _, filelistapp, outfile = compute_tool_paths(settings['PATHLISTAPP'], settings['LISTAPP'], in_container, settings['DOCKERDOMAIN'])
        if not filelistapp.exists():
            print(f'[Error] FILELISTAPP not found: {filelistapp}')
            return 1

        all_entries = load_listapp(filelistapp)
        try:
            selected_entries = select_app_entries(all_entries, classified.application_params)
        except ValueError as exc:
            print(f'[Error] {exc}')
            return 1

        platforms = [value for value in classified.variation_params if value in PLATFORM_VALUES]
        modes = [value for value in classified.variation_params if value in MODE_VALUES]
        indocker = 'DOCKER' in classified.variation_params
        allplatforms = not platforms
        allmodes = not modes
        if not platforms:
            platforms = ['INTEL32', 'INTEL64', 'ARM32', 'ARM64', 'RPI32', 'RPI64', 'ANDROID32', 'ANDROID64']
        if not modes:
            modes = ['DEBUG', 'RELEASE']

        print('-------------------------------------------------------------')
        if outfile.exists():
            print('Removing output.txt')
            outfile.unlink()
        print(f"Modes        : {' '.join(modes)}")
        print(f"Plataforms   : {' '.join(platforms)}")
        print(f"Applications : {' '.join(entry.name for entry in selected_entries)}")
        print('-------------------------------------------------------------')
        print()

        if not indocker:
            for entry in selected_entries:
                if cancellation_requested():
                    return cancellation_exit_code()
                removed_items: list[str] = []
                cmake_directory = entry.absolute_path / 'CMake'
                vs_directory = cmake_directory / '.vs'
                vscode_directory = cmake_directory / '.vscode'
                if vs_directory.exists():
                    removed_items.append('.vs')
                    shutil.rmtree(vs_directory)
                if vscode_directory.exists():
                    removed_items.append('.vscode')
                    shutil.rmtree(vscode_directory)
                if allplatforms:
                    # No platform was requested: wipe every build root
                    # (Windows/Linux/Android) regardless of which one matches
                    # the host erase.py is running on.
                    for so_name in BUILD_ROOTS:
                        so_root = cmake_directory / 'Build' / so_name
                        if so_root.exists():
                            removed_items.append(so_name)
                            shutil.rmtree(so_root)
                else:
                    for platform_name in platforms:
                        if cancellation_requested():
                            return cancellation_exit_code()
                        # A given platform can have been built under more than
                        # one root (e.g. INTEL64 under both Windows and
                        # Linux), so check every root instead of assuming the
                        # current host's.
                        for so_name in BUILD_ROOTS:
                            platform_directory = cmake_directory / 'Build' / so_name / platform_name.lower()
                            if allmodes:
                                if platform_directory.exists():
                                    removed_items.append(f'{so_name}/{platform_name.lower()}')
                                    shutil.rmtree(platform_directory)
                            else:
                                for mode_name in modes:
                                    if cancellation_requested():
                                        return cancellation_exit_code()
                                    target_directory = platform_directory / mode_name.lower()
                                    if target_directory.exists():
                                        removed_items.append(f'{so_name}/{platform_name.lower()}/{mode_name.lower()}')
                                        shutil.rmtree(target_directory)
                print(f"Erase build : {entry.name:<20} [ {' '.join(removed_items)} ]")
        else:
            docker_ids_output = subprocess.run(['docker', 'ps', '-aq'], capture_output=True, text=True, check=False)
            docker_ids = [value for value in docker_ids_output.stdout.split() if value]
            print('Stop all containers         ... ', end='')
            if docker_ids:
                stop_returncode = run_command(['docker', 'stop', *docker_ids], outfile=outfile)
                if stop_returncode == cancellation_exit_code():
                    print('[Error!]')
                    return cancellation_exit_code()
                stop_ok = stop_returncode == 0
            else:
                stop_ok = True
            print('[Ok]' if stop_ok else '[Error!]')

            print('Erase all images/containers ... ', end='')
            prune_returncode = run_command(['docker', 'system', 'prune', '-a', '--volumes', '-f'], outfile=outfile)
            if prune_returncode == cancellation_exit_code():
                print('[Error!]')
                return cancellation_exit_code()
            print('[Ok]' if prune_returncode == 0 else '[Error!]')

        print()
        print('-------------------------------------------------------------')
        return 0
    finally:
        stop_keyboard_cancel_monitor()


if __name__ == '__main__':
    raise SystemExit(main())
