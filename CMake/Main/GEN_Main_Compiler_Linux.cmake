# --------------------------------------------------------------------
# GEN_Main_Compiler_Linux.cmake
# Main: Linux Compiler
# --------------------------------------------------------------------



if(LINUX_X11_FEATURE)

  add_definitions(-DLINUX_X11_ACTIVE)

endif()


if(LINUX_WAYLAND_FEATURE)

  find_package(PkgConfig QUIET)

  set(GEN_LINUX_WAYLAND_DEPS_FOUND FALSE)

  if(PKG_CONFIG_FOUND)

    pkg_check_modules(GEN_WAYLAND_CLIENT     QUIET wayland-client)
    pkg_check_modules(GEN_WAYLAND_CURSOR     QUIET wayland-cursor)
    pkg_check_modules(GEN_WAYLAND_PROTOCOLS  QUIET wayland-protocols)
    pkg_check_modules(GEN_XKBCOMMON          QUIET xkbcommon)

    find_program(GEN_WAYLAND_SCANNER wayland-scanner)

    if(GEN_WAYLAND_CLIENT_FOUND AND GEN_WAYLAND_CURSOR_FOUND AND GEN_WAYLAND_PROTOCOLS_FOUND AND GEN_XKBCOMMON_FOUND AND GEN_WAYLAND_SCANNER)

      # GLES blitter is always compiled with GRP_FEATURE on Linux, so Wayland needs wayland-egl.
      pkg_check_modules(GEN_WAYLAND_EGL QUIET wayland-egl)

      if(GEN_WAYLAND_EGL_FOUND)
        set(GEN_LINUX_WAYLAND_DEPS_FOUND TRUE)
      endif()

    endif()

  endif()

  if(GEN_LINUX_WAYLAND_DEPS_FOUND)
    add_definitions(-DLINUX_WAYLAND_ACTIVE)
    set(GEN_LINUX_WAYLAND_ACTIVE TRUE)
    message(STATUS "[ GEN Linux Wayland dependencies found -- LINUX_WAYLAND_ACTIVE enabled ]")
  else()
    message(STATUS "[ GEN Linux Wayland dependencies NOT found ... -- LINUX_WAYLAND_ACTIVE disabled, X11/FrameBuffer paths unaffected ]")
  endif()

endif()


if(LINUX_VISUALSTUDIO_CP1252_FEATURE)

  if(COMPILE_WITH_GCC)                                                                            # -finput-charset is GCC-only; clang does not support it
    set(CMAKE_CXX_FLAGS "-finput-charset=CP1252")
  endif()

endif()


if(LINUX_VISUALSTUDIOUTF8_FEATURE)

  if(COMPILE_WITH_GCC)                                                                            # -finput-charset is GCC-only; clang does not support it
    set(CMAKE_CXX_FLAGS "-finput-charset=UTF-8")
  endif()

endif()


# ----------------------------------------
# INTEL 64

if(COMPILE_FOR_LINUX_INTEL_64)

  if(USE_CLANG_CTRL_FEATURE)

    set(CMAKE_C_COMPILER   clang   CACHE FILEPATH "" FORCE)
    set(CMAKE_CXX_COMPILER clang++ CACHE FILEPATH "" FORCE)

  endif()

endif()


# ----------------------------------------
# Platform Raspberry Pi 32

if(COMPILE_FOR_LINUX_ARM_RPI)

  set(CMAKE_SYSTEM_NAME Linux)
  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(RPI_ROOT    "/usr/rpi")
  set(RPI_TOOLS   "${RPI_ROOT}/tools/arm-bcm2708/arm-linux-gnueabihf")
  set(RPI_SYSROOT "${RPI_ROOT}/sysroot")

  set(CMAKE_C_COMPILER_LAUNCHER "ccache")
  set(CMAKE_CXX_COMPILER_LAUNCHER "ccache")

  list(APPEND GEN_INCLUDES_DIR_LIST "${RPI_SYSROOT}/usr/include/arm-linux-gnueabihf/")

  if(USE_CLANG_CTRL_FEATURE)

    set(CMAKE_C_COMPILER   clang   CACHE FILEPATH "" FORCE)
    set(CMAKE_CXX_COMPILER clang++ CACHE FILEPATH "" FORCE)

    set(CMAKE_C_COMPILER_TARGET   arm-linux-gnueabihf)
    set(CMAKE_CXX_COMPILER_TARGET arm-linux-gnueabihf)

  else()

    set(CMAKE_C_COMPILER   "${RPI_TOOLS}/bin/arm-linux-gnueabihf-gcc")
    set(CMAKE_CXX_COMPILER "${RPI_TOOLS}/bin/arm-linux-gnueabihf-g++")

  endif()

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")

  set(CMAKE_SYSROOT ${RPI_SYSROOT})

  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

  set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE armhf)

endif()


# ----------------------------------------
# Platform ARM 32

if(COMPILE_FOR_LINUX_ARM)

  set(CMAKE_SYSTEM_PROCESSOR arm)

  set(ARM_TOOLS "/usr")
  list(APPEND GEN_INCLUDES_DIR_LIST "${ARM_TOOLS}/include/")
  list(APPEND GEN_INCLUDES_DIR_LIST "${ARM_TOOLS}/lib/arm-linux-gnueabihf/dbus-1.0/include/")  # dbus-arch-deps.h cross path for ARM32
  list(APPEND GEN_INCLUDES_DIR_LIST "${ARM_TOOLS}/lib/arm-linux-gnueabihf/glib-2.0/include/")  # glibconfig.h cross path for ARM32 (libglib2.0-dev:armhf)

  set(CMAKE_C_COMPILER_LAUNCHER "ccache")
  set(CMAKE_CXX_COMPILER_LAUNCHER "ccache")

  if(USE_CLANG_CTRL_FEATURE)

    set(CMAKE_C_COMPILER   clang   CACHE FILEPATH "" FORCE)
    set(CMAKE_CXX_COMPILER clang++ CACHE FILEPATH "" FORCE)
    set(CMAKE_C_COMPILER_TARGET   arm-linux-gnueabihf)
    set(CMAKE_CXX_COMPILER_TARGET arm-linux-gnueabihf)
    # Force --target + NEON explicitly for Clang ARM32 cross-compilation
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   --target=arm-linux-gnueabihf -mfpu=neon")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --target=arm-linux-gnueabihf -mfpu=neon")
    # Restrict linker search to ARM32 libs — avoids picking up incompatible amd64 libs (X11, Xext, Xrandr, Xxf86vm, etc.)
    set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    -L/usr/lib/arm-linux-gnueabihf -L/usr/arm-linux-gnueabihf/lib")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L/usr/lib/arm-linux-gnueabihf -L/usr/arm-linux-gnueabihf/lib")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -L/usr/lib/arm-linux-gnueabihf -L/usr/arm-linux-gnueabihf/lib")

  else()

    set(CMAKE_C_COMPILER   "${ARM_TOOLS}/bin/arm-linux-gnueabihf-gcc")
    set(CMAKE_CXX_COMPILER "${ARM_TOOLS}/bin/arm-linux-gnueabihf-g++")

    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -mfpu=neon")                                            # Enable NEON intrinsics (arm_neon.h) for ARM 32-bit GCC — required by OpenAL convolution.cpp
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon")

  endif()

  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

endif()


# ----------------------------------------
# Platform RPi/ARM 64

if(COMPILE_FOR_LINUX_ARM_64 OR COMPILE_FOR_LINUX_ARM_RPI_64)

  if(COMPILE_FOR_LINUX_ARM_RPI_64)

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fpermissive")

  endif()

  set(CMAKE_SYSTEM_PROCESSOR aarch64)

  list(APPEND GEN_INCLUDES_DIR_LIST "/usr/include/")
  list(APPEND GEN_INCLUDES_DIR_LIST "/usr/lib/aarch64-linux-gnu/dbus-1.0/include/")  # dbus-arch-deps.h cross path for ARM64 (libdbus-1-dev:arm64)
  list(APPEND GEN_INCLUDES_DIR_LIST "/usr/lib/aarch64-linux-gnu/glib-2.0/include/")  # glibconfig.h cross path for ARM64 (libglib2.0-dev:arm64)

  set(ARM64_TOOLS "/usr")

  set(CMAKE_C_COMPILER_LAUNCHER "ccache")
  set(CMAKE_CXX_COMPILER_LAUNCHER "ccache")

  if(USE_CLANG_CTRL_FEATURE)

    set(CMAKE_C_COMPILER   clang   CACHE FILEPATH "" FORCE)
    set(CMAKE_CXX_COMPILER clang++ CACHE FILEPATH "" FORCE)
    set(CMAKE_C_COMPILER_TARGET   aarch64-linux-gnu)
    set(CMAKE_CXX_COMPILER_TARGET aarch64-linux-gnu)
    # Force --target flag explicitly so Clang uses AArch64 (not host ARM32 soft-float)
    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   --target=aarch64-linux-gnu")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --target=aarch64-linux-gnu")
    # Restrict linker search to AArch64 libs — avoids "skipping incompatible arm-linux-gnueabihf" warnings
    set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")

  else()

    set(CMAKE_C_COMPILER   "${ARM64_TOOLS}/bin/aarch64-linux-gnu-gcc")
    set(CMAKE_CXX_COMPILER "${ARM64_TOOLS}/bin/aarch64-linux-gnu-g++")
    # Restrict linker search to AArch64 libs — avoids "skipping incompatible arm-linux-gnueabihf" warnings
    set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -L/usr/lib/aarch64-linux-gnu -L/usr/aarch64-linux-gnu/lib")

  endif()

  set(CMAKE_FIND_ROOT_PATH "${ARM64_TOOLS}/aarch64-linux-gnu" "/${ARM64_TOOLS}/lib/aarch64-linux-gnu" "/${ARM64_TOOLS}/include/aarch64-linux-gnu")

  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

endif()


if(USE_CLANG_CTRL_FEATURE OR COMPILE_WITH_CLANG)

  #set(CMAKE_C_FLAGS   "-fdeclspec --std=c++0x")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdeclspec")

endif()
