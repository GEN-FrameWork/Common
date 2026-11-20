# --------------------------------------------------------------------
# GEN_Main_Warnings.cmake
# Main: Warning control (for compile)
# --------------------------------------------------------------------


function(gen_filter_supported_compiler_flags OUTPUT_VAR LANG)

  # Pick the right compiler binary, language tag and compiler ID
  if("${LANG}" STREQUAL "C")
    set(_gen_compiler    "${CMAKE_C_COMPILER}")
    set(_gen_compiler_id "${CMAKE_C_COMPILER_ID}")
    set(_gen_xlang       "c")
  elseif("${LANG}" STREQUAL "CXX")
    set(_gen_compiler    "${CMAKE_CXX_COMPILER}")
    set(_gen_compiler_id "${CMAKE_CXX_COMPILER_ID}")
    set(_gen_xlang       "c++")
  else()
    message(FATAL_ERROR
      "gen_filter_supported_compiler_flags: LANG must be 'C' or 'CXX', got '${LANG}'")
  endif()

  # Empty input file used as stdin replacement (portable across hosts)
  if(WIN32)
    set(_gen_null_input "NUL")
  else()
    set(_gen_null_input "/dev/null")
  endif()

  # Extra flags needed to make Clang fail on unknown warning options.
  # GCC and others rely on their default behavior.
  #
  # MSVC guard: cl.exe silently ignores GNU-style flags (-Wno-*) and always
  # exits 0, which would produce a false-positive result. Since MSVC and
  # clang-cl use /wd flags (not -Wno-), GNU-style flags are never passed to
  # them, so skipping the probe entirely is both correct and safe.
  if(_gen_compiler_id STREQUAL "MSVC")
    set(${OUTPUT_VAR} "" PARENT_SCOPE)
    return()
  endif()

  set(_gen_extra_flags "")
  if(_gen_compiler_id MATCHES "^(Clang|AppleClang)$")
    list(APPEND _gen_extra_flags "-Werror=unknown-warning-option")
  endif()

  set(_supported_flags "")

  foreach(_flag IN LISTS ARGN)

    # Build a unique cache variable name for this flag and language
    string(MAKE_C_IDENTIFIER "GEN_HAS_${LANG}_FLAG_${_flag}" _cache_var)

    if(NOT DEFINED ${_cache_var})

      message(STATUS "Performing Test ${_cache_var}")

      execute_process(
        COMMAND
          "${_gen_compiler}" -E "-x${_gen_xlang}"
          ${_gen_extra_flags}
          "${_flag}"
          "${_gen_null_input}"
        RESULT_VARIABLE _gen_exit_code
        OUTPUT_QUIET
        ERROR_QUIET
      )

      if(_gen_exit_code EQUAL 0)
        set(${_cache_var} TRUE  CACHE INTERNAL "Compiler supports ${_flag}")
        message(STATUS "Performing Test ${_cache_var} - Success")
      else()
        set(${_cache_var} FALSE CACHE INTERNAL "Compiler supports ${_flag}")
        message(STATUS "Performing Test ${_cache_var} - Failed")
      endif()

    endif()

    if(${${_cache_var}})
      list(APPEND _supported_flags "${_flag}")
    endif()

  endforeach()

  set(${OUTPUT_VAR} "${_supported_flags}" PARENT_SCOPE)

endfunction()


# --------------------------------------------------------------------
# Global warnings applied to ALL sources (GEN framework code)


# --------------------------------------------------------------------
# Microsoft Compiler (MSVC)

if(COMPILE_WITH_MSVC)
  
  # list(APPEND WARNING_TO_BOTH /wd4018)                                               # warning C4018: '>': signed/unsigned mismatch
  # list(APPEND WARNING_TO_BOTH /wd4091)                                               # warning C4091: 'typedef ': ignored on left of 'xxx' when no variable is declared
  # list(APPEND WARNING_TO_BOTH /wd4595)                                               # warning C4595: 'xxx': non-member operator new or delete functions may not be declared inline
  # list(APPEND WARNING_TO_BOTH /wd4996)                                               # warning C4996: 'xxx': was declared deprecated
  # list(APPEND WARNING_TO_BOTH /wd4624)                                               # warning C4624: 'xxx' destructor was implicitly defined as deleted
  list(APPEND WARNING_TO_BOTH /wd5033)                                                 # warning C5033: 'register' is no longer a supported storage class (AGG header included by GEN sources)
  # list(APPEND WARNING_TO_BOTH /wd5030)                                               # warning C5030: attribute 'xxx' is not recognized
  # list(APPEND WARNING_TO_BOTH /wd4065)                                               # warning C4065: switch statement contains 'default' but no 'case' labels
  # list(APPEND WARNING_TO_BOTH /wd4995)                                               # warning C4995: 'xxx': name was marked as #pragma deprecated
  # list(APPEND WARNING_TO_BOTH /wd4293)                                               # warning C4293: '>>': shift count negative or too big, undefined behavior
  # list(APPEND WARNING_TO_BOTH /wd4244)                                               # warning C4244: '=': invalid conversion from types, possible loss of data

  if(WINDOWS_APPMODE_DINAMIC)

    # list(APPEND WARNING_TO_BOTH /wd4251)                                             # warning C4251: needs to have dll-interface to be used by clients of class 'xxxxxxxx'

  endif()

endif()


# --------------------------------------------------------------------
# Linux GNU GCC Compiler

if(COMPILE_WITH_GCC)

  # list(APPEND WARNING_TO_BOTH -Wno-deprecated)                                       # warning: Eliminate warning of functions deprecated
  # list(APPEND WARNING_TO_CPP  -Wno-register)                                         # warning: The use of the register keyword as storage class specifier has been deprecated in C++11 and removed in C++17
  # list(APPEND WARNING_TO_CPP  -Wno-pointer-arith)

  # list(APPEND WARNING_TO_BOTH -Wreturn-local-addr)                                   # warning: reference to local variable 'var' returned [-Wreturn-local-addr]

  list(APPEND WARNING_TO_CPP  -Wno-register)                                           # warning: ISO C++17 does not allow 'register' storage class specifier [-Wregister] (AGG header included by GEN sources)

endif()


# --------------------------------------------------------------------
# CLang on Linux (front-end of LLVM — uses -Wno- flags)

if(COMPILE_WITH_CLANG)

  # list(APPEND WARNING_TO_BOTH -Wno-invalid-source-encoding)
  # list(APPEND WARNING_TO_BOTH -Wno-unused-variable)
  # list(APPEND WARNING_TO_BOTH -Wno-unused-but-set-variable)
  # list(APPEND WARNING_TO_BOTH -Wno-deprecated-coroutine)
  # list(APPEND WARNING_TO_BOTH -Wno-unused-function)
  # list(APPEND WARNING_TO_BOTH -Wno-switch)
  # list(APPEND WARNING_TO_BOTH -Wno-switch-enum)
  # list(APPEND WARNING_TO_BOTH -Wno-enum-compare)
  # list(APPEND WARNING_TO_BOTH -Wno-implicit-function-declaration)
  # list(APPEND WARNING_TO_BOTH -Wno-reorder-ctor)
  # list(APPEND WARNING_TO_BOTH -Wno-ignored-attributes)
  # list(APPEND WARNING_TO_BOTH -Wno-cast-calling-convention)
  # list(APPEND WARNING_TO_CPP -Wno-register)                                          # warning: The use of the register keyword as storage class specifier has been deprecated in C++11 and removed in C++17

  # list(APPEND WARNING_TO_BOTH -Wno-writable-strings)
  # list(APPEND WARNING_TO_BOTH -Wno-delete-incomplete)
  # list(APPEND WARNING_TO_BOTH -Wno-comment)
  # list(APPEND WARNING_TO_BOTH -ferror-limit=1000)

  #list(APPEND WARNING_TO_CPP  -Wno-deprecated-enum-float-conversion)                   # 
  #list(APPEND WARNING_TO_CPP  -Wno-deprecated-enum-enum-conversion)                    #
  list(APPEND WARNING_TO_CPP  -Wno-deprecated-register)                                # warning: 'register' storage class specifier is deprecated [-Wdeprecated-register] (AGG header included by GEN sources)
  list(APPEND WARNING_TO_CPP  -Wno-register)                                           # error: ISO C++17 does not allow 'register' storage class specifier [-Wregister] (AGG header included by GEN sources)

endif()


# --------------------------------------------------------------------
# CLang-CL on Windows (MSVC interface — uses /wd flags like MSVC,
# but also accepts some Clang-specific -Wno- flags via /clang:)

if(COMPILE_WITH_CLANG_CL)

  # list(APPEND WARNING_TO_BOTH /wd4018)                                               # warning C4018: '>': signed/unsigned mismatch
  # list(APPEND WARNING_TO_BOTH /wd4244)                                               # warning C4244: conversion, possible loss of data
  # list(APPEND WARNING_TO_BOTH /wd4267)                                               # warning C4267: conversion from 'size_t', possible loss of data
  # list(APPEND WARNING_TO_BOTH /wd4996)                                               # warning C4996: 'xxx': was declared deprecated
  # list(APPEND WARNING_TO_BOTH /wd4065)                                               # warning C4065: switch statement contains 'default' but no 'case' labels
  # list(APPEND WARNING_TO_BOTH /wd4293)                                               # warning C4293: '>>': shift count negative or too big, undefined behavior
  # list(APPEND WARNING_TO_BOTH /wd4624)                                               # warning C4624: destructor was implicitly defined as deleted
  # 
  # Clang-specific flags accepted by clang-cl via -Wno- pass-through
  #
  # list(APPEND WARNING_TO_BOTH -Wno-deprecated-non-prototype)
  # list(APPEND WARNING_TO_BOTH -Wno-string-plus-int)
  # list(APPEND WARNING_TO_BOTH -Wno-tautological-constant-out-of-range-compare)
  # list(APPEND WARNING_TO_BOTH -Wno-unused-function)
  # list(APPEND WARNING_TO_BOTH -Wno-invalid-source-encoding)
  # list(APPEND WARNING_TO_BOTH -Wno-unused-variable)
  # list(APPEND WARNING_TO_BOTH -Wno-switch)
  # list(APPEND WARNING_TO_BOTH -Wno-reorder-ctor)
  # list(APPEND WARNING_TO_BOTH -Wno-ignored-attributes)
  # list(APPEND WARNING_TO_CPP -Wno-register)
   
  # list(APPEND WARNING_TO_BOTH -Wno-microsoft-extra-qualification)
  # list(APPEND WARNING_TO_BOTH -Wno-cast-calling-convention)
  
  #list(APPEND WARNING_TO_CPP  -Wno-deprecated-enum-float-conversion)                    #           
  #list(APPEND WARNING_TO_CPP  -Wno-deprecated-enum-enum-conversion)                     # 
  list(APPEND WARNING_TO_CPP  -Wno-deprecated-register)                                 # warning: 'register' storage class specifier is deprecated [-Wdeprecated-register] (AGG header included by GEN sources)
  list(APPEND WARNING_TO_CPP  -Wno-register)                                            # error: ISO C++17 does not allow 'register' storage class specifier [-Wregister] (AGG header included by GEN sources)

endif()


string(JOIN " " WARNING_TO_C_STR    ${WARNING_TO_C})
string(JOIN " " WARNING_TO_CPP_STR  ${WARNING_TO_CPP})
string(JOIN " " WARNING_TO_BOTH_STR ${WARNING_TO_BOTH})

set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${WARNING_TO_C_STR}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_TO_CPP_STR}")
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${WARNING_TO_BOTH_STR}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNING_TO_BOTH_STR}")

message(STATUS "[ GEN Warnings de-activated C + CPP + BOTH: ${WARNING_TO_C_STR} - ${WARNING_TO_CPP_STR} - ${WARNING_TO_BOTH_STR} ]")


# --------------------------------------------------------------------
# Macro: GEN_ThirdPartyLibraries_SuppressWarnings
#
# Applies the compiler-specific warning suppression flags declared above
# to a list of source files belonging to a third-party library.
#
# Parameters:
#   LIB_NAME    - library identifier (must match a declared set above)
#   ARGN        - list of source file paths to suppress warnings on
#
# The macro selects the correct flag set based on the active compiler:
#   COMPILE_WITH_MSVC     -> GEN_ThirdPartyLibraries_Warnings_MSVC_<LIB_NAME>
#   COMPILE_WITH_GCC      -> GEN_ThirdPartyLibraries_Warnings_GCC_<LIB_NAME>
#   COMPILE_WITH_CLANG    -> GEN_ThirdPartyLibraries_Warnings_CLANG_<LIB_NAME>     (Linux)
#   COMPILE_WITH_CLANG_CL -> GEN_ThirdPartyLibraries_Warnings_CLANG_CL_<LIB_NAME> (Windows)
# --------------------------------------------------------------------
macro(GEN_ThirdPartyLibraries_SuppressWarnings LIB_NAME)

  # Select the flag list for the active compiler
  if(COMPILE_WITH_MSVC)

    set(_GEN_TPLIBRARIES_FLAGS ${GEN_ThirdPartyLibraries_Warnings_MSVC_${LIB_NAME}})

  elseif(COMPILE_WITH_GCC)

    set(_GEN_TPLIBRARIES_FLAGS ${GEN_ThirdPartyLibraries_Warnings_GCC_${LIB_NAME}})

  elseif(COMPILE_WITH_CLANG)

    set(_GEN_TPLIBRARIES_FLAGS ${GEN_ThirdPartyLibraries_Warnings_CLANG_${LIB_NAME}})

  elseif(COMPILE_WITH_CLANG_CL)

    set(_GEN_TPLIBRARIES_FLAGS ${GEN_ThirdPartyLibraries_Warnings_CLANG_CL_${LIB_NAME}})

  else()

    set(_GEN_TPLIBRARIES_FLAGS)

  endif()

  # Convert list to a single space-separated string for COMPILE_FLAGS
  if(_GEN_TPLIBRARIES_FLAGS)

    string(JOIN " " _GEN_TPLIBRARIES_FLAGS_STR ${_GEN_TPLIBRARIES_FLAGS})


    foreach(_GEN_TPLIBRARIES_FILE ${ARGN})

      # APPEND_STRING: flags accumulate when a source is touched by more than one
      # suppression call (or by a prior set_source_files_properties). Leading space
      # keeps tokens separated when appending to a non-empty COMPILE_FLAGS value.
      set_property(SOURCE "${_GEN_TPLIBRARIES_FILE}" APPEND_STRING PROPERTY
        COMPILE_FLAGS " ${_GEN_TPLIBRARIES_FLAGS_STR}"
      )

    endforeach()


    message(STATUS "[ GEN ThirdParty ${LIB_NAME} warnings suppressed: ${_GEN_TPLIBRARIES_FLAGS_STR} ]")

  endif()

  unset(_GEN_TPLIBRARIES_FLAGS)
  unset(_GEN_TPLIBRARIES_FLAGS_STR)
  unset(_GEN_TPLIBRARIES_FILE)

endmacro()


# --------------------------------------------------------------------
# Per-library warning suppression for Third Party Libraries
#
# Usage in GEN_Main_Sources_ThirdPartyLibraries.cmake:
#
#   GEN_ThirdPartyLibraries_SuppressWarnings(<LibName> <source1> [<source2> ...])
#
# The warnings to suppress for each library are declared below using:
#
#   GEN_ThirdPartyLibraries_Warnings_MSVC_<LibName>      -> MSVC        /wd flags
#   GEN_ThirdPartyLibraries_Warnings_GCC_<LibName>       -> GCC         -Wno flags
#   GEN_ThirdPartyLibraries_Warnings_CLANG_<LibName>     -> Clang/Linux -Wno flags
#   GEN_ThirdPartyLibraries_Warnings_CLANG_CL_<LibName>  -> Clang-CL/Windows  /wd + -Wno flags
#
# Only the variable set matching the active compiler will be applied.
# Any library not listed here will compile with no extra suppression.
# --------------------------------------------------------------------


# --------------------------------------------------------------------
# ANGLE (Windows-only GLES translator)
#
# Requires C++20. Applied per TU via SuppressWarnings so the application target can
# keep GEN's default CMAKE_CXX_STANDARD (see restore at end of
# GEN_Main_Sources_ThirdPartyLibraries.cmake). That avoids MSVC D9025
# (overriding /std:c++17 from OpenAL's global CMAKE_CXX_STANDARD bump with
# per-file /std:c++20). GCC/Clang lists stay empty — ANGLE is not built there.

set( GEN_ThirdPartyLibraries_Warnings_MSVC_ANGLE
     /std:c++20                                                                        # ANGLE requires C++20 (MSVC); per-file so the app target is not forced to C++20
   )

set( GEN_ThirdPartyLibraries_Warnings_GCC_ANGLE )                                      # (not used — ANGLE is Windows-only)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_ANGLE )                                    # (not used — ANGLE is Windows-only)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_ANGLE
     /std:c++20                                                                        # ANGLE requires C++20 (clang-cl); same rationale as MSVC
   )


# --------------------------------------------------------------------
# ZLib 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_ZLib
     # /wd4131                                                                         # warning C4131: uses old-style declarator
     # /wd4127                                                                         # warning C4127: conditional expression is constant
     # /wd4245                                                                         # warning C4245: conversion from 'int' to 'unsigned int', signed/unsigned mismatch
   )

# Note: -Wdeprecated-non-prototype is a Clang-only diagnostic, GCC never emits it (its equivalent
# would be -Wold-style-definition, which is not enabled by default). It is left declared because
# GCC does not diagnose an unknown -Wno-* unless another diagnostic is produced in the same unit,
# so it is inert here; if some GCC version ever complains, comment it out.
set( GEN_ThirdPartyLibraries_Warnings_GCC_ZLib
     -Wno-deprecated-non-prototype                                                     # warning: function definition without a prototype deprecated in C23 (GCC 11+, confirmed in Linux build log)
     # -Wno-implicit-function-declaration
   )

# Note: -Wno-deprecated-non-prototype is used directly (not via gen_filter_supported_compiler_flags)
# because NDK Clang 18 fails the probe when -Werror=unknown-warning-option is injected, yet the
# warning [-Wdeprecated-non-prototype] IS emitted at build time — confirming the flag exists.
#
# CAREFUL: a -Wno-* flag for an unknown warning is NOT silently ignored by Clang, it emits
# "warning: unknown warning option '-Wno-xxx' [-Wunknown-warning-option]" once per compilation unit.
# -Wdeprecated-non-prototype only exists from Clang 15 onwards, so on older toolchains
# (Raspberry Pi 64 / Debian Clang 14, for example) every ZLib .c produced a spurious warning.
# -Wno-unknown-warning-option (declared FIRST, so it is already active when the driver validates
# the rest of the options) silences exactly that meta-warning, and only for the ZLib sources.
set( GEN_ThirdPartyLibraries_Warnings_CLANG_ZLib
     -Wno-unknown-warning-option                                                       # Clang < 15 does not know -Wdeprecated-non-prototype: avoids [-Wunknown-warning-option]
     -Wno-deprecated-non-prototype                                                     # warning: function definition without a prototype deprecated in C23 (confirmed in build logs)
     # -Wno-implicit-function-declaration
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_ZLib
     # /wd4131                                                                         # warning C4131: uses old-style declarator
     # /wd4127                                                                         # warning C4127: conditional expression is constant
     # /wd4245                                                                         # warning C4245: conversion signed/unsigned mismatch
     # -Wno-implicit-function-declaration
     -Wno-unknown-warning-option                                                       # Clang-CL < 15 does not know -Wdeprecated-non-prototype: avoids [-Wunknown-warning-option]
     -Wno-deprecated-non-prototype                                                     # warning: function definition without a prototype deprecated in C23
   )


# --------------------------------------------------------------------
# AGG 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_AGG
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t' to 'xxx', possible loss of data
     # /wd4305                                                                         # warning C4305: truncation from 'double' to 'float'
   )

set( GEN_ThirdPartyLibraries_Warnings_GCC_AGG
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-misleading-indentation
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_AGG
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-shorten-64-to-32
     -Wno-deprecated-register                                                          # warning: 'register' storage class specifier is deprecated [-Wdeprecated-register] (agg_trans_affine.h, confirmed in Android/CLang build log)
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_AGG
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4305                                                                         # warning C4305: truncation from 'double' to 'float'
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-deprecated-register                                                        # REDUNDANT: already suppressed globally via WARNING_TO_CPP in COMPILE_WITH_CLANG_CL block
   )


# --------------------------------------------------------------------
# FreeType 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_FreeType
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4312                                                                         # warning C4312: type cast to greater size
     # /wd4456                                                                         # warning C4456: declaration of 'xxx' hides previous local declaration
   )

set( GEN_ThirdPartyLibraries_Warnings_GCC_FreeType
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
     # -Wno-unused-result
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_FreeType
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
     # -Wno-shorten-64-to-32
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_FreeType
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4312                                                                         # warning C4312: type cast to greater size
     # /wd4456                                                                         # warning C4456: hides previous local declaration
     # -Wno-implicit-fallthrough                                                       
   )                                                                                   
                                                                                       
                                                                                       
# --------------------------------------------------------------------                 
# JPEGLib                                                                              
                                                                                       
set( GEN_ThirdPartyLibraries_Warnings_MSVC_JPEGLib                                     
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_GCC_JPEGLib
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
   )  

set( GEN_ThirdPartyLibraries_Warnings_CLANG_JPEGLib
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-shorten-64-to-32
   ) 

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_JPEGLib
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # -Wno-implicit-fallthrough
   )  


# --------------------------------------------------------------------
# LibPNG 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_LibPNG
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_GCC_LibPNG
     # -Wno-conversion
     # -Wno-sign-compare
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_CLANG_LibPNG
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-shorten-64-to-32
     -Wno-tautological-constant-out-of-range-compare                                   # png.c: comparison of constant with 'unsigned int' is always false (PNG_SIZE_MAX 64-bit vs 32-bit uint)
   )  

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_LibPNG
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # -Wno-conversion
     # -Wno-sign-compare
     -Wno-tautological-constant-out-of-range-compare                                   # png.c: comparison of constant with 'unsigned int' is always false (PNG_SIZE_MAX 64-bit vs 32-bit uint)
   )


# --------------------------------------------------------------------
# LUA 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_LUA
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4310                                                                         # warning C4310: cast truncates constant value
     # /wd4324                                                                         # warning C4324: structure was padded due to alignment specifier
   )  

set( GEN_ThirdPartyLibraries_Warnings_GCC_LUA
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
     # -Wno-maybe-uninitialized
     -Wno-string-plus-int                                                              # warning: adding 'int' to a string does not append to the string (lundump.c:237, confirmed in Linux GCC 14.2 build log)
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_LUA
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
     # -Wno-shorten-64-to-32
     -Wno-string-plus-int                                                              # warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_LUA
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4310                                                                         # warning C4310: cast truncates constant value
     # /wd4324                                                                         # warning C4324: structure was padded due to alignment specifier
     # -Wno-implicit-fallthrough
     # -Wno-shorten-64-to-32
     -Wno-string-plus-int                                                              # warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
   )


# --------------------------------------------------------------------
# DuckTape (Duktape) 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_DuckTape
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4334                                                                         # warning C4334: result of 32-bit shift implicitly converted to 64 bits
     # /wd4310                                                                         # warning C4310: cast truncates constant value
   )
   
set( GEN_ThirdPartyLibraries_Warnings_GCC_DuckTape
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-maybe-uninitialized
     # -Wno-implicit-fallthrough
     # -Wno-shift-count-overflow
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_DuckTape
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-implicit-fallthrough
     # -Wno-shorten-64-to-32
     # -Wno-shift-count-overflow
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_DuckTape
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4334                                                                         # warning C4334: result of 32-bit shift implicitly converted to 64 bits
     # /wd4310                                                                         # warning C4310: cast truncates constant value
     # -Wno-implicit-fallthrough
     # -Wno-shift-count-overflow
   )


# --------------------------------------------------------------------
# OpenAL 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_OpenAL
     /DRESTRICT=__restrict                                                             # OpenAL Soft needs RESTRICT; per-TU (global /D broke ANGLE glslang RESTRICT token → /URESTRICT D9025)
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4324                                                                         # warning C4324: structure was padded due to alignment specifier
     # /wd4456                                                                         # warning C4456: declaration of 'xxx' hides previous local declaration
     # /wd4457                                                                         # warning C4457: declaration of 'xxx' hides function parameter
     /wd4293                                                                           # warning C4293: '>>': shift count negative or too big, undefined behavior
   )

# When ANGLE is on, CMAKE_CXX_STANDARD is unset at the end of ThirdPartyLibraries (D9025 fix);
# OpenAL Soft 1.24 then needs an explicit per-file /std:c++17. Without ANGLE the global
# set(CMAKE_CXX_STANDARD 17) in the OpenAL block already covers it — do not duplicate the flag.
if(THIRDPARTYLIBRARIES_ANGLE_FEATURE)
  list(INSERT GEN_ThirdPartyLibraries_Warnings_MSVC_OpenAL 0 /std:c++17)
endif()

set( GEN_ThirdPartyLibraries_Warnings_GCC_OpenAL
     -DRESTRICT=__restrict                                                             # OpenAL Soft needs RESTRICT; per-TU (same rationale as MSVC — do not pollute the target)
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-unused-variable
     # -Wno-unused-parameter
     # -Wno-implicit-fallthrough
     # -Wno-maybe-uninitialized 
     -Wno-interference-size                                                            # warning: use of 'std::hardware_destructive_interference_size' [-Winterference-size] (common/ringbuffer.h:23, value varies with -mtune/-mcpu; confirmed in Linux GCC build log)
     -Wno-ignored-attributes                                                           # warning: ignoring attributes on template argument '{anonymous}::v4sf' {aka '__m128'} [-Wignored-attributes] (common/pffft.cpp:1470, al::span<v4sf>; confirmed in Linux GCC build log)
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_OpenAL
     -DRESTRICT=__restrict                                                             # OpenAL Soft needs RESTRICT; per-TU (same rationale as MSVC)
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-unused-variable
     # -Wno-unused-parameter
     # -Wno-implicit-fallthrough
     # -Wno-shorten-64-to-32
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_OpenAL
     /DRESTRICT=__restrict                                                             # OpenAL Soft needs RESTRICT; per-TU (same rationale as MSVC)
     # /wd4244                                                                         # warning C4244: conversion, possible loss of data
     # /wd4267                                                                         # warning C4267: conversion from 'size_t', possible loss of data
     # /wd4324                                                                         # warning C4324: structure was padded due to alignment specifier
     # /wd4456                                                                         # warning C4456: hides previous local declaration
     # /wd4457                                                                         # warning C4457: hides function parameter
     # -Wno-unused-variable
     # -Wno-unused-parameter
     # -Wno-implicit-fallthrough
     -Wno-invalid-offsetof
   )

if(THIRDPARTYLIBRARIES_ANGLE_FEATURE)
  list(INSERT GEN_ThirdPartyLibraries_Warnings_CLANG_CL_OpenAL 0 /std:c++17)
endif()


# --------------------------------------------------------------------
# RPI_WS281X 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_RPI_WS281X )                                # (not used on Windows)

set( GEN_ThirdPartyLibraries_Warnings_GCC_RPI_WS281X
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-unused-variable
     # -Wno-unused-parameter
     -Wno-array-bounds                                                                 # warning: array index 1 is past the end of the array (channel[RPI_PWM_CHANNELS]) ws2811.c
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_RPI_WS281X
     # -Wno-conversion
     # -Wno-sign-compare
     # -Wno-unused-variable
     # -Wno-unused-parameter
     -Wno-array-bounds                                                                 # warning: array index 1 is past the end of the array (channel[RPI_PWM_CHANNELS]) ws2811.c
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_RPI_WS281X )                            # (not used on Windows)


# --------------------------------------------------------------------
# StackWalker 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_StackWalker
     # /wd4100                                                                         # warning C4100: unreferenced formal parameter
     # /wd4706                                                                         # warning C4706: assignment within conditional expression
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_GCC_StackWalker )                                # (not used on Linux)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_StackWalker )                              # (not used on Linux)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_StackWalker
     # /wd4100                                                                         # warning C4100: unreferenced formal parameter
     # /wd4706                                                                         # warning C4706: assignment within conditional expression
     # -Wno-unused-parameter
   )  


# --------------------------------------------------------------------
# WinToast 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_WinToast
     /wd4244                                                                           # warning C4244: conversion from 'wchar_t' to 'char', possible loss of data
   )

set( GEN_ThirdPartyLibraries_Warnings_GCC_WinToast )                                   # (not used on Linux)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_WinToast )                                 # (not used on Linux)

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_WinToast
     /wd4244                                                                           # warning C4244: conversion from 'wchar_t' to 'char', possible loss of data
   )


# --------------------------------------------------------------------
# GoogleTest 

set( GEN_ThirdPartyLibraries_Warnings_MSVC_GoogleTest
     # /wd4389                                                                         # warning C4389: '==': signed/unsigned mismatch
     # /wd4100                                                                         # warning C4100: unreferenced formal parameter
   
   )

if(THIRDPARTYLIBRARIES_ANGLE_FEATURE)
  list(INSERT GEN_ThirdPartyLibraries_Warnings_MSVC_GoogleTest 0 /std:c++14)
endif()

set( GEN_ThirdPartyLibraries_Warnings_GCC_GoogleTest
     # -Wno-conversion
     # -Wno-sign-compare
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_CLANG_GoogleTest
     # -Wno-conversion
     # -Wno-sign-compare
   )  
      
set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_GoogleTest
     # /wd4389                                                                         # warning C4389: '==': signed/unsigned mismatch
     # /wd4100                                                                         # warning C4100: unreferenced formal parameter
     # -Wno-conversion
     # -Wno-sign-compare
   )

if(THIRDPARTYLIBRARIES_ANGLE_FEATURE)
  list(INSERT GEN_ThirdPartyLibraries_Warnings_CLANG_CL_GoogleTest 0 /std:c++14)
endif()




# --------------------------------------------------------------------
# SQLite

set( GEN_ThirdPartyLibraries_Warnings_MSVC_SQLite )

set( GEN_ThirdPartyLibraries_Warnings_GCC_SQLite
     -Wno-implicit-const-int-float-conversion                                          # warning: implicit conversion from 'i64' to 'double' changes value (confirmed in Linux GCC build log)
     -Wno-return-local-addr                                                            # warning: function may return address of local variable [-Wreturn-local-addr] (sqlite3.c:81153/120419, intentional 'standin'/'zBase' pattern in SQLite; confirmed in Linux GCC build log)
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_SQLite
     -Wno-implicit-const-int-float-conversion                                          # warning: implicit conversion from 'i64' to 'double' changes value [-Wimplicit-const-int-float-conversion]
   )

set( GEN_ThirdPartyLibraries_Warnings_CLANG_CL_SQLite
     -Wno-implicit-const-int-float-conversion                                          # warning: implicit conversion from 'i64' to 'double' changes value [-Wimplicit-const-int-float-conversion]
   )

