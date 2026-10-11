# --------------------------------------------------------------------
# GEN_Main_Compiler_Windows.cmake
# Main: Windows Compiler
# --------------------------------------------------------------------


add_definitions(-D_CRT_SECURE_NO_WARNINGS)
add_compile_options(/utf-8)

set(CMAKE_RC_COMPILER rc.exe CACHE FILEPATH "" FORCE)
  
if(USE_CLANG_CTRL_FEATURE)

  # Resolve clang-cl to a full path once. Forcing the bare name "clang-cl" on
  # every configure makes CMake rewrite it to the absolute path and then treat
  # that as a cache-breaking compiler change on the next ninja reconfigure
  # (TARGET/COMPILE_FOR_* lost, INTEL32 ABI test fails with mainCRTStartup).
  find_program(_GEN_CLANG_CL NAMES clang-cl)
  if(NOT _GEN_CLANG_CL)
    message(FATAL_ERROR "[ GEN ] clang-cl not found in PATH")
  endif()

  get_filename_component(_GEN_CLANG_CL_ABS "${_GEN_CLANG_CL}" ABSOLUTE)
  get_filename_component(_GEN_CMAKE_C_ABS  "${CMAKE_C_COMPILER}" ABSOLUTE)
  get_filename_component(_GEN_CMAKE_CXX_ABS "${CMAKE_CXX_COMPILER}" ABSOLUTE)

  if(NOT _GEN_CMAKE_C_ABS STREQUAL _GEN_CLANG_CL_ABS)
    set(CMAKE_C_COMPILER "${_GEN_CLANG_CL_ABS}" CACHE FILEPATH "C compiler" FORCE)
  endif()
  if(NOT _GEN_CMAKE_CXX_ABS STREQUAL _GEN_CLANG_CL_ABS)
    set(CMAKE_CXX_COMPILER "${_GEN_CLANG_CL_ABS}" CACHE FILEPATH "CXX compiler" FORCE)
  endif()

  add_compile_definitions(NOMINMAX)
  if(NOT CMAKE_C_FLAGS MATCHES "NOMINMAX")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /DNOMINMAX" CACHE STRING "C flags" FORCE)
  endif()
  if(NOT CMAKE_CXX_FLAGS MATCHES "NOMINMAX")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /DNOMINMAX" CACHE STRING "CXX flags" FORCE)
  endif()


  if(COMPILE_FOR_WINDOWS_INTEL_32)

    # Persist arch flags in CACHE so the next project()-time try_compile
    # (ninja/cmake reconfigure) links as X86 instead of defaulting to x64.
    add_compile_options(/clang:-m32)
    add_link_options(/MACHINE:X86)
    if(NOT CMAKE_C_FLAGS MATCHES "clang:-m32")
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /clang:-m32" CACHE STRING "C flags" FORCE)
    endif()
    if(NOT CMAKE_CXX_FLAGS MATCHES "clang:-m32")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /clang:-m32" CACHE STRING "CXX flags" FORCE)
    endif()
    if(NOT CMAKE_EXE_LINKER_FLAGS MATCHES "MACHINE:X86")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MACHINE:X86" CACHE STRING "Exe linker flags" FORCE)
    endif()
    if(NOT CMAKE_SHARED_LINKER_FLAGS MATCHES "MACHINE:X86")
      set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MACHINE:X86" CACHE STRING "Shared linker flags" FORCE)
    endif()

  endif()


  if(COMPILE_FOR_WINDOWS_INTEL_64)

    add_compile_options(/clang:-m64)
    add_link_options(/MACHINE:X64)
    if(NOT CMAKE_C_FLAGS MATCHES "clang:-m64")
      set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /clang:-m64" CACHE STRING "C flags" FORCE)
    endif()
    if(NOT CMAKE_CXX_FLAGS MATCHES "clang:-m64")
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /clang:-m64" CACHE STRING "CXX flags" FORCE)
    endif()
    if(NOT CMAKE_EXE_LINKER_FLAGS MATCHES "MACHINE:X64")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /MACHINE:X64" CACHE STRING "Exe linker flags" FORCE)
    endif()
    if(NOT CMAKE_SHARED_LINKER_FLAGS MATCHES "MACHINE:X64")
      set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /MACHINE:X64" CACHE STRING "Shared linker flags" FORCE)
    endif()

  endif()


else()

 
  if(WINDOWS_APPMODE_DINAMIC)

    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL$<$<CONFIG:Debug>:Debug>")

  else()

    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

  endif()

endif()
