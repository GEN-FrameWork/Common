# --------------------------------------------------------------------
# GEN_Main_Compiler_Android.cmake
# Main: Android Compiler
# --------------------------------------------------------------------

add_definitions(-DANDROID)
add_definitions(-DIOAPI_NO_64)
add_definitions(-DFT_DEBUG_LEVEL_ERROR)
add_definitions(-DFT_DEBUG_LEVEL_TRACE)
add_definitions(-DFT2_BUILD_LIBRARY)

set(CMAKE_CXX_STANDARD 17)

set(GEN_ANDROID_NDK_ROOT "")

set(CMAKE_SYSTEM_NAME Android)
set(ANDROID_PLATFORM android-24)
set(ANDROID_STL c++_shared)


if(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT "${CMAKE_TOOLCHAIN_FILE}" STREQUAL "" AND EXISTS "${CMAKE_TOOLCHAIN_FILE}")
  get_filename_component(_GEN_ANDROID_TOOLCHAIN_DIR "${CMAKE_TOOLCHAIN_FILE}" DIRECTORY)
  get_filename_component(GEN_ANDROID_NDK_ROOT "${_GEN_ANDROID_TOOLCHAIN_DIR}/../.." ABSOLUTE)
endif()


if("${GEN_ANDROID_NDK_ROOT}" STREQUAL "")
  if(DEFINED GEN_DIRECTORY AND NOT "${GEN_DIRECTORY}" STREQUAL "")
    get_filename_component(GEN_ANDROID_NDK_ROOT "${GEN_DIRECTORY}/ThirdPartyLibraries/android-ndk" ABSOLUTE)
  endif()
endif()


if("${GEN_ANDROID_NDK_ROOT}" STREQUAL "")
  if(DEFINED GEN_DIRECTORY_THIRDPARTYLIBRARIES AND NOT "${GEN_DIRECTORY_THIRDPARTYLIBRARIES}" STREQUAL "")
    get_filename_component(GEN_ANDROID_NDK_ROOT "${GEN_DIRECTORY_THIRDPARTYLIBRARIES}/android-ndk" ABSOLUTE)
  endif()
endif()

if(NOT EXISTS "${GEN_ANDROID_NDK_ROOT}/build/CMake/android.toolchain.cmake")
  message(FATAL_ERROR
    "[ GEN Android] NDK not found. Checked root: ${GEN_ANDROID_NDK_ROOT}. "
    "Expected ThirdPartyLibraries/android-ndk/build/CMake/android.toolchain.cmake "
    "or a valid CMAKE_TOOLCHAIN_FILE passed before project().")
endif()


if(ANDROID32)

  set(ANDROID_ABI armeabi-v7a)

endif()


if(ANDROID64)

  set(ANDROID_ABI arm64-v8a)
  
endif()


if(NOT DEFINED ANDROID_ABI OR "${ANDROID_ABI}" STREQUAL "")
  set(ANDROID_ABI arm64-v8a)
endif()

if(NOT DEFINED ANDROID_PLATFORM OR "${ANDROID_PLATFORM}" STREQUAL "")
  set(ANDROID_PLATFORM android-24)
endif()

if(NOT DEFINED GEN_ANDROID_MIN_SDK OR "${GEN_ANDROID_MIN_SDK}" STREQUAL "")
  string(REGEX REPLACE "^android-" "" GEN_ANDROID_MIN_SDK "${ANDROID_PLATFORM}")
endif()

if(NOT DEFINED GEN_ANDROID_TARGET_SDK OR "${GEN_ANDROID_TARGET_SDK}" STREQUAL "")
  set(GEN_ANDROID_TARGET_SDK 35)
endif()

# Prefer the host-matching NDK prebuilt (GEN keeps only one flavor under ThirdPartyLibraries).
set(GEN_ANDROID_NDK_PREBUILT_DIR "")
if(CMAKE_HOST_WIN32)
  set(_GEN_ANDROID_PREFERRED_PREBUILT "${GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/windows-x86_64")
elseif(CMAKE_HOST_APPLE)
  set(_GEN_ANDROID_PREFERRED_PREBUILT "${GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/darwin-x86_64")
else()
  set(_GEN_ANDROID_PREFERRED_PREBUILT "${GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64")
endif()
if(EXISTS "${_GEN_ANDROID_PREFERRED_PREBUILT}")
  set(GEN_ANDROID_NDK_PREBUILT_DIR "${_GEN_ANDROID_PREFERRED_PREBUILT}")
else()
  file(GLOB _GEN_ANDROID_NDK_PREBUILT_DIRS "${GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/*")
  list(LENGTH _GEN_ANDROID_NDK_PREBUILT_DIRS _GEN_ANDROID_NDK_PREBUILT_DIRS_COUNT)
  if(_GEN_ANDROID_NDK_PREBUILT_DIRS_COUNT EQUAL 0)
    message(FATAL_ERROR "[ GEN Android] Could not find an LLVM prebuilt toolchain inside ${GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt")
  endif()
  list(GET _GEN_ANDROID_NDK_PREBUILT_DIRS 0 GEN_ANDROID_NDK_PREBUILT_DIR)
endif()

list(APPEND GEN_INCLUDES_DIR_LIST "${GEN_ANDROID_NDK_ROOT}/sources/android/native_app_glue")
list(APPEND GEN_INCLUDES_DIR_LIST "${GEN_ANDROID_NDK_PREBUILT_DIR}/sysroot/usr/include")

list(APPEND GEN_SOURCES_MODULES_LIST "${GEN_ANDROID_NDK_ROOT}/sources/android/native_app_glue/android_native_app_glue.c")
