# --------------------------------------------------------------------
# GEN_Main_Compiler_Windows.cmake
# Main: Windows Compiler
# --------------------------------------------------------------------


add_definitions(-D_CRT_SECURE_NO_WARNINGS)
add_compile_options(/utf-8)

# Never FORCE CMAKE_RC_COMPILER: CMake treats that as "compilers changed" and
# asks for Delete Cache / restarts ABI detection (often broken under VS+clang-cl).
if(NOT CMAKE_RC_COMPILER)
  set(CMAKE_RC_COMPILER "rc.exe" CACHE FILEPATH "Resource compiler")
endif()


# Strip any prior /MACHINE:* then apply the one we need (avoids X64 leftovers
# in an INTEL32 build dir — last flag wins with lld-link).
macro(_GEN_WIN_SET_LINKER_MACHINE _machine)
  foreach(_gen_lf CMAKE_EXE_LINKER_FLAGS CMAKE_SHARED_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS)
    if(DEFINED ${_gen_lf})
      set(_gen_lv "${${_gen_lf}}")
      string(REGEX REPLACE "/[Mm][Aa][Cc][Hh][Ii][Nn][Ee]:[A-Za-z0-9]+" "" _gen_lv "${_gen_lv}")
      string(STRIP "${_gen_lv}" _gen_lv)
      set(${_gen_lf} "${_gen_lv} /MACHINE:${_machine}" CACHE STRING "" FORCE)
    else()
      set(${_gen_lf} "/MACHINE:${_machine}" CACHE STRING "" FORCE)
    endif()
  endforeach()
  add_link_options(/MACHINE:${_machine})
endmacro()


macro(_GEN_WIN_SET_CLANG_MFLAG _mflag)
  foreach(_gen_cf CMAKE_C_FLAGS CMAKE_CXX_FLAGS)
    if(DEFINED ${_gen_cf})
      set(_gen_cv "${${_gen_cf}}")
      string(REGEX REPLACE "/clang:-m(32|64)" "" _gen_cv "${_gen_cv}")
      string(STRIP "${_gen_cv}" _gen_cv)
      if(NOT _gen_cv MATCHES "NOMINMAX")
        # keep existing content; NOMINMAX added separately below
      endif()
      set(${_gen_cf} "${_gen_cv} /clang:-${_mflag}" CACHE STRING "" FORCE)
    else()
      set(${_gen_cf} "/clang:-${_mflag}" CACHE STRING "" FORCE)
    endif()
  endforeach()
  add_compile_options(/clang:-${_mflag})
endmacro()


if(USE_CLANG_CTRL_FEATURE)

  find_program(_GEN_CLANG_CL NAMES clang-cl)
  if(NOT _GEN_CLANG_CL)
    message(FATAL_ERROR "[ GEN ] clang-cl not found in PATH")
  endif()

  get_filename_component(_GEN_CLANG_CL_ABS "${_GEN_CLANG_CL}" ABSOLUTE)
  get_filename_component(_GEN_CMAKE_C_ABS  "${CMAKE_C_COMPILER}" ABSOLUTE)
  get_filename_component(_GEN_CMAKE_CXX_ABS "${CMAKE_CXX_COMPILER}" ABSOLUTE)

  # Do NOT FORCE CMAKE_C_COMPILER / CMAKE_CXX_COMPILER after project().
  # Forcing them makes CMake restart configure and re-run try_compile; under the
  # VS INTEL32 preset (msvc_x86_x64 LIB paths) that often fails with:
  #   lld-link: undefined symbol: mainCRTStartup
  # Arch/compiler are seeded by CMakePresets.json (*_INIT / CMAKE_C_COMPILER)
  # before project() — GEN_Main cannot set those in time.
  if(NOT _GEN_CMAKE_C_ABS STREQUAL _GEN_CLANG_CL_ABS)
    message(STATUS "[ GEN ] C compiler is ${_GEN_CMAKE_C_ABS} (clang-cl at ${_GEN_CLANG_CL_ABS}). Not forcing cache — set CMAKE_C_COMPILER in the Windows CMake preset.")
  endif()
  if(NOT _GEN_CMAKE_CXX_ABS STREQUAL _GEN_CLANG_CL_ABS)
    message(STATUS "[ GEN ] CXX compiler is ${_GEN_CMAKE_CXX_ABS} (clang-cl at ${_GEN_CLANG_CL_ABS}). Not forcing cache — set CMAKE_CXX_COMPILER in the Windows CMake preset.")
  endif()

  add_compile_definitions(NOMINMAX)
  if(NOT CMAKE_C_FLAGS MATCHES "NOMINMAX")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /DNOMINMAX" CACHE STRING "C flags" FORCE)
  endif()
  if(NOT CMAKE_CXX_FLAGS MATCHES "NOMINMAX")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /DNOMINMAX" CACHE STRING "CXX flags" FORCE)
  endif()


  if(COMPILE_FOR_WINDOWS_INTEL_32)

    _GEN_WIN_SET_CLANG_MFLAG(m32)
    _GEN_WIN_SET_LINKER_MACHINE(X86)

  endif()


  if(COMPILE_FOR_WINDOWS_INTEL_64)

    _GEN_WIN_SET_CLANG_MFLAG(m64)
    _GEN_WIN_SET_LINKER_MACHINE(X64)

  endif()


else()


  if(WINDOWS_APPMODE_DINAMIC)

    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")

  else()

    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

  endif()

endif()
