#!/usr/bin/env python3
"""Cross-platform Python replacement for compile.bash."""

from __future__ import annotations

import os
import json
import re
import shutil
import subprocess
import tempfile
import sys
import time
from pathlib import Path

from defaultenv import build_default_settings
from internal.shared import (
    AppEntry,
    build_stage_prefix,
    build_stage_result_suffix,
    cancellation_exit_code,
    cancellation_requested,
    classify_arguments,
    compiled_mode_from_debug,
    compute_tool_paths,
    current_so_path,
    find_docker_directory,
    format_elapsed,
    load_listapp,
    platform_lower,
    resolve_projects_root,
    run_command,
    select_app_entries,
    start_keyboard_cancel_monitor,
    stop_keyboard_cancel_monitor,
    target_so_path,
    write_log_line,
)

STAGE_VALUES = {'CMAKE', 'COMPILE', 'TEST'}
WINDOWS_PLATFORM_VALUES = ('INTEL32', 'INTEL64', 'ANDROID32', 'ANDROID64')
LINUX_PLATFORM_VALUES = ('INTEL64', 'ARM32', 'ARM64', 'RPI32', 'RPI64')
KNOWN_PLATFORM_VALUES = set(WINDOWS_PLATFORM_VALUES) | set(LINUX_PLATFORM_VALUES)
MODE_VALUES = {'DEBUG', 'RELEASE'}
USE_CLANG_VALUES = {'CLANG', 'NOTCLANG'}
MEMORY_VALUES = {'MEMCTRL', 'NOTMEMCTRL'}
TRACE_VALUES = {'TRACE', 'TRACENOTINTER', 'NOTTRACE'}
FEEDBACK_VALUES = {'FEEDBACK', 'NOTFEEDBACK'}
COVERAGE_VALUES = {'COVER', 'NOTCOVER'}
CMAKE_CREATEDOCKERFILE_VALUES = {'CREATEDOCKERFILE', 'NOTCREATEDOCKERFILE'}


def supported_platform_values() -> tuple[str, ...]:
    if os.name == 'nt':
        return WINDOWS_PLATFORM_VALUES
    return LINUX_PLATFORM_VALUES


def default_platform_values() -> list[str]:
    if os.name == 'nt':
        return list(WINDOWS_PLATFORM_VALUES)
    return ['INTEL64', 'ARM64', 'RPI64']


def validate_variation_params(variation_params: list[str]) -> None:
    supported_values = set(supported_platform_values())
    is_windows_host = os.name == 'nt'
    for value in variation_params:
        if value == 'DOCKER' and is_windows_host:
            raise ValueError(f'[Unknown parameter] => {value}')
        if value in KNOWN_PLATFORM_VALUES and value not in supported_values:
            raise ValueError(f'[Unknown parameter] => {value}')



def configure_from_variations(
    variation_params: list[str],
    settings: dict[str, str],
    in_container: bool,
    supported_values: tuple[str, ...],
) -> tuple[list[str], list[str], list[str], bool]:
    stages: list[str] = []
    platforms: list[str] = []
    modes: list[str] = []
    indocker = False

    for value in variation_params:
        if value in STAGE_VALUES and value not in stages:
            stages.append(value)
        if value in supported_values and value not in platforms:
            platforms.append(value)
        if value in MODE_VALUES and value not in modes:
            modes.append(value)
        if value in USE_CLANG_VALUES:
            settings['USE_CLANG_EXTCFG'] = value
        if value in MEMORY_VALUES:
            settings['MEMORY_EXTCFG'] = value
        if value in TRACE_VALUES:
            settings['TRACE_EXTCFG'] = value
        if value in FEEDBACK_VALUES:
            settings['FEEDBACK_EXTCFG'] = value
        if value in COVERAGE_VALUES:
            settings['COVERAGE_CREATEINFO_EXTERNAL_CFG'] = value
        if value in CMAKE_CREATEDOCKERFILE_VALUES:
            settings['CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG'] = value
        if value == 'DOCKER':
            indocker = True

    if not stages:
        stages = ['CMAKE', 'COMPILE', 'TEST']
    if not platforms:
        platforms = default_platform_values()
    if not modes:
        modes = ['DEBUG', 'RELEASE']
    if in_container:
        indocker = False
    return stages, platforms, modes, indocker



def print_start_header(outfile: Path, stages: list[str], modes: list[str], platforms: list[str], app_names: list[str]) -> None:
    lines = [
        '-------------------------------------------------------------',
        'Start process ...',
        time.strftime('%c'),
        f"Stages         : {' '.join(stages)}",
        f"Modes          : {' '.join(modes)}",
        f"Plataforms     : {' '.join(platforms)}",
        f"Applications   : {' '.join(app_names)}",
    ]
    for line in lines:
        print(line)
    write_log_line(outfile, ' ')
    for line in lines:
        write_log_line(outfile, line)



def select_test_executable(build_dir: Path, app_name: str) -> list[str]:
    candidates = [build_dir / app_name]
    if os.name == 'nt':
        candidates.insert(0, build_dir / f'{app_name}.exe')
    for candidate in candidates:
        if candidate.exists():
            return [str(candidate)]
    return [str(candidates[0])]





def count_warning_messages(block_text: str) -> int:
    warning_entries: set[str] = set()

    clang_gcc_with_column = re.compile(r'^(.+?):(\d+):(\d+):\s+warning:\s+', re.IGNORECASE)
    clang_gcc_without_column = re.compile(r'^(.+?):(\d+):\s+warning:\s+', re.IGNORECASE)
    msvc_warning = re.compile(r'^(.+?)\((\d+)(?:,(\d+))?\):\s+warning\s+([A-Z]+\d+):\s+', re.IGNORECASE)

    for raw_line in block_text.splitlines():
        line = raw_line.strip()
        if not line:
            continue

        match = msvc_warning.match(line)
        if match:
            file_path, line_number, column_number, warning_code = match.groups()
            warning_entries.add(
                f'MSVC|{file_path}|{line_number}|{column_number or ""}|{warning_code.upper()}'
            )
            continue

        match = clang_gcc_with_column.match(line)
        if match:
            file_path, line_number, column_number = match.groups()
            warning_entries.add(f'GNUCLANG|{file_path}|{line_number}|{column_number}')
            continue

        match = clang_gcc_without_column.match(line)
        if match:
            file_path, line_number = match.groups()
            warning_entries.add(f'GNUCLANG|{file_path}|{line_number}|')
            continue

    return len(warning_entries)


def read_outfile_tail(outfile: Path, start_offset: int) -> str:
    if not outfile.exists():
        return ''
    with outfile.open('rb') as fh:
        fh.seek(start_offset)
        data = fh.read()
    return data.decode('utf-8', errors='ignore')


def collect_compile_warning_count(outfile: Path, start_offset: int) -> int:
    return count_warning_messages(read_outfile_tail(outfile, start_offset))



def write_compile_status_file(status_file: Path, error_items: list[str], warning_items: list[str]) -> None:
    status_payload = {'errors': list(error_items), 'warnings': list(warning_items)}
    status_file.write_text(json.dumps(status_payload, ensure_ascii=False), encoding='utf-8')


def read_compile_status_file(status_file: Path) -> tuple[list[str], list[str]]:
    if not status_file.exists():
        return [], []
    try:
        status_payload = json.loads(status_file.read_text(encoding='utf-8'))
    except Exception:
        return [], []
    errors = status_payload.get('errors', [])
    warnings = status_payload.get('warnings', [])
    if not isinstance(errors, list):
        errors = []
    if not isinstance(warnings, list):
        warnings = []
    return [str(item) for item in errors], [str(item) for item in warnings]



def load_vs_environment_for_platform(
    script_directory: Path,
    platform_name: str,
    settings: dict[str, str],
) -> dict[str, str]:
    if os.name != 'nt':
        return {}

    compiler_name = 'CLANG' if settings.get('USE_CLANG_EXTCFG', '').upper() == 'CLANG' else 'MSC'
    vsvarall_script = script_directory / 'internal' / 'vsvarall.py'
    if not vsvarall_script.exists():
        raise FileNotFoundError(f'vsvarall.py not found: {vsvarall_script}')

    temp_fd, temp_json_path = tempfile.mkstemp(prefix='vsenv_', suffix='.json')
    os.close(temp_fd)

    try:
        command = [
            sys.executable,
            str(vsvarall_script),
            '--target', platform_name,
            '--compiler', compiler_name,
            '--output-json', temp_json_path,
        ]
        completed = subprocess.run(
            command,
            cwd=script_directory,
            check=False,
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='replace',
        )
        if completed.returncode != 0:
            detail = completed.stderr.strip() or completed.stdout.strip()
            raise RuntimeError(f'vsvarall.py failed for {platform_name}: {detail}')

        temp_json = Path(temp_json_path)
        if not temp_json.exists():
            raise RuntimeError(f'vsvarall.py did not create output file: {temp_json}')

        return json.loads(temp_json.read_text(encoding='utf-8'))
    finally:
        temp_json = Path(temp_json_path)
        if temp_json.exists():
            temp_json.unlink()



def build_android_cmake_arguments(common_root: Path, target: str) -> list[str]:
    repo_root = common_root.parent
    android_ndk_root = repo_root / 'ThirdPartyLibraries' / 'android-ndk'
    toolchain_file = android_ndk_root / 'build' / 'CMake' / 'android.toolchain.cmake'

    if not toolchain_file.exists():
        raise FileNotFoundError(f'Android toolchain file not found: {toolchain_file}')

    abi_by_target = {
        'ANDROID32': 'armeabi-v7a',
        'ANDROID64': 'arm64-v8a',
    }

    android_abi = abi_by_target[target]

    return [
        f'-DCMAKE_TOOLCHAIN_FILE={toolchain_file}',
        f'-DANDROID_NDK={android_ndk_root}',
        f'-DANDROID_ABI={android_abi}',
        '-DANDROID_PLATFORM=android-24',
        '-DANDROID_STL=c++_shared',
    ]

def run_compile_stage(
    stage: str,
    target: str,
    debug_value: str,
    app_entry: AppEntry,
    so_path: str,
    settings: dict[str, str],
    outfile: Path,
    common_root: Path,
    base_environment: dict[str, str] | None = None,
) -> tuple[int, int]:
    target_lower = platform_lower(target)
    compiled_mode = compiled_mode_from_debug(debug_value)
    target_so = target_so_path(target, so_path)
    build_dir = app_entry.absolute_path / 'CMake' / 'Build' / target_so / target_lower / compiled_mode
    if stage == 'CMAKE' and build_dir.exists():
        shutil.rmtree(build_dir)
    build_dir.mkdir(parents=True, exist_ok=True)

    effective_environment = dict(base_environment) if base_environment is not None else os.environ.copy()
    effective_environment.update(settings)
    effective_environment['TARGET'] = target
    effective_environment['TARGET_LOWERCASE'] = target_lower
    effective_environment['DEBUG_EXTCFG'] = debug_value    
    effective_environment['APPNAME'] = app_entry.name

    if outfile.exists():
        stage_start_offset = outfile.stat().st_size
    else:
        stage_start_offset = 0

    write_log_line(outfile, '')
    write_log_line(outfile, '')
    write_log_line(outfile, f'[#STAGE {stage},{app_entry.name},{target},{debug_value}]')
    write_log_line(outfile, '_______________________________________________________________________________________________________________________________________________________________________________')

    if stage == 'CMAKE':
        command = [
            'cmake',
            '-G', 'Ninja',
            '-Wno-deprecated',
            '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
        ]
        if target in {'ANDROID32', 'ANDROID64'}:
            command.extend(build_android_cmake_arguments(common_root, target))
        command.extend([
            f'-DTARGET={target}',
            f'-DUSE_CLANG_EXTCFG={effective_environment["USE_CLANG_EXTCFG"]}',
            f'-DCOVERAGE_CREATEINFO_EXTERNAL_CFG={effective_environment["COVERAGE_CREATEINFO_EXTERNAL_CFG"]}',
            f'-DDEBUG_EXTCFG={effective_environment["DEBUG_EXTCFG"]}',
            f'-DMEMORY_EXTCFG={effective_environment["MEMORY_EXTCFG"]}',
            f'-DTRACE_EXTCFG={effective_environment["TRACE_EXTCFG"]}',
            f'-DFEEDBACK_EXTCFG={effective_environment["FEEDBACK_EXTCFG"]}',
            f'-DPATHLISTAPP={settings["PATHLISTAPP"]}',
            f'-DCMAKE_CREATEDOCKERFILE_EXTERNAL_CFG={effective_environment["CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG"]}',            
            '../../../..',
        ])
        action_text = 'Generate CMake'
    elif stage == 'COMPILE':
        command = ['ninja']
        action_text = 'Compilate project'
    elif stage == 'TEST' and app_entry.name.startswith('unittests_') and target in {'INTEL32', 'INTEL64'}:
        # TEST only ever runs for unittests_* apps on INTEL32/INTEL64, in
        # DEBUG and RELEASE. Windows-only platforms (ANDROID32/64) and
        # Linux-only platforms (ARM32/ARM64/RPI32/RPI64) never reach here
        # because supported_platform_values()/validate_variation_params()
        # already restrict `platforms` to the current host's list, so
        # INTEL32 (Windows-only) is simply absent from the loop when
        # running on Linux, and vice versa for the Linux-only platforms.
        command = select_test_executable(build_dir, app_entry.name)
        action_text = 'Test project'
    else:
        write_log_line(outfile, '')
        write_log_line(outfile, '')
        return 0, 0

    operation_prefix = build_stage_prefix(target, debug_value, action_text, app_entry.name)
    print(operation_prefix, end='', flush=True)
    operation_start = time.time()
    returncode = run_command(command, cwd=build_dir, environment=effective_environment, outfile=outfile)
    warning_count = 0
    if stage == 'COMPILE':
        warning_count = collect_compile_warning_count(outfile, stage_start_offset)
    result_suffix = build_stage_result_suffix(returncode == 0, operation_start)
    if stage == 'COMPILE' and warning_count > 0:
        result_suffix = f'{result_suffix}  [Warning(s): {warning_count}]'
    print(result_suffix)
    write_log_line(outfile, '')
    write_log_line(outfile, '')
    return returncode, warning_count



def filter_docker_arguments(arguments: list[str]) -> list[str]:
    return [argument for argument in arguments if argument != 'DOCKER' and argument not in KNOWN_PLATFORM_VALUES]



def run_docker_compile(script_directory: Path, common_root: Path, platform_name: str, arguments: list[str], settings: dict[str, str]) -> tuple[int, list[str], list[str]]:
    docker_directory = find_docker_directory(common_root)
    dockerfile_path = docker_directory / 'dockerfile_build'
    repo_root = common_root.parent
    projects_root = resolve_projects_root(common_root)
    image_name = f'gen_compiler_image_{platform_name.lower()}'
    container_name = f'gen_compiler_container_{platform_name.lower()}'
    build_command = [
        'docker', 'build',
        '--build-arg', f'TARGET={platform_name}',
        '--build-arg', f'IMAGEBASE={settings["IMAGEBASE"]}',
        '--build-arg', 'SO_PATH=Linux',
        '--build-arg', f'DOCKERDOMAIN={settings["DOCKERDOMAIN"]}',
        '-t', image_name,
        '-f', str(dockerfile_path),
        str(repo_root),
    ]
    build_returncode = run_command(build_command, cwd=script_directory, environment=os.environ.copy(), capture_to_outfile=False)
    if build_returncode != 0:
        print(f'Error Build. Code: {build_returncode}')
        return build_returncode, [], []

    host_status_file = script_directory / f'internal/.compile_docker_status_{platform_name.lower()}.json'
    if host_status_file.exists():
        host_status_file.unlink()

    container_status_file = Path(settings['DOCKERDOMAIN']) / f'internal/.compile_docker_status_{platform_name.lower()}.json'

    run_command_list = [
        'docker', 'run', '-it', '--rm',
        '--name', container_name,
        '-e', 'IN_CONTAINER=1',
        '-e', f'TARGET={platform_name}',
        '-e', f'DEBUG_EXTCFG={settings.get("DEBUG_EXTCFG", "NONE")}',
        '-e', f'USE_CLANG_EXTCFG={settings["USE_CLANG_EXTCFG"]}',
        '-e', f'MEMORY_EXTCFG={settings["MEMORY_EXTCFG"]}',
        '-e', f'TRACE_EXTCFG={settings["TRACE_EXTCFG"]}',
        '-e', f'FEEDBACK_EXTCFG={settings["FEEDBACK_EXTCFG"]}',
        '-e', f'COVERAGE_CREATEINFO_EXTERNAL_CFG={settings["COVERAGE_CREATEINFO_EXTERNAL_CFG"]}',
        '-e', f'IMAGEBASE={settings["IMAGEBASE"]}',
        '-e', f'PATHLISTAPP={settings["PATHLISTAPP"]}',
        '-e', f'LISTAPP={settings["LISTAPP"]}',
        '-e', f'APPLIST_COMPILE={settings.get("APPLIST_COMPILE", "")}',
        '-e', f'COMPILE_STATUS_FILE={container_status_file}',
        '-e', 'SO_PATH=Linux',
        '-e', f'CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG={settings["CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG"]}',            
        '-e', f'DOCKERDOMAIN={settings["DOCKERDOMAIN"]}',
        '-e', 'SCRIPTHEADER=true',
        '--tmpfs', '/build:rw,noexec,nosuid,size=16g',
        '-v', f'{projects_root}:/Projects',
        '-v', '/root/.cache/:/root/.cache/',
        image_name,
        *arguments,
    ]
    run_returncode = run_command(run_command_list, cwd=script_directory, environment=os.environ.copy(), capture_to_outfile=False)
    status_errors, status_warnings = read_compile_status_file(host_status_file)
    return run_returncode, status_errors, status_warnings



def main(argv: list[str] | None = None) -> int:
    start_keyboard_cancel_monitor()
    try:
        argv = list(sys.argv[1:] if argv is None else argv)
        start_time = time.time()
        script_directory = Path(__file__).resolve().parent
        settings = build_default_settings(Path.cwd(), os.environ)

        try:
            classified = classify_arguments(argv)
            validate_variation_params(classified.variation_params)
        except ValueError as exc:
            print(str(exc))
            return 1

        for key, value in classified.variable_params.items():
            if key in {'PATHLISTAPP', 'IMAGEBASE'}:
                settings[key] = value
        if not settings['PATHLISTAPP'].endswith(os.sep):
            settings['PATHLISTAPP'] = f"{settings['PATHLISTAPP']}{os.sep}"

        in_container = settings.get('IN_CONTAINER', '0') == '1'
        if in_container:
            settings['PATHLISTAPP'] = settings['DOCKERDOMAIN']
        so_path = current_so_path(in_container)
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

        settings['APPLIST_COMPILE'] = ' '.join(entry.name for entry in selected_entries)
        stages, platforms, modes, indocker = configure_from_variations(
            classified.variation_params,
            settings,
            in_container,
            supported_platform_values(),
        )

        if settings.get('SCRIPTHEADER', 'false').lower() == 'false':
            if outfile.exists():
                print('\nRemoving outfile ...\n')
                outfile.unlink()
            print_start_header(outfile, stages, modes, platforms, [entry.name for entry in selected_entries])

        common_root = script_directory.parent.parent
        error_items: list[str] = []
        warning_items: list[str] = []
        docker_failed = False
        platform_environments: dict[str, dict[str, str]] = {}
        if not indocker:
            if not in_container:
                print('-------------------------------------------------------------')
                print()
                write_log_line(outfile, '-------------------------------------------------------------')
            for stage in stages:
                if cancellation_requested():
                    return cancellation_exit_code()
                print(f'\n[{stage}]')
                for platform_name in platforms:
                    if cancellation_requested():
                        return cancellation_exit_code()

                    platform_environment = None
                    if os.name == 'nt':
                        platform_environment = platform_environments.get(platform_name)
                        if platform_environment is None:
                            platform_environment = os.environ.copy()
                            platform_environment.update(load_vs_environment_for_platform(script_directory, platform_name, settings))
                            platform_environments[platform_name] = platform_environment

                    for mode_name in modes:
                        if cancellation_requested():
                            return cancellation_exit_code()
                        for entry in selected_entries:
                            if cancellation_requested():
                                return cancellation_exit_code()
                            if not entry.supports_target(platform_name):
                                skip_line = build_stage_prefix(platform_name, mode_name, f'Skip {stage}', entry.name) + '[Unsupported target]'
                                write_log_line(outfile, skip_line)
                                if stage != 'TEST':
                                    # In the TEST stage, only applications that
                                    # actually run a test should be printed;
                                    # skipped apps still get logged to outfile
                                    # but stay out of the console.
                                    print(skip_line)
                                continue
                            returncode, warning_count = run_compile_stage(stage, platform_name, mode_name, entry, so_path, settings, outfile, common_root, platform_environment)
                            if stage == 'COMPILE' and warning_count > 0:
                                warning_items.append(f'{platform_name}_{mode_name}_{entry.name}({warning_count})')
                            if returncode != 0:
                                error_items.append(f'{stage}_{platform_name}_{mode_name}_{entry.name}')
        else:
            print(f'Image Base     : Compilation Docker with {settings["IMAGEBASE"]}')
            write_log_line(outfile, f'Image Base     : Compilation Docker with {settings["IMAGEBASE"]}')
            print('-------------------------------------------------------------')
            print()
            write_log_line(outfile, '-------------------------------------------------------------')
            filtered_arguments = filter_docker_arguments(argv)
            for platform_name in platforms:
                if cancellation_requested():
                    return cancellation_exit_code()
                docker_arguments = [*filtered_arguments, platform_name]
                returncode, docker_error_items, docker_warning_items = run_docker_compile(
                    script_directory,
                    common_root,
                    platform_name,
                    docker_arguments,
                    settings,
                )
                if docker_error_items:
                    error_items.extend(docker_error_items)
                if docker_warning_items:
                    warning_items.extend(docker_warning_items)
                if returncode != 0 or docker_error_items:
                    docker_failed = True

        elapsed_text = format_elapsed(start_time)
        
        if error_items or warning_items:
            print()
            print()
            print()
        
        if error_items:
            errors_line = "Errors: " + "  ".join(error_items)           
            print(errors_line)
            write_log_line(outfile, '')
            write_log_line(outfile, '')
            write_log_line(outfile, errors_line)

        if warning_items:
            warnings_line = "Warnings: " + ",  ".join(warning_items)
            print(warnings_line)
            write_log_line(outfile, warnings_line)
            
        
        if str(settings.get('SCRIPTHEADER', 'false')).lower() == 'false':            
            print()
            print('-------------------------------------------------------------')
            print(f'End process.\nProcessing time: {elapsed_text}')
            print('-------------------------------------------------------------')               
            write_log_line(outfile, '')
            write_log_line(outfile, '-------------------------------------------------------------')
            write_log_line(outfile, f'End process.\nProcessing time: {elapsed_text}')
            write_log_line(outfile, '-------------------------------------------------------------')
            
            if error_items:
                print()
                print('Error exit. Code: 1')
                write_log_line(outfile, '')
                write_log_line(outfile, 'Error exit. Code: 1')

                      
        status_file_value = os.environ.get('COMPILE_STATUS_FILE', '').strip()
        if in_container and status_file_value:
            write_compile_status_file(Path(status_file_value), error_items, warning_items)

        return 1 if error_items or docker_failed else 0
    finally:
        stop_keyboard_cancel_monitor()


if __name__ == '__main__':
    raise SystemExit(main())
