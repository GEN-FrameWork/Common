#!/usr/bin/env python3
"""Shared helpers for compile.py, erase.py and deploy.py."""

from __future__ import annotations

import os
import platform
import re
import shutil
import signal
import subprocess
import sys
import threading
import time
from dataclasses import dataclass, field
from pathlib import Path
from typing import Mapping, Sequence

APP_PATTERN = re.compile(r'^[a-z0-9_-]+$')
UPPER_PATTERN = re.compile(r'^[A-Z0-9]+$')
VARIABLE_PATTERN = re.compile(r'^([A-Z0-9]+)=(.*)$')
LISTAPP_PATTERN = re.compile(r'^\s*"([^"]*)"\s+"([^"]*)"(?:\s+"([^"]*)")?\s*$')


@dataclass(slots=True)
class AppEntry:
    relative_path: str
    name: str
    absolute_path: Path
    targets: tuple[str, ...] = ()

    def supports_target(self, target: str) -> bool:
        return not self.targets or target.upper() in self.targets


@dataclass(slots=True)
class ClassifiedArguments:
    variation_params: list[str] = field(default_factory=list)
    application_params: list[str] = field(default_factory=list)
    variable_params: dict[str, str] = field(default_factory=dict)


class CancellationController:
    """Keyboard cancellation support shared by the scripts."""

    def __init__(self) -> None:
        self._requested_event = threading.Event()
        self._stop_event = threading.Event()
        self._thread: threading.Thread | None = None
        self._lock = threading.Lock()
        self._process: subprocess.Popen[str] | None = None
        self._enabled = False
        self._posix_fd: int | None = None
        self._posix_old_attrs: list | None = None
        self._message_printed = False

    def start(self) -> None:
        if self._enabled or not sys.stdin or not sys.stdin.isatty():
            return
        try:
            if os.name == 'nt':
                import msvcrt  # noqa: F401
            else:
                import termios
                import tty

                self._posix_fd = sys.stdin.fileno()
                self._posix_old_attrs = termios.tcgetattr(self._posix_fd)
                tty.setcbreak(self._posix_fd)
            self._thread = threading.Thread(target=self._watch_loop, name='esc-cancel-watch', daemon=True)
            self._thread.start()
            self._enabled = True
        except Exception:
            self._restore_terminal()
            self._enabled = False

    def stop(self) -> None:
        self._stop_event.set()
        thread = self._thread
        if thread is not None and thread.is_alive():
            thread.join(timeout=0.5)
        self._restore_terminal()

    def requested(self) -> bool:
        return self._requested_event.is_set()

    def request(self) -> None:
        if self._requested_event.is_set():
            return
        self._requested_event.set()
        if not self._message_printed:
            self._message_printed = True
            print('\n\n[Cancellation requested by user (ESC)]\n', flush=True)

    def attach_process(self, process: subprocess.Popen[str]) -> None:
        with self._lock:
            self._process = process

    def detach_process(self, process: subprocess.Popen[str]) -> None:
        with self._lock:
            if self._process is process:
                self._process = None

    def cancel_active_process(self) -> None:
        with self._lock:
            process = self._process
        if process is None or process.poll() is not None:
            return

        try:
            if os.name == 'nt':
                try:
                    process.send_signal(signal.CTRL_BREAK_EVENT)  # type: ignore[attr-defined]
                except Exception:
                    process.terminate()
            else:
                os.killpg(process.pid, signal.SIGINT)
        except Exception:
            try:
                process.terminate()
            except Exception:
                pass

        deadline = time.time() + 3.0
        while process.poll() is None and time.time() < deadline:
            time.sleep(0.1)

        if process.poll() is None:
            try:
                process.terminate()
            except Exception:
                pass

        deadline = time.time() + 2.0
        while process.poll() is None and time.time() < deadline:
            time.sleep(0.1)

        if process.poll() is None:
            try:
                process.kill()
            except Exception:
                pass

    def _watch_loop(self) -> None:
        if os.name == 'nt':
            self._watch_loop_windows()
        else:
            self._watch_loop_posix()

    def _watch_loop_windows(self) -> None:
        import msvcrt

        while not self._stop_event.is_set():
            try:
                if msvcrt.kbhit():
                    key = msvcrt.getwch()
                    if key == '\x1b':
                        self.request()
                        self.cancel_active_process()
                        return
                time.sleep(0.05)
            except Exception:
                return

    def _watch_loop_posix(self) -> None:
        import select

        fd = self._posix_fd
        if fd is None:
            return
        while not self._stop_event.is_set():
            try:
                readable, _, _ = select.select([fd], [], [], 0.1)
                if readable:
                    key = os.read(fd, 1)
                    if key == b'\x1b':
                        self.request()
                        self.cancel_active_process()
                        return
            except Exception:
                return

    def _restore_terminal(self) -> None:
        if os.name != 'nt' and self._posix_fd is not None and self._posix_old_attrs is not None:
            try:
                import termios

                termios.tcsetattr(self._posix_fd, termios.TCSADRAIN, self._posix_old_attrs)
            except Exception:
                pass
            finally:
                self._posix_fd = None
                self._posix_old_attrs = None


_cancellation_controller = CancellationController()


def start_keyboard_cancel_monitor() -> None:
    _cancellation_controller.start()


def stop_keyboard_cancel_monitor() -> None:
    _cancellation_controller.stop()


def cancellation_requested() -> bool:
    return _cancellation_controller.requested()


def cancellation_exit_code() -> int:
    return 130


def classify_arguments(arguments: Sequence[str]) -> ClassifiedArguments:
    result = ClassifiedArguments()
    for argument in arguments:
        variable_match = VARIABLE_PATTERN.fullmatch(argument)
        if variable_match:
            result.variable_params[variable_match.group(1)] = variable_match.group(2)
            continue
        if UPPER_PATTERN.fullmatch(argument):
            result.variation_params.append(argument)
            continue
        if APP_PATTERN.fullmatch(argument):
            result.application_params.append(argument)
            continue
        raise ValueError(f'[Unknown parameter] => {argument}')
    return result


def current_so_path(in_container: bool) -> str:
    if in_container:
        return 'Linux'
    return 'Windows' if platform.system().lower().startswith('win') else 'Linux'


def parse_listapp_targets(targets_text: str | None) -> tuple[str, ...]:
    if not targets_text:
        return ()
    targets: list[str] = []
    for value in re.split(r'[\s,;]+', targets_text.strip().upper()):
        if not value or value in {'ALL', '*'}:
            return ()
        if value not in targets:
            targets.append(value)
    return tuple(targets)


def load_listapp(file_path: Path) -> list[AppEntry]:
    entries: list[AppEntry] = []
    for raw_line in file_path.read_text(encoding='utf-8').splitlines():
        if not raw_line.strip():
            continue
        match = LISTAPP_PATTERN.fullmatch(raw_line)
        if not match:
            print(f'Line with invalid format (ignored): {raw_line}', file=sys.stderr)
            continue
        relative_path, name, targets_text = match.groups()
        absolute_path = (file_path.parent / relative_path).resolve()
        entries.append(AppEntry(
            relative_path=relative_path,
            name=name,
            absolute_path=absolute_path,
            targets=parse_listapp_targets(targets_text),
        ))
    return entries


def select_app_entries(entries: Sequence[AppEntry], requested_names: Sequence[str]) -> list[AppEntry]:
    if not requested_names:
        return list(entries)
    requested_lookup = {name: True for name in requested_names}
    selected = [entry for entry in entries if entry.name in requested_lookup]
    if not selected:
        raise ValueError('None of the requested applications were found in listapp.txt')
    return selected


def compute_tool_paths(pathlistapp_value: str, listapp_name: str, in_container: bool, dockerdomain: str) -> tuple[Path, Path, Path]:
    pathlistapp = Path(dockerdomain if in_container else pathlistapp_value)
    filelistapp = pathlistapp / listapp_name
    outfile_name = 'windows_outfile.log' if os.name == 'nt' else 'linux_outfile.log'
    outfile = (pathlistapp / '..' / '..' / '..' / outfile_name).resolve()
    return pathlistapp, filelistapp, outfile


def platform_lower(target: str) -> str:
    return target.lower()


def compiled_mode_from_debug(debug_value: str) -> str:
    # The script parameter stays uppercase (RELEASE/DEBUG); the directory name
    # that ends up on disk is lowercase (release/debug).
    return 'release' if debug_value == 'RELEASE' else 'debug'


# Targets that cross-compile to an operating system different from the build
# host. The build output folder must be named after the *target* OS (the same
# name CMake exposes through CMAKE_SYSTEM_NAME), not the host where it is built.
_TARGET_SO_OVERRIDES = {
    'ANDROID32': 'Android',
    'ANDROID64': 'Android',
}


def target_so_path(target: str, host_so_path: str) -> str:
    """Return the OS folder for a target's build output.

    Android cross-builds run on a Windows or Linux host but the artifacts belong
    to Android, so they live under an 'Android' folder (matching the CMake
    CMAKE_SYSTEM_NAME). Every native target keeps the host-derived OS folder.
    """
    return _TARGET_SO_OVERRIDES.get(target.upper(), host_so_path)


def write_log_line(outfile: Path, line: str = '') -> None:
    outfile.parent.mkdir(parents=True, exist_ok=True)
    with outfile.open('a', encoding='utf-8') as handle:
        handle.write(f'{line}\n')


def mirrored_print(text: str, outfile: Path | None = None) -> None:
    print(text)
    if outfile is not None:
        write_log_line(outfile, text)


def find_docker_directory(common_root: Path) -> Path:
    for name in ('Docker', 'docker'):
        candidate = common_root / name
        if candidate.exists():
            return candidate
    return common_root / 'Docker'


def resolve_projects_root(common_root: Path) -> Path:
    return common_root.parent.parent


def format_elapsed(start_time: float) -> str:
    elapsed = int(time.time() - start_time)
    hours = elapsed // 3600
    minutes = (elapsed % 3600) // 60
    seconds = elapsed % 60
    return f'{hours:02d}:{minutes:02d}:{seconds:02d}'


def run_command(
    command: Sequence[str],
    *,
    cwd: Path | None = None,
    environment: Mapping[str, str] | None = None,
    outfile: Path | None = None,
    capture_to_outfile: bool = True,
) -> int:
    stdout_handle = None
    stderr_target: int | None = None
    if capture_to_outfile and outfile is not None:
        outfile.parent.mkdir(parents=True, exist_ok=True)
        stdout_handle = outfile.open('a', encoding='utf-8')
        stderr_target = subprocess.STDOUT

    popen_kwargs: dict[str, object] = {
        'args': list(command),
        'cwd': str(cwd) if cwd else None,
        'env': dict(environment or os.environ),
        'stdout': stdout_handle,
        'stderr': stderr_target,
        'text': True,
    }
    if os.name == 'nt':
        popen_kwargs['creationflags'] = getattr(subprocess, 'CREATE_NEW_PROCESS_GROUP', 0)
    else:
        popen_kwargs['start_new_session'] = True

    process = subprocess.Popen(**popen_kwargs)  # type: ignore[arg-type]
    _cancellation_controller.attach_process(process)
    try:
        while True:
            returncode = process.poll()
            if returncode is not None:
                return returncode
            if _cancellation_controller.requested():
                _cancellation_controller.cancel_active_process()
                process.wait()
                return cancellation_exit_code()
            time.sleep(0.1)
    finally:
        _cancellation_controller.detach_process(process)
        if stdout_handle is not None:
            stdout_handle.close()


def build_stage_prefix(target: str, debug_value: str, action_text: str, app_name: str) -> str:
    # app_name width must fit longest entry (e.g. unittests_userinterface = 23).
    return f'{target:<10} {debug_value:<10} {action_text:<24} {app_name:<24} ... '


def build_stage_result_suffix(ok: bool, operation_start: float) -> str:
    status = '[Ok]' if ok else '[Error!]'
    elapsed_seconds = max(0, int(round(time.time() - operation_start)))
    return f'{status:<10} ({elapsed_seconds}s)'


def remove_tree(path: Path) -> None:
    if path.exists():
        shutil.rmtree(path)
