# --------------------------------------------------------------------
# GEN_Main_Linux_DesktopPackage.cmake
# Shared Freedesktop .desktop + hicolor install for GEN apps.
#
# Call after GEN_End.cmake when COMPILE_FOR_LINUX:
#   gen_add_linux_desktop_package(
#     STEM   ui_console
#     PKGDIR "${CMAKE_CURRENT_SOURCE_DIR}/../Package/Linux"
#   )
#
# Expects under PKGDIR:
#   ${STEM}.desktop.in   (placeholders __GEN_BIN_DIR__ / __GEN_EXEC_PATH__ / __GEN_ICON_PATH__)
#   appicon.png
#   icons/hicolor/*/apps/${STEM}.png
#   (optional) uses this module's sibling gen script via GEN_DIRECTORY
# --------------------------------------------------------------------

if(NOT DEFINED _GEN_LINUX_DESKTOP_PACKAGE_DEFINED)
  set(_GEN_LINUX_DESKTOP_PACKAGE_DEFINED TRUE)

  function(gen_add_linux_desktop_package)
    set(options)
    set(oneValueArgs STEM PKGDIR)
    set(multiValueArgs)
    cmake_parse_arguments(GENLDP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT GENLDP_STEM)
      message(FATAL_ERROR "gen_add_linux_desktop_package: STEM is required")
    endif()
    if(NOT GENLDP_PKGDIR)
      message(FATAL_ERROR "gen_add_linux_desktop_package: PKGDIR is required")
    endif()

    if(NOT GEN_DIRECTORY)
      message(FATAL_ERROR "gen_add_linux_desktop_package: GEN_DIRECTORY is not set")
    endif()
    get_filename_component(_GEN_LDP_SCRIPT
      "${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Linux_GenDesktop.cmake" ABSOLUTE)
    if(NOT EXISTS "${_GEN_LDP_SCRIPT}")
      message(FATAL_ERROR "gen_add_linux_desktop_package: missing ${_GEN_LDP_SCRIPT}")
    endif()

    set(_GEN_LDP_DESK_IN  "${GENLDP_PKGDIR}/${GENLDP_STEM}.desktop.in")
    set(_GEN_LDP_APPICON  "${GENLDP_PKGDIR}/appicon.png")
    set(_GEN_LDP_ICONS    "${GENLDP_PKGDIR}/icons")

    if(NOT EXISTS "${_GEN_LDP_DESK_IN}")
      message(WARNING "[ GEN Linux package ] missing ${_GEN_LDP_DESK_IN}")
      return()
    endif()
    if(NOT EXISTS "${_GEN_LDP_APPICON}")
      message(WARNING "[ GEN Linux package ] missing ${_GEN_LDP_APPICON}")
      return()
    endif()

    add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${_GEN_LDP_APPICON}"
              "$<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/appicon.png"
      COMMAND ${CMAKE_COMMAND} -E copy_directory
              "${_GEN_LDP_ICONS}"
              "$<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/icons"
      COMMAND ${CMAKE_COMMAND}
              "-DGEN_DESKTOP_IN=${_GEN_LDP_DESK_IN}"
              "-DGEN_DESKTOP_OUT=$<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${GENLDP_STEM}.desktop"
              "-DGEN_BIN_DIR=$<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>"
              "-DGEN_EXEC_PATH=$<TARGET_FILE:${CMAKE_PROJECT_NAME}>"
              "-DGEN_ICON_PATH=$<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/appicon.png"
              "-DGEN_ICONS_SRC=${_GEN_LDP_ICONS}/hicolor"
              "-DGEN_DESKTOP_NAME=${GENLDP_STEM}"
              -P "${_GEN_LDP_SCRIPT}"
      COMMENT "[ GEN Package/Linux: desktop + icons → build dir and ~/.local/share ]"
      VERBATIM
    )
  endfunction()

endif()
