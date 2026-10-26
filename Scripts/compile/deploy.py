#!/usr/bin/env python3
"""Cross-platform Python replacement for deploy.bash."""

from __future__ import annotations

import os
import sys
from pathlib import Path

from defaultenv import build_default_settings
from internal.shared import (
    cancellation_exit_code,
    cancellation_requested,
    classify_arguments,
    compute_tool_paths,
    find_docker_directory,
    load_listapp,
    platform_lower,
    run_command,
    select_app_entries,
    start_keyboard_cancel_monitor,
    stop_keyboard_cancel_monitor,
)

PLATFORM_VALUES = {'INTEL64', 'ARM32', 'ARM64', 'RPI32', 'RPI64'}
MODE_VALUES = {'DEBUG', 'RELEASE'}
COMMAND_VALUES = ('DOWN', 'BUILD', 'UP')

# Prod images must match the CPU the binary was built for (host arch ≠ target).
DOCKER_PLATFORM_BY_TARGET = {
    'INTEL64': 'linux/amd64',
    'ARM64': 'linux/arm64',
    'RPI64': 'linux/arm64',
    'ARM32': 'linux/arm/v7',
    'RPI32': 'linux/arm/v7',
}


def resolve_apppath_for_compose(entry_absolute_path: Path, compose_file: Path, fallback: str) -> str:
    """APPPATH for dockerfile COPY, relative to compose build context (../../../ = Projects)."""
    context_root = (compose_file.parent / '../../..').resolve()
    try:
        return entry_absolute_path.relative_to(context_root).as_posix()
    except ValueError:
        return fallback


def main(argv: list[str] | None = None) -> int:
    if os.name == 'nt':
        print('[Error] deploy.py is not supported on Windows.')
        return 1

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
            if key in {'PATHLISTAPP', 'IMAGEBASE'}:
                settings[key] = value
        if not settings['PATHLISTAPP'].endswith(os.sep):
            settings['PATHLISTAPP'] = f"{settings['PATHLISTAPP']}{os.sep}"

        in_container = settings.get('IN_CONTAINER', '0') == '1'
        pathlistapp, filelistapp, _ = compute_tool_paths(settings['PATHLISTAPP'], settings['LISTAPP'], in_container, settings['DOCKERDOMAIN'])
        if not filelistapp.exists():
            print(f'[Error] FILELISTAPP not found: {filelistapp}')
            return 1

        all_entries = load_listapp(filelistapp)
        try:
            selected_entries = select_app_entries(all_entries, classified.application_params)
        except ValueError as exc:
            print(f'[Error] {exc}')
            return 1

        platforms = [value for value in classified.variation_params if value in PLATFORM_VALUES] or ['INTEL64']
        modes = [value for value in classified.variation_params if value in MODE_VALUES] or ['RELEASE']

        selected_actions = [command for command in COMMAND_VALUES if command in classified.variation_params]
        if not selected_actions:
            selected_actions = list(COMMAND_VALUES)

        docker_directory = find_docker_directory(pathlistapp.parent.parent)
        compose_file = docker_directory / 'docker-compose-prod.yml'
        if not compose_file.exists():
            print(f'[Error] compose file not found: {compose_file}')
            return 1

        print('-------------------------------------------------------------')
        print(f"Modes          : {' '.join(modes)}")
        print(f"Plataforms     : {' '.join(platforms)}")
        print(f"Docker plats   : {' '.join(DOCKER_PLATFORM_BY_TARGET[name] for name in platforms)}")
        print(f"Image Base     : {settings['IMAGEBASE']}")
        print(f"Applications   : {' '.join(entry.name for entry in selected_entries)}")
        print(f"Compose file   : {compose_file}")
        print('-------------------------------------------------------------')

        environment = os.environ.copy()
        environment.update(settings)

        for platform_name in platforms:
            if cancellation_requested():
                return cancellation_exit_code()
            docker_platform = DOCKER_PLATFORM_BY_TARGET[platform_name]
            environment['TARGET'] = platform_name
            environment['TARGET_LOWERCASE'] = platform_lower(platform_name)
            environment['DOCKER_PLATFORM'] = docker_platform
            # Prefer env over `compose build --platform` (not available on older Compose).
            environment['DOCKER_DEFAULT_PLATFORM'] = docker_platform
            environment['BUILDKIT'] = '1'
            environment['DOCKER_BUILDKIT'] = '1'
            for mode_name in modes:
                if cancellation_requested():
                    return cancellation_exit_code()
                environment['DEBUG_EXTCFG'] = mode_name
                # COMPILED_MODE feeds the artifact directory name consumed by
                # dockerfile_prod (Build/.../<mode>), which is now lowercase.
                environment['COMPILED_MODE'] = 'release' if mode_name == 'RELEASE' else 'debug'
                for entry in selected_entries:
                    if cancellation_requested():
                        return cancellation_exit_code()
                    environment['APPPATH'] = resolve_apppath_for_compose(
                        entry.absolute_path,
                        compose_file,
                        entry.relative_path,
                    )
                    environment['APPNAME'] = entry.name
                    for action in selected_actions:
                        # Image tag includes TARGET_LOWERCASE (see docker-compose-prod.yml)
                        # so INTEL64 and RPI64 do not overwrite each other.
                        # Architecture comes from compose `build.platforms` + DOCKER_DEFAULT_PLATFORM.
                        command = [
                            'docker', 'compose', '-f', str(compose_file),
                            action.lower(),
                            entry.name,
                        ]
                        print(
                            f'[{platform_name}/{mode_name}] {action} {entry.name} '
                            f'→ platform={docker_platform} image=gen_prod:{environment["TARGET_LOWERCASE"]}-{entry.name}'
                        )
                        returncode = run_command(command, cwd=pathlistapp, environment=environment, capture_to_outfile=False)
                        if returncode != 0:
                            return returncode
        return 0
    finally:
        stop_keyboard_cancel_monitor()


if __name__ == '__main__':
    raise SystemExit(main())
