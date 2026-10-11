# --------------------------------------------------------------------
# GEN_Platform-Compiler. INTEL 
# Main: Platform-Compiler 
# --------------------------------------------------------------------


# --------------------------------------------------------------------
# Params available

# INTEL32
# INTEL64
# ARM
# ARM64
# RPI32
# RPI64
# ANDROID
# STM32
# ESP32

# --------------------------------------------------------------------
# Variables assignated

# COMPILE_ON_WINDOWS              "Compile on Windows"
# COMPILE_ON_LINUX                "Compile on Linux"
# COMPILE_ON_WSL_LINUX            "Compile on WSL Linux"

# COMPILE_FOR_WINDOWS             "Compile to Windows General"
# COMPILE_FOR_WINDOWS_INTEL_32    "Compile to Windows PC 32 Bits"
# COMPILE_FOR_WINDOWS_INTEL_64    "Compile to Windows INTEL 64 Bits"

# COMPILE_FOR_LINUX               "Compile to Linux General"
# COMPILE_FOR_LINUX_INTEL_64      "Compile to Linux INTEL 64"
# COMPILE_FOR_LINUX_ARM           "Compile to Linux ARM"
# COMPILE_FOR_LINUX_ARM_64        "Compile to Linux ARM 64"
# COMPILE_FOR_LINUX_ARM_RPI       "Compile to Linux ARM Rapsberry Pi"
# COMPILE_FOR_LINUX_ARM_RPI_64    "Compile to Linux ARM Rapsberry Pi 64"  

# COMPILE_FOR_ANDROID32           "Compile to Android 32"
# COMPILE_FOR_ANDROID64           "Compile to Android 64"

# COMPILE_FOR_STM32               "Compile to STM32 General"

# COMPILE_FOR_ESP32               "Compile to ESP32 General"

# --------------------------------------------------------------------

# COMPILE_WITH_MSVC               "Compile Microsoft Compiler (MSVC)"
# COMPILE_WITH_GCC                "Compile GNU Compiler Collection (GCC)"
# COMPILE_WITH_CLANG              "Compile CLang (front-end of LLVM)"
# COMPILE_WITH_CLANG_CL           "Compile CLang CL (interfaz MSVC)"


# --------------------------------------------------------------------
# TARGET must survive ninja-driven reconfigures. Those re-runs do not pass
# -DTARGET again; if the cache was invalidated (e.g. compiler FORCE), restore
# from the environment (compile.py) or from the build directory layout.
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
    set(TARGET "ARM")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]rpi64[/\\\\]")
    set(TARGET "RPI64")
  elseif("${CMAKE_BINARY_DIR}" MATCHES "[/\\\\]rpi32[/\\\\]")
    set(TARGET "RPI32")
  endif()
endif()

if(NOT "${TARGET}" STREQUAL "")
  set(TARGET "${TARGET}" CACHE STRING "GEN compile target architecture" FORCE)
endif()

# Re-detect platform when the guard was set but a cache wipe left COMPILE_FOR_* empty.
set(_GEN_NEED_PLATFORM_DETECT FALSE)
if(NOT GEN_DETECT_PLATFORM_COMPILER)
  set(_GEN_NEED_PLATFORM_DETECT TRUE)
elseif((("${TARGET}" STREQUAL "INTEL32") OR ("${TARGET}" STREQUAL "INTEL64")) AND NOT COMPILE_FOR_WINDOWS)
  set(_GEN_NEED_PLATFORM_DETECT TRUE)
elseif((("${TARGET}" STREQUAL "ANDROID32") AND NOT COMPILE_FOR_ANDROID32) OR (("${TARGET}" STREQUAL "ANDROID64") AND NOT COMPILE_FOR_ANDROID64))
  set(_GEN_NEED_PLATFORM_DETECT TRUE)
endif()

if(_GEN_NEED_PLATFORM_DETECT)

  if(NOT GEN_MAIN_INIT)
  
    message(STATUS "[GEN]-------------------------------------------------------------------------------------------------------------------------------------[GEN]")  
    
  endif()
  
  option(GEN_DETECT_PLATFORM_COMPILER "Detect Platform Compiler" ON )

  # --- Cache Compiler ------------------------------------------------

  find_program(CCACHE_PROGRAM ccache)

  if(CCACHE_PROGRAM)

    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE_PROGRAM}")
    message(STATUS "[ GEN Found CCACHE ]")

  endif()

  message(STATUS "[ GEN Target for compile: ${TARGET} ]")

  if("${TARGET}" STREQUAL "")

    message(STATUS "[ GEN No Target for compile ]")

  endif()


  # --- Compile in Android Platform ------------------------------------

  if("${TARGET}" STREQUAL "ANDROID32")

    add_definitions(-DANDROID)
    add_definitions(-DANDROID32)
    
    option(COMPILE_FOR_ANDROID32                                 "Compile to Android 32"                                    ON )

    message(STATUS "[ GEN Compile for platform Android 32]")
            
  endif()
  
  
  if("${TARGET}" STREQUAL "ANDROID64")

    add_definitions(-DANDROID)
    add_definitions(-DANDROID64)
    
    option(COMPILE_FOR_ANDROID64                                  "Compile to Android 64"                                   ON )

    message(STATUS "[ GEN Compile for platform Android 64]")

  endif()

  
  # --- Compile in Windows Platform ------------------------------------


  if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  
    option(COMPILE_ON_WINDOWS                                     "Compile on Windows"                                      ON )

    message(STATUS "[ GEN Using Windows to compile ]")

    if(("${TARGET}" STREQUAL "INTEL32") OR ("${TARGET}" STREQUAL "INTEL64"))

      add_definitions(-DWINDOWS)
      add_definitions(-DHW_INTEL)

      option(COMPILE_FOR_WINDOWS                                  "Compile to Windows General"                              ON )

      if("${TARGET}" STREQUAL "INTEL64")

        add_definitions(-DHW_INTEL64)

        option(COMPILE_FOR_WINDOWS_INTEL_64                       "Compile to Windows Intel 64 Bits"                        ON )

        message(STATUS "[ GEN Compile for platform Windows INTEL 64 Bits ]")

      else()

        if("${TARGET}" STREQUAL "INTEL32")

          add_definitions(-DHW_INTEL32)

          option(COMPILE_FOR_WINDOWS_INTEL_32                     "Compile to Windows Intel 32 Bits"                        ON )

          message(STATUS "[ GEN Compile for platform Windows INTEL 32 Bits ]")

        endif()

      endif()

    endif()


    if("${TARGET}" STREQUAL "STM32")

      add_definitions(-DMICROCONTROLLER)
      add_definitions(-DHW_STM32)

      option(COMPILE_FOR_STM32                                    "Compile to STM32"                                        ON )

      message(STATUS "[ GEN Compile for platform STM32 ]")

    endif()
  
  
    if("${TARGET}" STREQUAL "ESP32")
 
      add_definitions(-DMICROCONTROLLER)
      add_definitions(-DHW_ESP32)

      option(COMPILE_FOR_ESP32                                    "Compile to ESP32"                                        ON )

      message(STATUS "[ GEN Compile for platform ESP32 ]")
 
    endif()

  endif()


  # --- Compile in Linux Platform ---------------------------------------

  if((${CMAKE_SYSTEM_NAME} MATCHES "Linux") AND NOT COMPILE_FOR_ANDROID32 AND NOT COMPILE_FOR_ANDROID64)

    add_definitions(-DLINUX) 

    option(COMPILE_ON_LINUX                                       "Compile on Linux"                                        ON )  

    
    # --- Use Linux with WSL ---------------------------------------
  
    file(READ "/proc/version" PROC_VERSION_CONTENT)

    if(PROC_VERSION_CONTENT MATCHES "Microsoft" OR PROC_VERSION_CONTENT MATCHES "WSL")

      option(COMPILE_ON_WSL_LINUX                                     "Compile on WSL Linux"                                    ON )  

    else()

      unset(COMPILE_ON_WSL_LINUX CACHE)

    endif()

  
    message(STATUS "[ GEN Using Linux to compile ]") 

    option(COMPILE_FOR_LINUX                                      "Compile to Linux General"                                ON )  

    if("${TARGET}" STREQUAL "INTEL64") 
 
      add_definitions(-DHW_INTEL)    
      add_definitions(-DHW_INTEL64)

      option(COMPILE_FOR_LINUX_INTEL_64                           "Compile to Linux INTEL 64 Bits"                          ON )

      message(STATUS "[ GEN Compile for platform Linux INTEL 64 Bits ]")

    endif()

    if("${TARGET}" STREQUAL "RPI32")

      add_definitions(-DHW_RASPBERRYPI) 
      add_definitions(-DHW_RASPBERRYPI32)

      option(COMPILE_FOR_LINUX_ARM_RPI                            "Compile to Linux Rapsberry Pi"                           ON )

      message(STATUS "[ GEN Compile for platform Linux Raspberry Pi 32 Bits ]")

    endif()

    if("${TARGET}" STREQUAL "RPI64")

      add_definitions(-DHW_RASPBERRYPI)   
      add_definitions(-DHW_RASPBERRYPI64)

      option(COMPILE_FOR_LINUX_ARM_RPI_64                         "Compile to Linux Rapsberry Pi 64"                        ON )

      message(STATUS "[ GEN Compile for platform Linux Raspberry Pi 64 Bits ]")

    endif()   

    if("${TARGET}" STREQUAL "ARM")

      add_definitions(-DHW_ARM) 
      add_definitions(-DHW_ARM32)

      option(COMPILE_FOR_LINUX_ARM                                "Compile to Linux ARM"                                    ON )

      message(STATUS "[ GEN Compile for platform Linux ARM ]")

    endif()

    if("${TARGET}" STREQUAL "ARM64")

      add_definitions(-DHW_ARM) 
      add_definitions(-DHW_ARM64)

      option(COMPILE_FOR_LINUX_ARM_64                             "Compile to Linux ARM 64"                                 ON )

      message(STATUS "[ GEN Compile for platform Linux ARM 64 Bits ]")

    endif()

  endif()


endif() # _GEN_NEED_PLATFORM_DETECT


# --- CLang compiler (every configure) ---------------------------------

set(USE_CLANG_CTRL_MSG "by External Config")

if("${USE_CLANG_EXTCFG}" STREQUAL "CLANG")

  option(USE_CLANG_CTRL_FEATURE  "Use CLang compiler Ctrl"  ON)

else()

  if("${USE_CLANG_EXTCFG}" STREQUAL "NOTCLANG")

    unset(USE_CLANG_CTRL_FEATURE     CACHE)
    unset(USE_CLANG_COMPILER_FEATURE CACHE)

  else()

    if(USE_CLANG_COMPILER_FEATURE)

      option(USE_CLANG_CTRL_FEATURE  "Use CLang compiler Ctrl"  ON)

    endif()

    set(USE_CLANG_CTRL_MSG "by Proyect")

  endif()

endif()

if(USE_CLANG_CTRL_FEATURE)

  if(COMPILE_FOR_WINDOWS)

    find_program(_CLANG_CL clang-cl)
    if(NOT _CLANG_CL)
      message(FATAL_ERROR "[ GEN Selected but clang-cl not found ]")
      unset(USE_CLANG_COMPILER_FEATURE CACHE)
      option(USE_CLANG_COMPILER_FEATURE                            "Use Clang Compiler"                                     OFF )
    endif()

  else()

    find_program(_CLANG clang)
    find_program(_CLANGXX clang++)

    if(NOT _CLANG OR NOT _CLANGXX)

      message(FATAL_ERROR "[ GEN Selected but clang/clang++ not found ]")

      unset(USE_CLANG_COMPILER_FEATURE CACHE)
      option(USE_CLANG_COMPILER_FEATURE                            "Use Clang Compiler"                                     OFF )

    endif()

  endif()

endif()


# --------------------------------------------------------------------
# Compiler setup must run on every configure — including cmake restarts
# triggered by changing CMAKE_C_COMPILER after project(). Skipping this
# when GEN_DETECT_PLATFORM_COMPILER is already ON drops /MACHINE and
# -m32/-m64 flags and produces broken INTEL32 ABI tests / missing sources.
# --------------------------------------------------------------------

if(COMPILE_FOR_WINDOWS)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Compiler_Windows.cmake")

  if(USE_CLANG_CTRL_FEATURE AND NOT COMPILE_WITH_CLANG_CL)

    unset(COMPILE_WITH_MSVC     CACHE)
    unset(COMPILE_WITH_CLANG_CL CACHE)

    add_definitions(-DCOMPILER_CLANG_CL)
    option(COMPILE_WITH_CLANG_CL                                "Compile with CLang (interface MSVC)"                     ON )
    message(STATUS "[ GEN Select for compile: CLang CLI (interface MSVC) ${USE_CLANG_CTRL_MSG} ]")

  endif()

endif()


if(COMPILE_FOR_LINUX)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Compiler_Linux.cmake")

  if(USE_CLANG_CTRL_FEATURE AND NOT COMPILE_WITH_CLANG)

    unset(COMPILE_WITH_GCC   CACHE)
    unset(COMPILE_WITH_CLANG CACHE)

    add_definitions(-DCOMPILER_CLANG)
    option(COMPILE_WITH_CLANG                                  "Compile with CLang (front-end of LLVM)"                  ON )
    message(STATUS "[ GEN Select for compile: CLang (front-end of LLVM) ${USE_CLANG_CTRL_MSG} ]")

  endif()

endif()


if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Compiler_Android.cmake")

endif()


if(COMPILE_FOR_STM32)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Compiler_STM32.cmake")

endif()


if(COMPILE_FOR_ESP32)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Compiler_ESP32.cmake")

endif()


if(NOT COMPILE_WITH_CLANG_CL AND NOT COMPILE_WITH_CLANG)

  if(CMAKE_C_COMPILER_ID MATCHES "^(Clang|AppleClang)$" OR CMAKE_CXX_COMPILER_ID MATCHES "^(Clang|AppleClang)$")

    if(CMAKE_C_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_FRONTEND_VARIANT STREQUAL "MSVC")

      add_definitions(-DCOMPILER_CLANG_CL)
      option(COMPILE_WITH_CLANG_CL                                "Compile with CLang (interface MSVC)"                     ON )
      message(STATUS "[ GEN Select for compile: CLang CLI (interface MSVC) ${USE_CLANG_CTRL_MSG} ]")

    else()

      add_definitions(-DCOMPILER_CLANG)
      option(COMPILE_WITH_CLANG                                   "Compile with CLang (front-end of LLVM)"                  ON )
      message(STATUS "[ GEN Select for compile: CLang (front-end of LLVM) ${USE_CLANG_CTRL_MSG} ]")

    endif()

  elseif(CMAKE_C_COMPILER_ID STREQUAL "MSVC" OR CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    add_definitions(-DCOMPILER_MSVC)
    option(COMPILE_WITH_MSVC                                      "Compile with Microsoft Compiler (MSVC)"                  ON )
    message(STATUS "[ GEN Select for compile: Microsoft Compiler (MSVC) ]")

  elseif(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

    add_definitions(-DCOMPILER_GCC)
    option(COMPILE_WITH_GCC                                       "Compile with GNU Compiler Collection (GCC)"              ON )
    message(STATUS "[ GEN Select for compile: GNU Compiler Collection (GCC) ]")

  endif()

endif() # NOT COMPILE_WITH_CLANG_CL
