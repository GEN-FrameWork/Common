@echo off
setlocal

set "SCRIPT_DIR=%~dp0"

where python >nul 2>&1
if errorlevel 1 (
  echo ERROR: Python is not available in PATH.
  exit /b 1
)

python "%SCRIPT_DIR%install.py" %*
exit /b %ERRORLEVEL%
