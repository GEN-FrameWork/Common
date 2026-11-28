#!/usr/bin/env python3
"""Default settings for the GEN Python compile tools."""

from __future__ import annotations

import os
from pathlib import Path
from typing import Mapping

PLATFORM_PATH_BY_TARGET = {
    'INTEL32': 'intel32',
    'INTEL64': 'intel64',
    'ARM': 'arm',
    'ARM32': 'arm',
    'ARM64': 'arm64',
    'RPI': 'rpi',
    'RPI32': 'rpi',
    'RPI64': 'rpi64',
    'ANDROID': 'android',
    'ANDROID32': 'android32',
    'ANDROID64': 'android64',
    'STM32': 'stm32',
    'ESP32': 'esp32',
}


def default_docker_domain() -> str:
    """Absolute compile-dir path used as DOCKERDOMAIN inside/outside the container.

    Equivalent to:
      REPO_ROOT="$(cd "$(dirname ...)/../../.." && pwd)"
      DOCKERDOMAIN="$REPO_ROOT/Common/Scripts/compile"

    The repo is mounted in the container at the same absolute host path, so
    DOCKERDOMAIN must be that real path (not a hardcoded /Projects/GEN_FrameWork/...).
    """
    # defaultenv.py lives in <repo>/Common/Scripts/compile/
    compile_dir = Path(__file__).resolve().parent
    return f'{compile_dir}{os.sep}'


def build_default_settings(current_directory: Path, environment: Mapping[str, str] | None = None) -> dict[str, str]:
    environment = dict(environment or {})
    current_directory = current_directory.resolve()
    target = environment.get('TARGET') or 'INTEL64'
    settings = {
        'TARGET': target,
        'DEBUG_EXTCFG': environment.get('DEBUG_EXTCFG') or 'NONE',        
        'USE_CLANG_EXTCFG': environment.get('USE_CLANG_EXTCFG') or 'NONE',
        'MEMORY_EXTCFG': environment.get('MEMORY_EXTCFG') or 'NONE',
        'TRACE_EXTCFG': environment.get('TRACE_EXTCFG') or 'NONE',
        'FEEDBACK_EXTCFG': environment.get('FEEDBACK_EXTCFG') or 'NONE',
        'COVERAGE_CREATEINFO_EXTERNAL_CFG': environment.get('COVERAGE_CREATEINFO_EXTERNAL_CFG') or 'NONE',
        'IMAGEBASE': environment.get('IMAGEBASE') or 'debian',
        'PATHLISTAPP': environment.get('PATHLISTAPP') or f'{current_directory}{os.sep}',
        'LISTAPP': environment.get('LISTAPP') or 'listapp.txt',
        'APPLIST_COMPILE': environment.get('APPLIST_COMPILE') or '',
        'CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG': environment.get('CMAKE_CREATEDOCKERFILE_EXTERNAL_CFG') or ('NOTCREATEDOCKERFILE' if os.name == 'nt' else 'CREATEDOCKERFILE'),
        'DOCKERDOMAIN': environment.get('DOCKERDOMAIN') or default_docker_domain(),
        'SCRIPTHEADER': environment.get('SCRIPTHEADER') or 'false',
        'IN_CONTAINER': environment.get('IN_CONTAINER') or '0',
    }
    settings['PLATFORM_PATH'] = PLATFORM_PATH_BY_TARGET.get(target, '')
    return settings
