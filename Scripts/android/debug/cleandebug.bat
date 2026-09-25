@echo off
setlocal

:: --- CONFIGURATION ---
:: Path to the lldb-server inside your GEN Framework ThirdParty
set NDK_SERVER_PATH="E:/Projects/GEN_FrameWork/ThirdPartyLibraries/android-ndk/toolchains/llvm/prebuilt/windows-x86_64/lib/clang/18/lib/linux/aarch64/lldb-server"
set DEVICE_TMP_PATH=/data/local/tmp
set PORT=5039

echo [1/4] Cleaning up previous debug sessions...
adb shell "pkill lldb-server"
adb forward --remove-all

echo [2/4] Pushing lldb-server to Android device...
adb push %NDK_SERVER_PATH% %DEVICE_TMP_PATH%/lldb-server
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to push lldb-server. Check if the path exists.
    pause
    exit /b
)

echo [3/4] Setting execution permissions on Android...
adb shell "chmod 777 %DEVICE_TMP_PATH%/lldb-server"

echo [4/4] Opening ADB network bridge (Port %PORT%)...
adb forward tcp:%PORT% tcp:%PORT%

echo.
echo === SETUP COMPLETE ===
echo You can now press F5 in Visual Studio.
echo Keep this window open if you want to see ADB logs.
echo.
pause