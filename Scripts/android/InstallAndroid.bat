@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem -----------------------------------------------------------------------------
rem GEN Framework - Android SDK / NDK installer for Windows
rem
rem Installs the Android development environment expected by GEN into:
rem   ThirdPartyLibraries\android-sdk
rem   ThirdPartyLibraries\android-ndk
rem
rem The package/version set is shared with InstallAndroid.bash through
rem AndroidPackages.cfg.
rem -----------------------------------------------------------------------------

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..\..") do set "GEN_ROOT=%%~fI"
set "THIRDPARTY_DIR=%GEN_ROOT%\ThirdPartyLibraries"
set "CONFIG_FILE=%SCRIPT_DIR%AndroidPackages.cfg"
set "SDK_ROOT=%THIRDPARTY_DIR%\android-sdk"
set "NDK_ROOT=%THIRDPARTY_DIR%\android-ndk"
rem Keep staging on the same volume as ThirdPartyLibraries. cmd.exe MOVE cannot
rem move directories across volumes (for example, from %TEMP% on C: to E:).
set "TMP_ROOT=%THIRDPARTY_DIR%\.gen-android-install-%RANDOM%-%RANDOM%"

set "FORCE=0"
set "CHECK_ONLY=0"
set "INSTALL_SDK=1"
set "INSTALL_NDK=1"

if not exist "%CONFIG_FILE%" (
  echo [GEN Android] ERROR: Configuration file not found: %CONFIG_FILE%
  exit /b 1
)

for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%CONFIG_FILE%") do (
  if not "%%A"=="" set "%%A=%%B"
)

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--check"    set "CHECK_ONLY=1"& shift & goto parse_args
if /I "%~1"=="--force"    set "FORCE=1"& shift & goto parse_args
if /I "%~1"=="--sdk-only" set "INSTALL_NDK=0"& shift & goto parse_args
if /I "%~1"=="--ndk-only" set "INSTALL_SDK=0"& shift & goto parse_args
if /I "%~1"=="-h"         goto help
if /I "%~1"=="--help"     goto help
echo [GEN Android] ERROR: Unknown option: %~1
exit /b 1

:args_done
call :RequireConfig SDK_PLATFORM_TOOLS_MIN || exit /b 1
call :RequireConfig SDK_BUILD_TOOLS_1 || exit /b 1
call :RequireConfig SDK_BUILD_TOOLS_2 || exit /b 1
call :RequireConfig SDK_PLATFORM_1 || exit /b 1
call :RequireConfig SDK_PLATFORM_2 || exit /b 1
call :RequireConfig SDK_PLATFORM_3 || exit /b 1
call :RequireConfig NDK_REVISION || exit /b 1
call :RequireConfig NDK_RELEASE || exit /b 1
call :RequireConfig CMDLINE_TOOLS_WINDOWS_URL || exit /b 1
call :RequireConfig CMDLINE_TOOLS_WINDOWS_SHA256 || exit /b 1
call :RequireConfig NDK_WINDOWS_URL || exit /b 1
call :RequireConfig NDK_WINDOWS_SHA1 || exit /b 1

where powershell.exe >nul 2>&1 || (
  echo [GEN Android] ERROR: PowerShell is required.
  exit /b 1
)

mkdir "%TMP_ROOT%" >nul 2>&1

echo [GEN Android] ThirdPartyLibraries root: %THIRDPARTY_DIR%
echo [GEN Android] Android SDK target    : %SDK_ROOT%
echo [GEN Android] Android NDK target    : %NDK_ROOT%

if "%INSTALL_SDK%"=="1" (
  if "%CHECK_ONLY%"=="0" (
    where java.exe >nul 2>&1 || (
      echo [GEN Android] ERROR: Java is required by Android sdkmanager. Install a JDK and ensure java.exe is in PATH.
      call :Cleanup
      exit /b 1
    )
    call :InstallCommandLineTools || goto failed
    call :InstallSDKPackages || goto failed
  )
  call :ValidateSDK || goto failed
)

if "%INSTALL_NDK%"=="1" (
  if "%CHECK_ONLY%"=="0" (
    call :InstallNDK || goto failed
  )
  call :ValidateNDK || goto failed
)

echo [GEN Android] Android environment is ready for GEN Framework.
call :Cleanup
exit /b 0

:RequireConfig
if not defined %~1 (
  echo [GEN Android] ERROR: Missing %~1 in AndroidPackages.cfg
  exit /b 1
)
exit /b 0

:Download
set "DL_URL=%~1"
set "DL_FILE=%~2"
echo [GEN Android] Downloading %DL_URL%
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -UseBasicParsing -Uri '%DL_URL%' -OutFile '%DL_FILE%'"
if errorlevel 1 exit /b 1
exit /b 0

:VerifySHA256
set "HASH_FILE=%~1"
set "EXPECTED_HASH=%~2"
for /f "usebackq delims=" %%H in (`powershell.exe -NoProfile -Command "(Get-FileHash -Algorithm SHA256 -LiteralPath '%HASH_FILE%').Hash.ToLowerInvariant()"`) do set "ACTUAL_HASH=%%H"
if /I not "!ACTUAL_HASH!"=="%EXPECTED_HASH%" (
  echo [GEN Android] ERROR: SHA-256 mismatch for %HASH_FILE%
  echo [GEN Android]        Expected: %EXPECTED_HASH%
  echo [GEN Android]        Actual  : !ACTUAL_HASH!
  exit /b 1
)
exit /b 0

:VerifySHA1
set "HASH_FILE=%~1"
set "EXPECTED_HASH=%~2"
for /f "usebackq delims=" %%H in (`powershell.exe -NoProfile -Command "(Get-FileHash -Algorithm SHA1 -LiteralPath '%HASH_FILE%').Hash.ToLowerInvariant()"`) do set "ACTUAL_HASH=%%H"
if /I not "!ACTUAL_HASH!"=="%EXPECTED_HASH%" (
  echo [GEN Android] ERROR: SHA-1 mismatch for %HASH_FILE%
  echo [GEN Android]        Expected: %EXPECTED_HASH%
  echo [GEN Android]        Actual  : !ACTUAL_HASH!
  exit /b 1
)
exit /b 0

:InstallCommandLineTools
set "SDKMANAGER=%SDK_ROOT%\cmdline-tools\latest\bin\sdkmanager.bat"
if exist "%SDKMANAGER%" if "%FORCE%"=="0" (
  echo [GEN Android] Android Command-line Tools already installed.
  exit /b 0
)

set "CMD_ARCHIVE=%TMP_ROOT%\commandlinetools-win.zip"
set "CMD_EXTRACT=%TMP_ROOT%\cmdline-tools-extract"
call :Download "%CMDLINE_TOOLS_WINDOWS_URL%" "%CMD_ARCHIVE%" || exit /b 1
echo [GEN Android] Verifying Android Command-line Tools SHA-256...
call :VerifySHA256 "%CMD_ARCHIVE%" "%CMDLINE_TOOLS_WINDOWS_SHA256%" || exit /b 1

if exist "%CMD_EXTRACT%" rmdir /s /q "%CMD_EXTRACT%"
mkdir "%CMD_EXTRACT%" >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%CMD_ARCHIVE%' -DestinationPath '%CMD_EXTRACT%' -Force"
if errorlevel 1 exit /b 1
if not exist "%CMD_EXTRACT%\cmdline-tools\bin\sdkmanager.bat" (
  echo [GEN Android] ERROR: Unexpected Command-line Tools archive layout.
  exit /b 1
)

if not exist "%SDK_ROOT%\cmdline-tools" mkdir "%SDK_ROOT%\cmdline-tools" >nul 2>&1
if exist "%SDK_ROOT%\cmdline-tools\latest" rmdir /s /q "%SDK_ROOT%\cmdline-tools\latest"
move "%CMD_EXTRACT%\cmdline-tools" "%SDK_ROOT%\cmdline-tools\latest" >nul
if errorlevel 1 exit /b 1
if not exist "%SDKMANAGER%" (
  echo [GEN Android] ERROR: sdkmanager was not installed correctly.
  exit /b 1
)
exit /b 0

:InstallSDKPackages
set "SDKMANAGER=%SDK_ROOT%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMANAGER%" (
  echo [GEN Android] ERROR: sdkmanager not found: %SDKMANAGER%
  exit /b 1
)

if "%GEN_ANDROID_ACCEPT_LICENSES%"=="1" (
  echo [GEN Android] Accepting Android SDK licenses ^(GEN_ANDROID_ACCEPT_LICENSES=1^) ...
  (for /L %%Y in (1,1,100) do @echo y) | "%ComSpec%" /d /s /c ""%SDKMANAGER%" --sdk_root="%SDK_ROOT%" --licenses"
  if errorlevel 1 exit /b 1
) else (
  echo [GEN Android] Android SDK licenses must be accepted to install packages.
  echo [GEN Android] Review the licenses shown by sdkmanager and answer the prompts.
  call "%SDKMANAGER%" --sdk_root="%SDK_ROOT%" --licenses
  if errorlevel 1 exit /b 1
)

echo [GEN Android] Installing required Android SDK packages...
call "%SDKMANAGER%" --sdk_root="%SDK_ROOT%" ^
  "platform-tools" ^
  "build-tools;%SDK_BUILD_TOOLS_1%" ^
  "build-tools;%SDK_BUILD_TOOLS_2%" ^
  "platforms;android-%SDK_PLATFORM_1%" ^
  "platforms;android-%SDK_PLATFORM_2%" ^
  "platforms;android-%SDK_PLATFORM_3%"
if errorlevel 1 exit /b 1
exit /b 0

:ReadProperty
set "PROP_FILE=%~1"
set "PROP_KEY=%~2"
set "PROP_VALUE="
if not exist "%PROP_FILE%" exit /b 1
for /f "usebackq delims=" %%V in (`powershell.exe -NoProfile -Command "$k='%PROP_KEY%'; foreach ($line in Get-Content -LiteralPath '%PROP_FILE%') { if ($line -match ('^\s*' + [regex]::Escape($k) + '\s*=')) { ($line -split '=',2)[1].Trim(); break } }"`) do set "PROP_VALUE=%%V"
if not defined PROP_VALUE exit /b 1
exit /b 0

:ValidateSDK
set "SDKMANAGER=%SDK_ROOT%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMANAGER%" (
  echo [GEN Android] ERROR: sdkmanager not found: %SDKMANAGER%
  exit /b 1
)
call :ReadProperty "%SDK_ROOT%\platform-tools\source.properties" "Pkg.Revision" || (
  echo [GEN Android] ERROR: Could not read platform-tools version.
  exit /b 1
)
set "PLATFORM_TOOLS_VERSION=!PROP_VALUE!"
powershell.exe -NoProfile -Command "if ([version]'!PLATFORM_TOOLS_VERSION!' -lt [version]'%SDK_PLATFORM_TOOLS_MIN%') { exit 1 }"
if errorlevel 1 (
  echo [GEN Android] ERROR: platform-tools !PLATFORM_TOOLS_VERSION! is older than required minimum %SDK_PLATFORM_TOOLS_MIN%
  exit /b 1
)
if not exist "%SDK_ROOT%\build-tools\%SDK_BUILD_TOOLS_1%" (
  echo [GEN Android] ERROR: Missing Android build-tools %SDK_BUILD_TOOLS_1%
  exit /b 1
)
if not exist "%SDK_ROOT%\build-tools\%SDK_BUILD_TOOLS_2%" (
  echo [GEN Android] ERROR: Missing Android build-tools %SDK_BUILD_TOOLS_2%
  exit /b 1
)
for %%A in (%SDK_PLATFORM_1% %SDK_PLATFORM_2% %SDK_PLATFORM_3%) do (
  if not exist "%SDK_ROOT%\platforms\android-%%A" (
    echo [GEN Android] ERROR: Missing Android platform android-%%A
    exit /b 1
  )
)
echo [GEN Android] Android SDK validation OK ^(platform-tools !PLATFORM_TOOLS_VERSION!^).
exit /b 0

:InstallNDK
set "CURRENT_NDK="
if exist "%NDK_ROOT%\source.properties" (
  call :ReadProperty "%NDK_ROOT%\source.properties" "Pkg.Revision"
  if not errorlevel 1 set "CURRENT_NDK=!PROP_VALUE!"
  if "!CURRENT_NDK!"=="%NDK_REVISION%" if "%FORCE%"=="0" (
    echo [GEN Android] Android NDK %NDK_REVISION% ^(%NDK_RELEASE%^) already installed.
    exit /b 0
  )
  if "%FORCE%"=="0" (
    echo [GEN Android] ERROR: Android NDK already exists with revision '!CURRENT_NDK!'. Re-run with --force to replace it.
    exit /b 1
  )
) else if exist "%NDK_ROOT%" (
  if "%FORCE%"=="0" (
    echo [GEN Android] ERROR: Android NDK directory exists but source.properties is missing. Re-run with --force to replace it.
    exit /b 1
  )
)

set "NDK_ARCHIVE=%TMP_ROOT%\android-ndk-%NDK_RELEASE%-windows.zip"
set "NDK_EXTRACT=%TMP_ROOT%\ndk-extract"
call :Download "%NDK_WINDOWS_URL%" "%NDK_ARCHIVE%" || exit /b 1
echo [GEN Android] Verifying Android NDK SHA-1...
call :VerifySHA1 "%NDK_ARCHIVE%" "%NDK_WINDOWS_SHA1%" || exit /b 1

if exist "%NDK_EXTRACT%" rmdir /s /q "%NDK_EXTRACT%"
mkdir "%NDK_EXTRACT%" >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%NDK_ARCHIVE%' -DestinationPath '%NDK_EXTRACT%' -Force"
if errorlevel 1 exit /b 1
if not exist "%NDK_EXTRACT%\android-ndk-%NDK_RELEASE%\source.properties" (
  echo [GEN Android] ERROR: Unexpected Android NDK archive layout.
  exit /b 1
)
if exist "%NDK_ROOT%" rmdir /s /q "%NDK_ROOT%"
move "%NDK_EXTRACT%\android-ndk-%NDK_RELEASE%" "%NDK_ROOT%" >nul
if errorlevel 1 exit /b 1
exit /b 0

:ValidateNDK
if not exist "%NDK_ROOT%\source.properties" (
  echo [GEN Android] ERROR: Android NDK source.properties not found: %NDK_ROOT%
  exit /b 1
)
call :ReadProperty "%NDK_ROOT%\source.properties" "Pkg.Revision" || exit /b 1
if not "!PROP_VALUE!"=="%NDK_REVISION%" (
  echo [GEN Android] ERROR: Android NDK revision is '!PROP_VALUE!'; expected '%NDK_REVISION%'.
  exit /b 1
)
if not exist "%NDK_ROOT%\build\cmake\android.toolchain.cmake" (
  echo [GEN Android] ERROR: Android NDK CMake toolchain file is missing.
  exit /b 1
)
if not exist "%NDK_ROOT%\toolchains\llvm\prebuilt" (
  echo [GEN Android] ERROR: Android NDK LLVM prebuilt toolchain is missing.
  exit /b 1
)
echo [GEN Android] Android NDK validation OK ^(%NDK_REVISION% / %NDK_RELEASE%^).
exit /b 0

:Cleanup
if exist "%TMP_ROOT%" rmdir /s /q "%TMP_ROOT%"
exit /b 0

:failed
call :Cleanup
exit /b 1

:help
echo GEN Framework Android environment installer ^(Windows^)
echo.
echo Usage:
echo   InstallAndroid.bat [options]
echo.
echo Options:
echo   --check       Validate the current SDK/NDK installation; do not download.
echo   --force       Replace an existing SDK bootstrap/NDK when required.
echo   --sdk-only    Install or validate only the Android SDK.
echo   --ndk-only    Install or validate only the Android NDK.
echo   -h, --help    Show this help.
echo.
echo Environment:
echo   GEN_ANDROID_ACCEPT_LICENSES=1
echo   Automatically answers 'yes' to Android SDK license prompts.
echo   Otherwise sdkmanager --licenses is interactive.
exit /b 0
