# Generate a Freedesktop .desktop with absolute Exec=/Icon= for the build dir.
# Also installs into $HOME/.local/share so KDE can resolve the icon when the build
# lives on a Windows mount (/mnt/e) where chmod/xattrs and "trust" do not work.
#
# -DGEN_DESKTOP_IN= -DGEN_DESKTOP_OUT= -DGEN_BIN_DIR= -DGEN_EXEC_PATH=
# -DGEN_ICON_PATH=  -DGEN_ICONS_SRC= (hicolor tree) -DGEN_DESKTOP_NAME= (theme + launcher stem)

cmake_minimum_required(VERSION 3.16)
cmake_policy(SET CMP0053 NEW)

if(NOT GEN_DESKTOP_IN OR NOT GEN_DESKTOP_OUT OR NOT GEN_BIN_DIR OR NOT GEN_EXEC_PATH OR NOT GEN_ICON_PATH)
  message(FATAL_ERROR "GEN_Main_Linux_GenDesktop.cmake: missing GEN_DESKTOP_IN/OUT, GEN_BIN_DIR, GEN_EXEC_PATH or GEN_ICON_PATH")
endif()

if(NOT GEN_DESKTOP_NAME)
  get_filename_component(GEN_DESKTOP_NAME "${GEN_DESKTOP_OUT}" NAME_WE)
endif()

function(gen_write_desktop out_path icon_value)
  file(READ "${GEN_DESKTOP_IN}" _content)
  string(REPLACE "__GEN_BIN_DIR__"   "${GEN_BIN_DIR}"   _content "${_content}")
  string(REPLACE "__GEN_EXEC_PATH__" "${GEN_EXEC_PATH}" _content "${_content}")
  string(REPLACE "__GEN_ICON_PATH__" "${icon_value}"    _content "${_content}")
  file(WRITE "${out_path}" "${_content}")
  if(UNIX)
    execute_process(COMMAND chmod +x "${out_path}" ERROR_QUIET)
    execute_process(
      COMMAND gio set "${out_path}" "metadata::trusted" true
      ERROR_QUIET OUTPUT_QUIET RESULT_VARIABLE _gio_rc
    )
  endif()
endfunction()

# 1) Build-dir copy (absolute Icon=).
gen_write_desktop("${GEN_DESKTOP_OUT}" "${GEN_ICON_PATH}")

# 2) User-local Freedesktop install.
if(DEFINED ENV{HOME} AND NOT "$ENV{HOME}" STREQUAL "")
  set(_GEN_HOME "$ENV{HOME}")
  set(_GEN_APP_DIR   "${_GEN_HOME}/.local/share/applications")
  set(_GEN_ICONS_DIR "${_GEN_HOME}/.local/share/icons")

  file(MAKE_DIRECTORY "${_GEN_APP_DIR}")

  if(GEN_ICONS_SRC AND EXISTS "${GEN_ICONS_SRC}")
    file(MAKE_DIRECTORY "${_GEN_ICONS_DIR}")
    file(COPY "${GEN_ICONS_SRC}/" DESTINATION "${_GEN_ICONS_DIR}/hicolor")
  endif()

  gen_write_desktop("${_GEN_APP_DIR}/${GEN_DESKTOP_NAME}.desktop" "${GEN_DESKTOP_NAME}")

  message(STATUS "[ GEN Package/Linux ] installed launcher: ${_GEN_APP_DIR}/${GEN_DESKTOP_NAME}.desktop")
  message(STATUS "[ GEN Package/Linux ] installed icons:    ${_GEN_ICONS_DIR}/hicolor")
endif()
