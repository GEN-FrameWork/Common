# --------------------------------------------------------------------
# GEN_PreProject.cmake
#
# Include this BEFORE project() in application CMakeLists.txt:
#
#   cmake_minimum_required(VERSION 3.16.0)
#   set(GEN_DIRECTORY "../..")   # relative to that app's CMake/ folder
#   option(USE_CLANG_COMPILER_FEATURE "Use Clang Compiler" ON)   # optional but recommended here
#   include("${GEN_DIRECTORY}/Common/CMake/GEN_PreProject.cmake")
#   project(myapp)
#   ...
#   include("${GEN_DIRECTORY}/Common/CMake/GEN_Main.cmake")
#
# Purpose: seed CMAKE_C_COMPILER / CMAKE_CXX_COMPILER (and INTEL32/64 arch
# INIT flags on Windows) before project() locks the toolchain.
#
# GEN_Main must NOT FORCE the compiler after project() on Windows (INTEL32
# try_compile / mainCRTStartup). This file is the supported replacement.
#
# Priority (highest first):
#   1. Already set CMAKE_C_COMPILER / CMAKE_CXX_COMPILER (preset, -D, compile.py)
#   2. USE_CLANG_EXTCFG=NOTCLANG  → do not seed Clang
#   3. USE_CLANG_EXTCFG=CLANG    → seed Clang
#   4. USE_CLANG_COMPILER_FEATURE (option/cache) if already defined
#   5. Default: seed Clang on Windows/Linux host targets (matches typical app ON)
#
# Android / ESP32 / STM32: do not replace the NDK/embedded toolchain; only
# help locate the Android NDK toolchain file when GEN_DIRECTORY is set.
#
# Not wired into apps yet — include manually when ready.
# --------------------------------------------------------------------

if(GEN_PREPROJECT_INCLUDED)
  return()
endif()
set(GEN_PREPROJECT_INCLUDED TRUE)


# --------------------------------------------------------------------
# Resolve TARGET early (preset / -D / env / binary dir layout)
# --------------------------------------------------------------------

if("${TARGET}" STREQUAL "")
  if(DEFINED ENV{TARGET} AND NOT "$ENV{TARGET}" STREQUAL "")
    set(TARGET "$ENV{TARGET}")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]intel64[/\\\\]")
    set(TARGET "INTEL64")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]intel32[/\\\\]")
    set(TARGET "INTEL32")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]android64[/\\\\]")
    set(TARGET "ANDROID64")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]android32[/\\\\]")
    set(TARGET "ANDROID32")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]arm64[/\\\\]")
    set(TARGET "ARM64")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]arm[/\\\\]")
    set(TARGET "ARM32")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]rpi64[/\\\\]")
    set(TARGET "RPI64")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]rpi32[/\\\\]")
    set(TARGET "RPI32")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]stm32[/\\\\]")
    set(TARGET "STM32")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]esp32[/\\\\]")
    set(TARGET "ESP32")
  endif()
endif()

if(NOT "${TARGET}" STREQUAL "")
  set(TARGET "${TARGET}" CACHE STRING "GEN compile target architecture" FORCE)
endif()


# --------------------------------------------------------------------
# Decide whether to seed a Clang driver
# --------------------------------------------------------------------

set(_GEN_PRE_USE_CLANG_EXTCFG "")
if(DEFINED USE_CLANG_EXTCFG)
  set(_GEN_PRE_USE_CLANG_EXTCFG "${USE_CLANG_EXTCFG}")
elseif(DEFINED ENV{USE_CLANG_EXTCFG})
  set(_GEN_PRE_USE_CLANG_EXTCFG "$ENV{USE_CLANG_EXTCFG}")
endif()
string(TOUPPER "${_GEN_PRE_USE_CLANG_EXTCFG}" _GEN_PRE_USE_CLANG_EXTCFG)

set(_GEN_PRE_WANT_CLANG FALSE)

if("${_GEN_PRE_USE_CLANG_EXTCFG}" STREQUAL "NOTCLANG")
  set(_GEN_PRE_WANT_CLANG FALSE)
elseif("${_GEN_PRE_USE_CLANG_EXTCFG}" STREQUAL "CLANG")
  set(_GEN_PRE_WANT_CLANG TRUE)
elseif(DEFINED USE_CLANG_COMPILER_FEATURE)
  if(USE_CLANG_COMPILER_FEATURE)
    set(_GEN_PRE_WANT_CLANG TRUE)
  endif()
else()
  # Option not declared yet: default ON for desktop hosts (same as most apps).
  set(_GEN_PRE_WANT_CLANG TRUE)
endif()


# Compilers already chosen by the caller → never override.
set(_GEN_PRE_COMPILER_ALREADY_SET FALSE)
if(CMAKE_C_COMPILER OR CMAKE_CXX_COMPILER)
  set(_GEN_PRE_COMPILER_ALREADY_SET TRUE)
endif()


# --------------------------------------------------------------------
# Android: NDK toolchain before project(); do not seed host clang/cl
# --------------------------------------------------------------------

set(_GEN_PRE_IS_ANDROID FALSE)
if("${TARGET}" STREQUAL "ANDROID32" OR "${TARGET}" STREQUAL "ANDROID64")
  set(_GEN_PRE_IS_ANDROID TRUE)
endif()

if(_GEN_PRE_IS_ANDROID)

  if(NOT CMAKE_TOOLCHAIN_FILE OR "${CMAKE_TOOLCHAIN_FILE}" STREQUAL "")
    if(DEFINED GEN_DIRECTORY AND NOT "${GEN_DIRECTORY}" STREQUAL "")
      get_filename_component(_GEN_PRE_NDK_TOOLCHAIN
        "${GEN_DIRECTORY}/ThirdPartyLibraries/android-ndk/build/CMake/android.toolchain.cmake"
        ABSOLUTE)
      if(NOT EXISTS "${_GEN_PRE_NDK_TOOLCHAIN}")
        # Official NDK on Linux uses build/cmake (lowercase); InstallAndroid.bash may symlink CMake.
        get_filename_component(_GEN_PRE_NDK_TOOLCHAIN
          "${GEN_DIRECTORY}/ThirdPartyLibraries/android-ndk/build/cmake/android.toolchain.cmake"
          ABSOLUTE)
      endif()
      if(EXISTS "${_GEN_PRE_NDK_TOOLCHAIN}")
        set(CMAKE_TOOLCHAIN_FILE "${_GEN_PRE_NDK_TOOLCHAIN}" CACHE FILEPATH "Android NDK toolchain" FORCE)
        message(STATUS "[ GEN PreProject ] Android CMAKE_TOOLCHAIN_FILE → ${CMAKE_TOOLCHAIN_FILE}")
      else()
        message(STATUS "[ GEN PreProject ] Android: NDK toolchain not found under android-ndk/build/CMake or build/cmake (pass CMAKE_TOOLCHAIN_FILE before project()).")
      endif()
    endif()
  endif()

  if("${TARGET}" STREQUAL "ANDROID32" AND NOT ANDROID_ABI)
    set(ANDROID_ABI "armeabi-v7a" CACHE STRING "" FORCE)
  endif()
  if("${TARGET}" STREQUAL "ANDROID64" AND NOT ANDROID_ABI)
    set(ANDROID_ABI "arm64-v8a" CACHE STRING "" FORCE)
  endif()
  if(NOT ANDROID_PLATFORM)
    set(ANDROID_PLATFORM "android-24" CACHE STRING "" FORCE)
  endif()

  message(STATUS "[ GEN PreProject ] Android target ${TARGET} — host compiler seeding skipped (NDK toolchain).")
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()

endif()


# --------------------------------------------------------------------
# Embedded: leave to GEN_Main_Compiler_* after project()
# --------------------------------------------------------------------

if("${TARGET}" STREQUAL "STM32" OR "${TARGET}" STREQUAL "ESP32")
  message(STATUS "[ GEN PreProject ] ${TARGET} — embedded toolchain left to GEN_Main (no host Clang seed).")
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()
endif()


if(_GEN_PRE_COMPILER_ALREADY_SET)
  message(STATUS "[ GEN PreProject ] Compiler already set (C=${CMAKE_C_COMPILER}, CXX=${CMAKE_CXX_COMPILER}) — seeding skipped.")
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()
endif()


if(NOT _GEN_PRE_WANT_CLANG)
  message(STATUS "[ GEN PreProject ] Clang seeding disabled (NOTCLANG or USE_CLANG_COMPILER_FEATURE OFF).")
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()
endif()


# --------------------------------------------------------------------
# Windows host: clang-cl + INTEL32/64 INIT flags
# --------------------------------------------------------------------

if(WIN32)

  find_program(_GEN_PRE_CLANG_CL NAMES clang-cl)
  if(NOT _GEN_PRE_CLANG_CL)
    message(WARNING "[ GEN PreProject ] clang-cl not found in PATH — project() will keep the default MSVC toolchain.")
  else()
    set(CMAKE_C_COMPILER   "${_GEN_PRE_CLANG_CL}" CACHE FILEPATH "C compiler" FORCE)
    set(CMAKE_CXX_COMPILER "${_GEN_PRE_CLANG_CL}" CACHE FILEPATH "CXX compiler" FORCE)

    if("${TARGET}" STREQUAL "INTEL32")
      set(CMAKE_C_FLAGS_INIT               "/clang:-m32 /DNOMINMAX" CACHE STRING "" FORCE)
      set(CMAKE_CXX_FLAGS_INIT             "/clang:-m32 /DNOMINMAX" CACHE STRING "" FORCE)
      set(CMAKE_EXE_LINKER_FLAGS_INIT      "/MACHINE:X86"          CACHE STRING "" FORCE)
      set(CMAKE_SHARED_LINKER_FLAGS_INIT   "/MACHINE:X86"          CACHE STRING "" FORCE)
      set(CMAKE_MODULE_LINKER_FLAGS_INIT   "/MACHINE:X86"          CACHE STRING "" FORCE)
    elseif("${TARGET}" STREQUAL "INTEL64")
      set(CMAKE_C_FLAGS_INIT               "/clang:-m64 /DNOMINMAX" CACHE STRING "" FORCE)
      set(CMAKE_CXX_FLAGS_INIT             "/clang:-m64 /DNOMINMAX" CACHE STRING "" FORCE)
      set(CMAKE_EXE_LINKER_FLAGS_INIT      "/MACHINE:X64"          CACHE STRING "" FORCE)
      set(CMAKE_SHARED_LINKER_FLAGS_INIT   "/MACHINE:X64"          CACHE STRING "" FORCE)
      set(CMAKE_MODULE_LINKER_FLAGS_INIT   "/MACHINE:X64"          CACHE STRING "" FORCE)
    endif()

    message(STATUS "[ GEN PreProject ] Windows seeded clang-cl (${_GEN_PRE_CLANG_CL}) for TARGET=${TARGET}")
  endif()

  unset(_GEN_PRE_CLANG_CL CACHE)
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()

endif()


# --------------------------------------------------------------------
# Linux (and other UNIX hosts): clang / clang++ (+ cross --target hints)
# Cross sysroot / -L paths remain in GEN_Main_Compiler_Linux.cmake after project().
# --------------------------------------------------------------------

if(UNIX AND NOT APPLE)

  find_program(_GEN_PRE_CLANG   NAMES clang)
  find_program(_GEN_PRE_CLANGXX NAMES clang++)
  if(NOT _GEN_PRE_CLANG OR NOT _GEN_PRE_CLANGXX)
    message(WARNING "[ GEN PreProject ] clang/clang++ not found in PATH — project() will keep the default host toolchain.")
  else()
    set(CMAKE_C_COMPILER   "${_GEN_PRE_CLANG}"   CACHE FILEPATH "C compiler" FORCE)
    set(CMAKE_CXX_COMPILER "${_GEN_PRE_CLANGXX}" CACHE FILEPATH "CXX compiler" FORCE)

    if("${TARGET}" STREQUAL "ARM32" OR "${TARGET}" STREQUAL "ARM" OR "${TARGET}" STREQUAL "RPI32")
      set(CMAKE_C_COMPILER_TARGET   "arm-linux-gnueabihf" CACHE STRING "" FORCE)
      set(CMAKE_CXX_COMPILER_TARGET "arm-linux-gnueabihf" CACHE STRING "" FORCE)
      set(CMAKE_C_FLAGS_INIT   "--target=arm-linux-gnueabihf -mfpu=neon" CACHE STRING "" FORCE)
      set(CMAKE_CXX_FLAGS_INIT "--target=arm-linux-gnueabihf -mfpu=neon" CACHE STRING "" FORCE)
    elseif("${TARGET}" STREQUAL "ARM64" OR "${TARGET}" STREQUAL "RPI64")
      set(CMAKE_C_COMPILER_TARGET   "aarch64-linux-gnu" CACHE STRING "" FORCE)
      set(CMAKE_CXX_COMPILER_TARGET "aarch64-linux-gnu" CACHE STRING "" FORCE)
      set(CMAKE_C_FLAGS_INIT   "--target=aarch64-linux-gnu" CACHE STRING "" FORCE)
      set(CMAKE_CXX_FLAGS_INIT "--target=aarch64-linux-gnu" CACHE STRING "" FORCE)
    endif()

    message(STATUS "[ GEN PreProject ] Linux seeded clang (${_GEN_PRE_CLANG}) for TARGET=${TARGET}")
  endif()

  unset(_GEN_PRE_CLANG CACHE)
  unset(_GEN_PRE_CLANGXX CACHE)
  unset(_GEN_PRE_USE_CLANG_EXTCFG)
  unset(_GEN_PRE_WANT_CLANG)
  unset(_GEN_PRE_COMPILER_ALREADY_SET)
  unset(_GEN_PRE_IS_ANDROID)
  return()

endif()


message(STATUS "[ GEN PreProject ] No host seeding for this platform (APPLE or unknown). TARGET=${TARGET}")
unset(_GEN_PRE_USE_CLANG_EXTCFG)
unset(_GEN_PRE_WANT_CLANG)
unset(_GEN_PRE_COMPILER_ALREADY_SET)
unset(_GEN_PRE_IS_ANDROID)
