#-----------------------------------------------------------------------------
# GEN_Environment.cmake
# 
# This script sets up the environment variables for the GEN Framework,
# specifically focusing on Android NDK/SDK location within ThirdPartyLibraries.
#-----------------------------------------------------------------------------

if(ANDROID32 OR ANDROID64)

  # Forzamos a que la ruta sea absoluta desde el principio
  get_filename_component(GEN_THIRDPARTY_LIBRARIES_DIR "${GEN_DIRECTORY}/ThirdPartyLibraries" ABSOLUTE)

  #-----------------------------------------------------------------------------
  # Android NDK Configuration
  
  if(NOT DEFINED ANDROID_NDK)
    set(ANDROID_NDK "${GEN_THIRDPARTY_LIBRARIES_DIR}/android-ndk" CACHE PATH "GEN: Path to Android NDK" FORCE)
  endif()

  #-----------------------------------------------------------------------------
  # Android SDK Configuration
  
  if(NOT DEFINED ANDROID_SDK)
    set(ANDROID_SDK "${GEN_THIRDPARTY_LIBRARIES_DIR}/android-sdk" CACHE PATH "GEN: Path to Android SDK" FORCE)
  endif()

  #-----------------------------------------------------------------------------
  # Validation and Toolchain Force
  
  if(EXISTS "${ANDROID_NDK}")
    # Force the CMake Toolchain to use the NDK provided in ThirdPartyLibraries
    set(_GEN_ENV_NDK_TOOLCHAIN "${ANDROID_NDK}/build/CMake/android.toolchain.cmake")
    if(NOT EXISTS "${_GEN_ENV_NDK_TOOLCHAIN}")
      set(_GEN_ENV_NDK_TOOLCHAIN "${ANDROID_NDK}/build/cmake/android.toolchain.cmake")
    endif()
    if(EXISTS "${_GEN_ENV_NDK_TOOLCHAIN}")
      set(CMAKE_TOOLCHAIN_FILE "${_GEN_ENV_NDK_TOOLCHAIN}" CACHE FILEPATH "" FORCE)
    endif()
    
    message(STATUS "[ GEN Android Environment detected:")
    message(STATUS "      > NDK: ${ANDROID_NDK}")
    message(STATUS "      > SDK: ${ANDROID_SDK} ]")
  else()
    message(FATAL_ERROR "[GEN  Error: Android NDK not found at ${ANDROID_NDK}. Please check ThirdPartyLibraries folder. ]")
  endif()

endif()

#-----------------------------------------------------------------------------