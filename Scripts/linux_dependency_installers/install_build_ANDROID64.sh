#!/bin/sh

# Install dependencies (Android 64 / NDK host tools) (PC host)
# Cross-compile uses the Android NDK from ThirdPartyLibraries (mounted into the
# container). This script only installs host-side tools for cmake/ninja and APK
# packaging (aapt/zipalign/apksigner/keytool live in the SDK/NDK tree).

apt-get update
echo "-----------------------------------------------------------------------"
echo "Compiler and Debugger"
echo "Compilers C++"
apt-get install build-essential -y
echo "cmake"
apt-get install cmake -y
echo "ccache"
apt-get install ccache -y
echo "Compiler"
apt-get install g++ -y
echo "Debugger"
apt-get install gdb -y
echo "Compiler script"
apt-get install make -y
echo "Compiler script"
apt-get install ninja-build -y
echo "rsync"
apt-get install rsync -y
echo "Zip compression"
apt-get install zip -y
echo "-----------------------------------------------------------------------"
echo "Android APK packaging"
echo "Java (keytool / apksigner)"
apt-get install default-jre-headless -y
echo "-----------------------------------------------------------------------"
apt --fix-broken install -y
