# --------------------------------------------------------------------
# GEN_Main_Android_BuildPackage.cmake
# Main: Android package build support
# --------------------------------------------------------------------

cmake_minimum_required(VERSION 3.16)

if(NOT DEFINED _GEN_ANDROID_BUILD_PACKAGE_FUNCTIONS_DEFINED)

  set(_GEN_ANDROID_BUILD_PACKAGE_FUNCTIONS_DEFINED TRUE)


  # --------------------------------------------------------------------
  # Internal helpers

  function(_gen_android_fail MESSAGE_TEXT)
    message(FATAL_ERROR "[ GEN Android ${MESSAGE_TEXT} ]")
  endfunction()

  function(_gen_android_strip_quotes INPUT_VAR OUTPUT_VAR)
    if(DEFINED ${INPUT_VAR})
      set(_GEN_ANDROID_VALUE "${${INPUT_VAR}}")
    else()
      set(_GEN_ANDROID_VALUE "")
    endif()

    string(STRIP "${_GEN_ANDROID_VALUE}" _GEN_ANDROID_VALUE)
    string(REGEX REPLACE "^\"(.*)\"$" "\\1" _GEN_ANDROID_VALUE "${_GEN_ANDROID_VALUE}")

    set(${OUTPUT_VAR} "${_GEN_ANDROID_VALUE}" PARENT_SCOPE)
  endfunction()

  function(_gen_android_to_cmake_path INPUT_PATH OUTPUT_VAR)
    if("${INPUT_PATH}" STREQUAL "")
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
      return()
    endif()

    file(TO_CMAKE_PATH "${INPUT_PATH}" _GEN_ANDROID_VALUE)
    set(${OUTPUT_VAR} "${_GEN_ANDROID_VALUE}" PARENT_SCOPE)
  endfunction()

  function(_gen_android_extract_api_level INPUT_VALUE OUTPUT_VAR)
    set(_GEN_ANDROID_VALUE "${INPUT_VALUE}")

    if(_GEN_ANDROID_VALUE STREQUAL "")
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
      return()
    endif()

    string(REGEX REPLACE "^android-" "" _GEN_ANDROID_VALUE "${_GEN_ANDROID_VALUE}")
    set(${OUTPUT_VAR} "${_GEN_ANDROID_VALUE}" PARENT_SCOPE)
  endfunction()

  function(_gen_android_to_abs_path INPUT_PATH BASE_DIR OUTPUT_VAR)
    set(_GEN_ANDROID_PATH "${INPUT_PATH}")

    if(_GEN_ANDROID_PATH STREQUAL "")
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
      return()
    endif()

    file(TO_CMAKE_PATH "${_GEN_ANDROID_PATH}" _GEN_ANDROID_PATH)

    if(IS_ABSOLUTE "${_GEN_ANDROID_PATH}")
      set(_GEN_ANDROID_ABS_PATH "${_GEN_ANDROID_PATH}")
    else()
      get_filename_component(_GEN_ANDROID_ABS_PATH "${BASE_DIR}/${_GEN_ANDROID_PATH}" ABSOLUTE)
      file(TO_CMAKE_PATH "${_GEN_ANDROID_ABS_PATH}" _GEN_ANDROID_ABS_PATH)
    endif()

    set(${OUTPUT_VAR} "${_GEN_ANDROID_ABS_PATH}" PARENT_SCOPE)
  endfunction()

  function(_gen_android_relativize_path INPUT_PATH BASE_DIR OUTPUT_VAR)
    set(_GEN_ANDROID_PATH "${INPUT_PATH}")

    if(_GEN_ANDROID_PATH STREQUAL "")
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
      return()
    endif()

    if(_GEN_ANDROID_PATH MATCHES "\$<.*>")
      set(${OUTPUT_VAR} "${_GEN_ANDROID_PATH}" PARENT_SCOPE)
      return()
    endif()

    _gen_android_to_abs_path("${_GEN_ANDROID_PATH}" "${BASE_DIR}" _GEN_ANDROID_ABS_PATH)
    _gen_android_to_abs_path("${BASE_DIR}" "${CMAKE_CURRENT_LIST_DIR}" _GEN_ANDROID_BASE_ABS)

    file(TO_CMAKE_PATH "${_GEN_ANDROID_ABS_PATH}" _GEN_ANDROID_ABS_PATH)
    file(TO_CMAKE_PATH "${_GEN_ANDROID_BASE_ABS}" _GEN_ANDROID_BASE_ABS)

    if(CMAKE_HOST_WIN32)
      string(SUBSTRING "${_GEN_ANDROID_ABS_PATH}" 0 2 _GEN_ANDROID_ABS_DRIVE)
      string(SUBSTRING "${_GEN_ANDROID_BASE_ABS}" 0 2 _GEN_ANDROID_BASE_DRIVE)
      string(TOLOWER "${_GEN_ANDROID_ABS_DRIVE}" _GEN_ANDROID_ABS_DRIVE)
      string(TOLOWER "${_GEN_ANDROID_BASE_DRIVE}" _GEN_ANDROID_BASE_DRIVE)

      if(NOT _GEN_ANDROID_ABS_DRIVE STREQUAL _GEN_ANDROID_BASE_DRIVE)
        set(${OUTPUT_VAR} "${_GEN_ANDROID_ABS_PATH}" PARENT_SCOPE)
        return()
      endif()
    endif()

    file(RELATIVE_PATH _GEN_ANDROID_REL_PATH "${_GEN_ANDROID_BASE_ABS}" "${_GEN_ANDROID_ABS_PATH}")
    file(TO_CMAKE_PATH "${_GEN_ANDROID_REL_PATH}" _GEN_ANDROID_REL_PATH)

    set(${OUTPUT_VAR} "${_GEN_ANDROID_REL_PATH}" PARENT_SCOPE)
  endfunction()

  function(_gen_android_find_newest SEARCH_ROOT SEARCH_GLOB OUTPUT_VAR)
    if(NOT EXISTS "${SEARCH_ROOT}")
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
      return()
    endif()

    file(GLOB_RECURSE _GEN_ANDROID_MATCHES LIST_DIRECTORIES false "${SEARCH_ROOT}/${SEARCH_GLOB}")

    if(_GEN_ANDROID_MATCHES)
      list(SORT _GEN_ANDROID_MATCHES COMPARE NATURAL ORDER DESCENDING)
      list(GET _GEN_ANDROID_MATCHES 0 _GEN_ANDROID_NEWEST)
      file(TO_CMAKE_PATH "${_GEN_ANDROID_NEWEST}" _GEN_ANDROID_NEWEST)
      set(${OUTPUT_VAR} "${_GEN_ANDROID_NEWEST}" PARENT_SCOPE)
    else()
      set(${OUTPUT_VAR} "" PARENT_SCOPE)
    endif()
  endfunction()

  function(_gen_android_get_framework_root OUTPUT_VAR)
    get_filename_component(_GEN_ANDROID_FRAMEWORK_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
    file(TO_CMAKE_PATH "${_GEN_ANDROID_FRAMEWORK_ROOT}" _GEN_ANDROID_FRAMEWORK_ROOT)
    set(${OUTPUT_VAR} "${_GEN_ANDROID_FRAMEWORK_ROOT}" PARENT_SCOPE)
  endfunction()


  # --------------------------------------------------------------------
  # Build-time implementation

  function(_gen_android_build_package_impl)
    foreach(_GEN_ANDROID_VAR
      GEN_ANDROID_SOURCE_ASSETS_DIR
      GEN_ANDROID_GENERATED_MANIFEST
      GEN_ANDROID_NDK_ROOT
      GEN_ANDROID_SDK_ROOT
      GEN_ANDROID_JAVA_HOME
      GEN_ANDROID_ABI
      GEN_ANDROID_TARGET_SDK
      GEN_ANDROID_MIN_SDK
      GEN_ANDROID_PROJECT_NAME
      GEN_ANDROID_APP_ID
      GEN_ANDROID_APP_LABEL
      GEN_ANDROID_SHARED_LIBRARY
      GEN_ANDROID_OUTPUT_DIR)
      _gen_android_strip_quotes(${_GEN_ANDROID_VAR} ${_GEN_ANDROID_VAR}_CLEAN)
    endforeach()

    _gen_android_get_framework_root(_GEN_ANDROID_FRAMEWORK_ROOT)

    if(GEN_ANDROID_OUTPUT_DIR_CLEAN STREQUAL "")
      _gen_android_fail("GEN_ANDROID_OUTPUT_DIR is not defined")
    endif()

    _gen_android_to_abs_path("${GEN_ANDROID_OUTPUT_DIR_CLEAN}" "${CMAKE_CURRENT_LIST_DIR}" _GEN_ANDROID_OUTPUT_DIR)

    if(_GEN_ANDROID_OUTPUT_DIR STREQUAL "")
      _gen_android_fail("Could not resolve GEN_ANDROID_OUTPUT_DIR")
    endif()

    set(_GEN_ANDROID_BUILD_WORK_DIR "${_GEN_ANDROID_OUTPUT_DIR}")

    _gen_android_to_abs_path("${GEN_ANDROID_SHARED_LIBRARY_CLEAN}"     "${_GEN_ANDROID_BUILD_WORK_DIR}" _GEN_ANDROID_SHARED_LIBRARY)
    _gen_android_to_abs_path("${GEN_ANDROID_SOURCE_ASSETS_DIR_CLEAN}"  "${_GEN_ANDROID_BUILD_WORK_DIR}" _GEN_ANDROID_ASSETS_DIR)
    _gen_android_to_abs_path("${GEN_ANDROID_GENERATED_MANIFEST_CLEAN}" "${_GEN_ANDROID_BUILD_WORK_DIR}" _GEN_ANDROID_GENERATED_MANIFEST)
    _gen_android_to_abs_path("${GEN_ANDROID_NDK_ROOT_CLEAN}"           "${_GEN_ANDROID_BUILD_WORK_DIR}" _GEN_ANDROID_NDK_ROOT)
    _gen_android_to_abs_path("${GEN_ANDROID_SDK_ROOT_CLEAN}"           "${_GEN_ANDROID_BUILD_WORK_DIR}" _GEN_ANDROID_SDK_ROOT_INPUT)

    if(_GEN_ANDROID_SHARED_LIBRARY STREQUAL "" OR NOT EXISTS "${_GEN_ANDROID_SHARED_LIBRARY}")
      _gen_android_fail("Shared library not found:\n  ${_GEN_ANDROID_SHARED_LIBRARY}")
    endif()

    if(GEN_ANDROID_PROJECT_NAME_CLEAN STREQUAL "")
      get_filename_component(GEN_ANDROID_PROJECT_NAME_CLEAN "${_GEN_ANDROID_SHARED_LIBRARY}" NAME_WE)
      string(REGEX REPLACE "^lib" "" GEN_ANDROID_PROJECT_NAME_CLEAN "${GEN_ANDROID_PROJECT_NAME_CLEAN}")
    endif()

    if(GEN_ANDROID_APP_LABEL_CLEAN STREQUAL "")
      set(GEN_ANDROID_APP_LABEL_CLEAN "${GEN_ANDROID_PROJECT_NAME_CLEAN}")
    endif()

    if(GEN_ANDROID_APP_ID_CLEAN STREQUAL "")
      string(REGEX REPLACE "[^A-Za-z0-9_.]" "" _GEN_ANDROID_SANITIZED_ID "${GEN_ANDROID_PROJECT_NAME_CLEAN}")

      if(_GEN_ANDROID_SANITIZED_ID STREQUAL "")
        set(_GEN_ANDROID_SANITIZED_ID "app")
      endif()

      set(GEN_ANDROID_APP_ID_CLEAN "com.gen.${_GEN_ANDROID_SANITIZED_ID}")
    endif()

    if(GEN_ANDROID_TARGET_SDK_CLEAN STREQUAL "")
      if(DEFINED GEN_ANDROID_TARGET_SDK AND NOT "${GEN_ANDROID_TARGET_SDK}" STREQUAL "")
        set(GEN_ANDROID_TARGET_SDK_CLEAN "${GEN_ANDROID_TARGET_SDK}")
      else()
        set(GEN_ANDROID_TARGET_SDK_CLEAN "35")
      endif()
    endif()

    if(GEN_ANDROID_MIN_SDK_CLEAN STREQUAL "")
      if(DEFINED GEN_ANDROID_MIN_SDK AND NOT "${GEN_ANDROID_MIN_SDK}" STREQUAL "")
        set(GEN_ANDROID_MIN_SDK_CLEAN "${GEN_ANDROID_MIN_SDK}")
      elseif(DEFINED ANDROID_PLATFORM AND NOT "${ANDROID_PLATFORM}" STREQUAL "")
        _gen_android_extract_api_level("${ANDROID_PLATFORM}" GEN_ANDROID_MIN_SDK_CLEAN)
      else()
        set(GEN_ANDROID_MIN_SDK_CLEAN "24")
      endif()
    endif()

    if(GEN_ANDROID_ABI_CLEAN STREQUAL "")
      set(GEN_ANDROID_ABI_CLEAN "arm64-v8a")
    endif()

    set(_GEN_ANDROID_REAL_SDK_ROOT "${_GEN_ANDROID_SDK_ROOT_INPUT}")

    if(_GEN_ANDROID_REAL_SDK_ROOT STREQUAL "" OR NOT EXISTS "${_GEN_ANDROID_REAL_SDK_ROOT}/platforms")
      if(EXISTS "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-sdk")
        set(_GEN_ANDROID_REAL_SDK_ROOT "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-sdk")
      endif()
    endif()

    if(_GEN_ANDROID_REAL_SDK_ROOT STREQUAL "" OR NOT EXISTS "${_GEN_ANDROID_REAL_SDK_ROOT}")
      _gen_android_fail("A valid Android SDK was not found.\nSDK input: ${_GEN_ANDROID_SDK_ROOT_INPUT}")
    endif()

    if(_GEN_ANDROID_NDK_ROOT STREQUAL "" OR NOT EXISTS "${_GEN_ANDROID_NDK_ROOT}")
      if(EXISTS "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-ndk")
        set(_GEN_ANDROID_NDK_ROOT "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-ndk")
      endif()
    endif()

    set(_GEN_ANDROID_JAR "${_GEN_ANDROID_REAL_SDK_ROOT}/platforms/android-${GEN_ANDROID_TARGET_SDK_CLEAN}/android.jar")

    if(NOT EXISTS "${_GEN_ANDROID_JAR}")
      _gen_android_fail("android.jar was not found:\n  ${_GEN_ANDROID_JAR}")
    endif()

    _gen_android_find_newest("${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools" "*/aapt.exe" _GEN_ANDROID_AAPT)
    if(_GEN_ANDROID_AAPT STREQUAL "")
      _gen_android_find_newest("${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools" "*/aapt2.exe" _GEN_ANDROID_AAPT)
    endif()

    _gen_android_find_newest("${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools" "*/zipalign.exe" _GEN_ANDROID_ZIPALIGN)
    _gen_android_find_newest("${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools" "*/apksigner.bat" _GEN_ANDROID_APKSIGNER)

    if(_GEN_ANDROID_APKSIGNER STREQUAL "")
      _gen_android_find_newest("${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools" "*/apksigner" _GEN_ANDROID_APKSIGNER)
    endif()

    if(_GEN_ANDROID_AAPT STREQUAL "")
      _gen_android_fail("aapt was not found inside: ${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools")
    endif()

    if(_GEN_ANDROID_ZIPALIGN STREQUAL "")
      _gen_android_fail("zipalign was not found inside: ${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools")
    endif()

    if(_GEN_ANDROID_APKSIGNER STREQUAL "")
      _gen_android_fail("apksigner was not found inside: ${_GEN_ANDROID_REAL_SDK_ROOT}/build-tools")
    endif()

    message(STATUS "[ Framework root    : ${_GEN_ANDROID_FRAMEWORK_ROOT} ]")
    message(STATUS "[ NDK root          : ${GEN_ANDROID_NDK_ROOT_CLEAN} ]")
   #message(STATUS "[ NDK root resolved : ${_GEN_ANDROID_NDK_ROOT} ]")
    message(STATUS "[ SDK root          : ${GEN_ANDROID_SDK_ROOT_CLEAN} ]")
   #message(STATUS "[ SDK root resolved : ${_GEN_ANDROID_SDK_ROOT_INPUT} ]")

    set(_GEN_ANDROID_WORK_DIR       "${_GEN_ANDROID_OUTPUT_DIR}/.gen_android_package")
    set(_GEN_ANDROID_PACKAGE_DIR    "${_GEN_ANDROID_WORK_DIR}/package")
    set(_GEN_ANDROID_AAPT_INPUT_DIR "${_GEN_ANDROID_WORK_DIR}/aapt")
    set(_GEN_ANDROID_AAPT_RES_DIR   "${_GEN_ANDROID_AAPT_INPUT_DIR}/res")
    set(_GEN_ANDROID_LIB_DIR        "${_GEN_ANDROID_PACKAGE_DIR}/lib/${GEN_ANDROID_ABI_CLEAN}")
    set(_GEN_ANDROID_MANIFEST_PATH  "${_GEN_ANDROID_GENERATED_MANIFEST}")

    if(_GEN_ANDROID_MANIFEST_PATH STREQUAL "")
      set(_GEN_ANDROID_MANIFEST_PATH "${_GEN_ANDROID_WORK_DIR}/AndroidManifest.xml")
    endif()

    file(REMOVE_RECURSE "${_GEN_ANDROID_PACKAGE_DIR}" "${_GEN_ANDROID_AAPT_INPUT_DIR}")
    file(MAKE_DIRECTORY "${_GEN_ANDROID_WORK_DIR}")
    file(MAKE_DIRECTORY "${_GEN_ANDROID_PACKAGE_DIR}")
    file(MAKE_DIRECTORY "${_GEN_ANDROID_LIB_DIR}")
    file(MAKE_DIRECTORY "${_GEN_ANDROID_AAPT_RES_DIR}")

    message(STATUS "[ AAPT input dir    : ${_GEN_ANDROID_AAPT_INPUT_DIR} ]")

    set(_GEN_ANDROID_PACKAGE_ASSETS_DIR "")
    set(_GEN_ANDROID_PACKAGE_RES_DIR    "")

    if(NOT _GEN_ANDROID_ASSETS_DIR STREQUAL "")
      if(EXISTS "${_GEN_ANDROID_ASSETS_DIR}/package")
        set(_GEN_ANDROID_PACKAGE_ASSETS_DIR "${_GEN_ANDROID_ASSETS_DIR}/package")

        if(EXISTS "${_GEN_ANDROID_PACKAGE_ASSETS_DIR}/res")
          set(_GEN_ANDROID_PACKAGE_RES_DIR "${_GEN_ANDROID_PACKAGE_ASSETS_DIR}/res")
          file(COPY "${_GEN_ANDROID_PACKAGE_RES_DIR}/" DESTINATION "${_GEN_ANDROID_AAPT_RES_DIR}")
          message(STATUS "[ Package res       : ${_GEN_ANDROID_PACKAGE_RES_DIR} ]")
        endif()
      endif()
    endif()

    get_filename_component(_GEN_ANDROID_MANIFEST_DIR "${_GEN_ANDROID_MANIFEST_PATH}" DIRECTORY)
    file(MAKE_DIRECTORY "${_GEN_ANDROID_MANIFEST_DIR}")

    file(WRITE  "${_GEN_ANDROID_MANIFEST_PATH}" "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\"\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    package=\"${GEN_ANDROID_APP_ID_CLEAN}\"\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    android:versionCode=\"1\"\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    android:versionName=\"1.0\">\n\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-sdk android:minSdkVersion=\"${GEN_ANDROID_MIN_SDK_CLEAN}\" android:targetSdkVersion=\"${GEN_ANDROID_TARGET_SDK_CLEAN}\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-feature android:glEsVersion=\"0x00020000\" android:required=\"false\" />\n")

    # Network permissions required by GEN XTrace/DIO UDP/TCP and examples such as UI_System
    # (internet check, public IP HTTP, local iface enum, Wi-Fi link state). The assets/package
    # AndroidManifest may list these too, but the generated APK manifest is written here from
    # scratch, so they must be emitted here as well.
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-permission android:name=\"android.permission.INTERNET\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-permission android:name=\"android.permission.ACCESS_NETWORK_STATE\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-permission android:name=\"android.permission.ACCESS_WIFI_STATE\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-permission android:name=\"android.permission.CHANGE_WIFI_MULTICAST_STATE\" />\n")
    if(GEN_ANDROID_TARGET_SDK_CLEAN GREATER_EQUAL 33)
      file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    <uses-permission android:name=\"android.permission.NEARBY_WIFI_DEVICES\" android:usesPermissionFlags=\"neverForLocation\" />\n")
    endif()
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "\n")

    set(_GEN_ANDROID_APPLICATION_ATTRS "    <application android:label=\"${GEN_ANDROID_APP_LABEL_CLEAN}\" android:icon=\"@drawable/icon\" android:hasCode=\"false\" android:extractNativeLibs=\"true\"")

    if(GEN_ANDROID_TARGET_SDK_CLEAN GREATER_EQUAL 25)
      string(APPEND _GEN_ANDROID_APPLICATION_ATTRS " android:roundIcon=\"@drawable/icon\"")
    endif()

    string(APPEND _GEN_ANDROID_APPLICATION_ATTRS ">\n")

    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "${_GEN_ANDROID_APPLICATION_ATTRS}")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "        <activity android:name=\"android.app.NativeActivity\" android:exported=\"true\" android:launchMode=\"singleTask\" android:configChanges=\"orientation|keyboardHidden|keyboard|navigation|screenLayout|screenSize|smallestScreenSize|uiMode|density|locale\" android:screenOrientation=\"landscape\">\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "            <intent-filter>\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "                <action android:name=\"android.intent.action.MAIN\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "                <category android:name=\"android.intent.category.LAUNCHER\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "            </intent-filter>\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "            <meta-data android:name=\"android.app.lib_name\" android:value=\"${GEN_ANDROID_PROJECT_NAME_CLEAN}\" />\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "        </activity>\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "    </application>\n")
    file(APPEND "${_GEN_ANDROID_MANIFEST_PATH}" "</manifest>\n")

    file(COPY "${_GEN_ANDROID_SHARED_LIBRARY}" DESTINATION "${_GEN_ANDROID_LIB_DIR}")

    set(_GEN_ANDROID_LIBCPP     "")
    set(_GEN_ANDROID_NDK_TRIPLE "")

    if(GEN_ANDROID_ABI_CLEAN STREQUAL "arm64-v8a")
      set(_GEN_ANDROID_NDK_TRIPLE "aarch64-linux-android")
    elseif(GEN_ANDROID_ABI_CLEAN STREQUAL "armeabi-v7a")
      set(_GEN_ANDROID_NDK_TRIPLE "arm-linux-androideabi")
    elseif(GEN_ANDROID_ABI_CLEAN STREQUAL "x86")
      set(_GEN_ANDROID_NDK_TRIPLE "i686-linux-android")
    elseif(GEN_ANDROID_ABI_CLEAN STREQUAL "x86_64")
      set(_GEN_ANDROID_NDK_TRIPLE "x86_64-linux-android")
    endif()

    if(NOT _GEN_ANDROID_NDK_TRIPLE STREQUAL "")
      set(_GEN_ANDROID_LIBCPP_CANDIDATES
        "${_GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/${_GEN_ANDROID_NDK_TRIPLE}/libc++_shared.so"
        "${_GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/${_GEN_ANDROID_NDK_TRIPLE}/${GEN_ANDROID_MIN_SDK_CLEAN}/libc++_shared.so"
        "${_GEN_ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/${_GEN_ANDROID_NDK_TRIPLE}/${GEN_ANDROID_TARGET_SDK_CLEAN}/libc++_shared.so"
      )

      foreach(_GEN_ANDROID_CANDIDATE IN LISTS _GEN_ANDROID_LIBCPP_CANDIDATES)
        if(EXISTS "${_GEN_ANDROID_CANDIDATE}")
          set(_GEN_ANDROID_LIBCPP "${_GEN_ANDROID_CANDIDATE}")
          break()
        endif()
      endforeach()
    endif()

    if(_GEN_ANDROID_LIBCPP STREQUAL "")
      _gen_android_find_newest("${_GEN_ANDROID_NDK_ROOT}" "*/${_GEN_ANDROID_NDK_TRIPLE}*/libc++_shared.so" _GEN_ANDROID_LIBCPP)
    endif()

    if(_GEN_ANDROID_LIBCPP STREQUAL "")
      _gen_android_find_newest("${_GEN_ANDROID_NDK_ROOT}" "*/libc++_shared.so" _GEN_ANDROID_LIBCPP)
    endif()

    if(NOT _GEN_ANDROID_LIBCPP STREQUAL "")
      message(STATUS "[ libc++_shared     : ${_GEN_ANDROID_LIBCPP} ]")
      file(COPY "${_GEN_ANDROID_LIBCPP}" DESTINATION "${_GEN_ANDROID_LIB_DIR}")
    else()
      message(WARNING "[ libc++_shared.so was not found. The APK may crash on startup. ]")
    endif()

    if(NOT _GEN_ANDROID_ASSETS_DIR STREQUAL "" AND EXISTS "${_GEN_ANDROID_ASSETS_DIR}")
      file(MAKE_DIRECTORY "${_GEN_ANDROID_PACKAGE_DIR}/assets")
      file(GLOB _GEN_ANDROID_ASSET_ENTRIES RELATIVE "${_GEN_ANDROID_ASSETS_DIR}" "${_GEN_ANDROID_ASSETS_DIR}/*")

      foreach(_GEN_ANDROID_ASSET_ENTRY IN LISTS _GEN_ANDROID_ASSET_ENTRIES)
        if(NOT _GEN_ANDROID_ASSET_ENTRY STREQUAL "package")
          file(COPY "${_GEN_ANDROID_ASSETS_DIR}/${_GEN_ANDROID_ASSET_ENTRY}" DESTINATION "${_GEN_ANDROID_PACKAGE_DIR}/assets")
        endif()
      endforeach()
    endif()

    set(_GEN_ANDROID_KEYSTORE_DIR "${_GEN_ANDROID_WORK_DIR}/debug_keystore")
    set(_GEN_ANDROID_KEYSTORE     "${_GEN_ANDROID_KEYSTORE_DIR}/android-debug.keystore")

    file(MAKE_DIRECTORY "${_GEN_ANDROID_KEYSTORE_DIR}")

    if(NOT EXISTS "${_GEN_ANDROID_KEYSTORE}")
      find_program(_GEN_ANDROID_KEYTOOL keytool)

      if(_GEN_ANDROID_KEYTOOL STREQUAL "_GEN_ANDROID_KEYTOOL-NOTFOUND")
        _gen_android_fail("keytool was not found in PATH to generate the debug keystore")
      endif()

      execute_process(
        COMMAND "${_GEN_ANDROID_KEYTOOL}" -genkeypair -noprompt -keystore "${_GEN_ANDROID_KEYSTORE}" -storepass android -keypass android -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
        RESULT_VARIABLE _GEN_ANDROID_KEYTOOL_RESULT
      )

      if(NOT _GEN_ANDROID_KEYTOOL_RESULT EQUAL 0)
        _gen_android_fail("Could not generate the debug keystore")
      endif()
    endif()

    set(_GEN_ANDROID_UNALIGNED_APK "${_GEN_ANDROID_OUTPUT_DIR}/${GEN_ANDROID_PROJECT_NAME_CLEAN}-unaligned.apk")
    set(_GEN_ANDROID_ALIGNED_APK   "${_GEN_ANDROID_OUTPUT_DIR}/${GEN_ANDROID_PROJECT_NAME_CLEAN}-aligned.apk")
    set(_GEN_ANDROID_FINAL_APK     "${_GEN_ANDROID_OUTPUT_DIR}/${GEN_ANDROID_PROJECT_NAME_CLEAN}.apk")

    file(REMOVE "${_GEN_ANDROID_UNALIGNED_APK}" "${_GEN_ANDROID_ALIGNED_APK}" "${_GEN_ANDROID_FINAL_APK}")

    execute_process(
      COMMAND "${_GEN_ANDROID_AAPT}" package -f -M "${_GEN_ANDROID_MANIFEST_PATH}" -I "${_GEN_ANDROID_JAR}" -S "${_GEN_ANDROID_AAPT_RES_DIR}" -F "${_GEN_ANDROID_UNALIGNED_APK}" "${_GEN_ANDROID_AAPT_INPUT_DIR}"
      RESULT_VARIABLE _GEN_ANDROID_AAPT_RESULT
      OUTPUT_VARIABLE _GEN_ANDROID_AAPT_OUTPUT
      ERROR_VARIABLE  _GEN_ANDROID_AAPT_ERROR
    )

    if(NOT _GEN_ANDROID_AAPT_RESULT EQUAL 0)
      message(STATUS "${_GEN_ANDROID_AAPT_OUTPUT}")
      message(STATUS "${_GEN_ANDROID_AAPT_ERROR}")
      _gen_android_fail("aapt package failed")
    endif()

    set(_GEN_ANDROID_MERGE_PS1 "${_GEN_ANDROID_WORK_DIR}/merge_payload.ps1")

    file(WRITE  "${_GEN_ANDROID_MERGE_PS1}" "Add-Type -AssemblyName System.IO.Compression\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "Add-Type -AssemblyName System.IO.Compression.FileSystem\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "$apk = [System.IO.Path]::GetFullPath('${_GEN_ANDROID_UNALIGNED_APK}')\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "$pkg = [System.IO.Path]::GetFullPath('${_GEN_ANDROID_PACKAGE_DIR}')\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "$zip = [System.IO.Compression.ZipFile]::Open($apk, [System.IO.Compression.ZipArchiveMode]::Update)\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "try {\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  $pkgRoot = [System.IO.Path]::GetFullPath($pkg)\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  $pkgRootWithSep = $pkgRoot\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  if(-not $pkgRootWithSep.EndsWith([System.IO.Path]::DirectorySeparatorChar)) { $pkgRootWithSep += [System.IO.Path]::DirectorySeparatorChar }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  $entries = @()\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  if(Test-Path (Join-Path $pkg 'lib')) { $entries += Get-ChildItem -Path (Join-Path $pkg 'lib') -Recurse -File }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  if(Test-Path (Join-Path $pkg 'assets')) { $entries += Get-ChildItem -Path (Join-Path $pkg 'assets') -Recurse -File }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  foreach($f in $entries) {\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    $full = [System.IO.Path]::GetFullPath($f.FullName)\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    if(-not $full.StartsWith($pkgRootWithSep)) { throw 'Entry outside the package directory: ' + $full }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    $rel = $full.Substring($pkgRootWithSep.Length).Replace('\\','/')\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    $existing = $zip.GetEntry($rel)\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    if($existing -ne $null) { $existing.Delete() }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    $level = [System.IO.Compression.CompressionLevel]::Optimal\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    if($rel.StartsWith('lib/')) { $level = [System.IO.Compression.CompressionLevel]::NoCompression }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $full, $rel, $level) | Out-Null\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "  }\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "}\n")
    file(APPEND "${_GEN_ANDROID_MERGE_PS1}" "finally { if($zip -ne $null) { $zip.Dispose() } }\n")

    find_program(_GEN_ANDROID_POWERSHELL_EXECUTABLE NAMES powershell pwsh REQUIRED)

    execute_process(
      COMMAND "${_GEN_ANDROID_POWERSHELL_EXECUTABLE}" -NoProfile -ExecutionPolicy Bypass -File "${_GEN_ANDROID_MERGE_PS1}"
      RESULT_VARIABLE _GEN_ANDROID_MERGE_RESULT
      OUTPUT_VARIABLE _GEN_ANDROID_MERGE_OUTPUT
      ERROR_VARIABLE  _GEN_ANDROID_MERGE_ERROR
    )

    if(NOT _GEN_ANDROID_MERGE_RESULT EQUAL 0)
      message(STATUS "${_GEN_ANDROID_MERGE_OUTPUT}")
      message(STATUS "${_GEN_ANDROID_MERGE_ERROR}")
      _gen_android_fail("Could not insert lib/ and assets/ into the APK")
    endif()

    execute_process(
      COMMAND "${_GEN_ANDROID_ZIPALIGN}" -f 4 "${_GEN_ANDROID_UNALIGNED_APK}" "${_GEN_ANDROID_ALIGNED_APK}"
      RESULT_VARIABLE _GEN_ANDROID_ZIPALIGN_RESULT
      OUTPUT_VARIABLE _GEN_ANDROID_ZIPALIGN_OUTPUT
      ERROR_VARIABLE  _GEN_ANDROID_ZIPALIGN_ERROR
    )

    if(NOT _GEN_ANDROID_ZIPALIGN_RESULT EQUAL 0)
      message(STATUS "${_GEN_ANDROID_ZIPALIGN_OUTPUT}")
      message(STATUS "${_GEN_ANDROID_ZIPALIGN_ERROR}")
      _gen_android_fail("zipalign failed")
    endif()

    execute_process(
      COMMAND "${_GEN_ANDROID_APKSIGNER}" sign --ks "${_GEN_ANDROID_KEYSTORE}" --ks-pass pass:android --key-pass pass:android --out "${_GEN_ANDROID_FINAL_APK}" "${_GEN_ANDROID_ALIGNED_APK}"
      RESULT_VARIABLE _GEN_ANDROID_SIGN_RESULT
      OUTPUT_VARIABLE _GEN_ANDROID_SIGN_OUTPUT
      ERROR_VARIABLE  _GEN_ANDROID_SIGN_ERROR
    )

    if(NOT _GEN_ANDROID_SIGN_RESULT EQUAL 0)
      message(STATUS "${_GEN_ANDROID_SIGN_OUTPUT}")
      message(STATUS "${_GEN_ANDROID_SIGN_ERROR}")
      _gen_android_fail("apksigner failed")
    endif()

    message(STATUS "[ APK generated successfully ${_GEN_ANDROID_FINAL_APK} ]")
  endfunction()


  # --------------------------------------------------------------------
  # Configure-time integration

  function(gen_android_add_build_package)
    set(_GEN_ANDROID_OPTIONS)
    set(_GEN_ANDROID_ONE_VALUE_ARGS
      TARGET_NAME
      PROJECT_NAME
      TARGET_SDK
      MIN_SDK
      SHARED_LIBRARY
      OUTPUT_DIR
      SOURCE_ASSETS_DIR
      GENERATED_MANIFEST
      JAVA_HOME
      FRAMEWORK_ROOT
      NDK_ROOT
      SDK_ROOT
      APP_ID
      APP_LABEL
      ABI
    )

    cmake_parse_arguments(GENAPK "${_GEN_ANDROID_OPTIONS}" "${_GEN_ANDROID_ONE_VALUE_ARGS}" "" ${ARGN})

    if(NOT GENAPK_TARGET_NAME)
      message(FATAL_ERROR "gen_android_add_build_package: TARGET_NAME is required")
    endif()

    if(NOT TARGET "${GENAPK_TARGET_NAME}")
      message(FATAL_ERROR "gen_android_add_build_package: target does not exist: ${GENAPK_TARGET_NAME}")
    endif()

    if(NOT GENAPK_PROJECT_NAME)
      set(GENAPK_PROJECT_NAME "${GENAPK_TARGET_NAME}")
    endif()

    if(NOT GENAPK_TARGET_SDK)
      if(DEFINED GEN_ANDROID_TARGET_SDK AND NOT "${GEN_ANDROID_TARGET_SDK}" STREQUAL "")
        set(GENAPK_TARGET_SDK "${GEN_ANDROID_TARGET_SDK}")
      else()
        set(GENAPK_TARGET_SDK "35")
      endif()
    endif()

    if(NOT GENAPK_MIN_SDK)
      if(DEFINED GEN_ANDROID_MIN_SDK AND NOT "${GEN_ANDROID_MIN_SDK}" STREQUAL "")
        set(GENAPK_MIN_SDK "${GEN_ANDROID_MIN_SDK}")
      elseif(DEFINED ANDROID_PLATFORM AND NOT "${ANDROID_PLATFORM}" STREQUAL "")
        _gen_android_extract_api_level("${ANDROID_PLATFORM}" GENAPK_MIN_SDK)
      else()
        set(GENAPK_MIN_SDK "24")
      endif()
    endif()

    if(NOT GENAPK_OUTPUT_DIR)
      set(GENAPK_OUTPUT_DIR "${CMAKE_BINARY_DIR}")
    endif()

    if(NOT GENAPK_GENERATED_MANIFEST)
      set(GENAPK_GENERATED_MANIFEST "${GENAPK_OUTPUT_DIR}/.gen_android_package/AndroidManifest.xml")
    endif()

    if(NOT GENAPK_FRAMEWORK_ROOT)
      _gen_android_get_framework_root(GENAPK_FRAMEWORK_ROOT)
    endif()

    _gen_android_to_cmake_path("${GENAPK_FRAMEWORK_ROOT}" GENAPK_FRAMEWORK_ROOT)
    _gen_android_to_cmake_path("${GENAPK_OUTPUT_DIR}"     GENAPK_OUTPUT_DIR)

    if(NOT GENAPK_SOURCE_ASSETS_DIR)
      if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../assets")
        set(GENAPK_SOURCE_ASSETS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../assets")
      elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/assets")
        set(GENAPK_SOURCE_ASSETS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/assets")
      else()
        set(GENAPK_SOURCE_ASSETS_DIR "")
      endif()
    endif()

    if(NOT GENAPK_SHARED_LIBRARY)
      set(GENAPK_SHARED_LIBRARY "$<TARGET_FILE:${GENAPK_TARGET_NAME}>")
    endif()

    if(NOT GENAPK_NDK_ROOT)
      set(_GEN_ANDROID_NDK_ABS "${GENAPK_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-ndk")
      file(RELATIVE_PATH GENAPK_NDK_ROOT "${GENAPK_OUTPUT_DIR}" "${_GEN_ANDROID_NDK_ABS}")
    endif()

    if(NOT GENAPK_SDK_ROOT)
      set(_GEN_ANDROID_SDK_ABS "${GENAPK_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-sdk")
      file(RELATIVE_PATH GENAPK_SDK_ROOT "${GENAPK_OUTPUT_DIR}" "${_GEN_ANDROID_SDK_ABS}")
    endif()

    if(NOT GENAPK_APP_ID)
      set(GENAPK_APP_ID "com.gen.${GENAPK_PROJECT_NAME}")
    endif()

    if(NOT GENAPK_APP_LABEL)
      set(GENAPK_APP_LABEL "${GENAPK_PROJECT_NAME}")
    endif()

    if(NOT GENAPK_ABI)
      if(DEFINED ANDROID_ABI AND NOT "${ANDROID_ABI}" STREQUAL "")
        set(GENAPK_ABI "${ANDROID_ABI}")
      elseif(DEFINED CMAKE_ANDROID_ARCH_ABI AND NOT "${CMAKE_ANDROID_ARCH_ABI}" STREQUAL "")
        set(GENAPK_ABI "${CMAKE_ANDROID_ARCH_ABI}")
      else()
        set(GENAPK_ABI "arm64-v8a")
      endif()
    endif()

    _gen_android_to_cmake_path("${GENAPK_NDK_ROOT}" GENAPK_NDK_ROOT)
    _gen_android_to_cmake_path("${GENAPK_SDK_ROOT}" GENAPK_SDK_ROOT)

    _gen_android_relativize_path("${GENAPK_SOURCE_ASSETS_DIR}" "${GENAPK_OUTPUT_DIR}" GENAPK_SOURCE_ASSETS_DIR)
    _gen_android_relativize_path("${GENAPK_GENERATED_MANIFEST}" "${GENAPK_OUTPUT_DIR}" GENAPK_GENERATED_MANIFEST)
    _gen_android_relativize_path("${GENAPK_NDK_ROOT}" "${GENAPK_OUTPUT_DIR}" GENAPK_NDK_ROOT)
    _gen_android_relativize_path("${GENAPK_SDK_ROOT}" "${GENAPK_OUTPUT_DIR}" GENAPK_SDK_ROOT)

    set(_GEN_ANDROID_BUILD_SCRIPT "${GENAPK_FRAMEWORK_ROOT}/Common/CMake/Main/GEN_Main_Android_BuildPackage.cmake")
    _gen_android_to_cmake_path("${_GEN_ANDROID_BUILD_SCRIPT}" _GEN_ANDROID_BUILD_SCRIPT)

    if(NOT EXISTS "${_GEN_ANDROID_BUILD_SCRIPT}")
      message(FATAL_ERROR "[ GEN Android Build package script was not found: ${_GEN_ANDROID_BUILD_SCRIPT} ]")
    endif()

    set(_GEN_ANDROID_GUARD "GEN_ANDROID_POST_BUILD_ADDED_${GENAPK_TARGET_NAME}")
    get_property(_GEN_ANDROID_POST_BUILD_ADDED GLOBAL PROPERTY "${_GEN_ANDROID_GUARD}")

    if(NOT _GEN_ANDROID_POST_BUILD_ADDED)
      set_property(GLOBAL PROPERTY "${_GEN_ANDROID_GUARD}" TRUE)

      add_custom_command(
        TARGET "${GENAPK_TARGET_NAME}" POST_BUILD
        
        COMMAND "${CMAKE_COMMAND}" -E echo ""
        COMMAND "${CMAKE_COMMAND}" -E echo "Generate Android APK for ${GENAPK_PROJECT_NAME}:"
        
        COMMAND "${CMAKE_COMMAND}"
          "-DGEN_ANDROID_SOURCE_ASSETS_DIR=${GENAPK_SOURCE_ASSETS_DIR}"
          "-DGEN_ANDROID_GENERATED_MANIFEST=${GENAPK_GENERATED_MANIFEST}"
          "-DGEN_ANDROID_NDK_ROOT=${GENAPK_NDK_ROOT}"
          "-DGEN_ANDROID_SDK_ROOT=${GENAPK_SDK_ROOT}"
          "-DGEN_ANDROID_JAVA_HOME=${GENAPK_JAVA_HOME}"
          "-DGEN_ANDROID_ABI=${GENAPK_ABI}"
          "-DGEN_ANDROID_TARGET_SDK=${GENAPK_TARGET_SDK}"
          "-DGEN_ANDROID_MIN_SDK=${GENAPK_MIN_SDK}"
          "-DGEN_ANDROID_PROJECT_NAME=${GENAPK_PROJECT_NAME}"
          "-DGEN_ANDROID_APP_ID=${GENAPK_APP_ID}"
          "-DGEN_ANDROID_APP_LABEL=${GENAPK_APP_LABEL}"
          "-DGEN_ANDROID_SHARED_LIBRARY=${GENAPK_SHARED_LIBRARY}"
          "-DGEN_ANDROID_OUTPUT_DIR=${GENAPK_OUTPUT_DIR}"
          -P "${_GEN_ANDROID_BUILD_SCRIPT}"        
      )
    endif()

    set(_GEN_ANDROID_APK_TARGET "${GENAPK_PROJECT_NAME}_apk")

    if(NOT TARGET "${_GEN_ANDROID_APK_TARGET}")
      add_custom_target("${_GEN_ANDROID_APK_TARGET}" DEPENDS "${GENAPK_TARGET_NAME}")
    endif()

    # ------------------------------------------------------------------
    # Stable alias target "android_apk" so that CMakePresets.json can
    # reference a fixed, project-independent target name. Builds the
    # per-project "<PROJECT_NAME>_apk" target above, and is added to ALL
    # so that "Build All" / F7 generates the APK automatically.
    # ------------------------------------------------------------------
    if(NOT TARGET "android_apk")
      add_custom_target("android_apk" ALL DEPENDS "${_GEN_ANDROID_APK_TARGET}")
    endif()
  endfunction()

  function(gen_android_add_apk_target)
    gen_android_add_build_package(${ARGN})
  endfunction()

  function(_gen_android_build_package_autorun)
    _gen_android_get_framework_root(_GEN_ANDROID_FRAMEWORK_ROOT)

    if(NOT DEFINED GEN_ANDROID_TARGET_NAME OR "${GEN_ANDROID_TARGET_NAME}" STREQUAL "")
      if(TARGET "${CMAKE_PROJECT_NAME}")
        set(GEN_ANDROID_TARGET_NAME "${CMAKE_PROJECT_NAME}")
      elseif(TARGET "${PROJECT_NAME}")
        set(GEN_ANDROID_TARGET_NAME "${PROJECT_NAME}")
      else()
        set(GEN_ANDROID_TARGET_NAME "${CMAKE_PROJECT_NAME}")
      endif()
    endif()

    if(NOT DEFINED GEN_ANDROID_PROJECT_NAME OR "${GEN_ANDROID_PROJECT_NAME}" STREQUAL "")
      if(DEFINED APP_PROJECT_NAME AND NOT "${APP_PROJECT_NAME}" STREQUAL "")
        set(GEN_ANDROID_PROJECT_NAME "${APP_PROJECT_NAME}")
      elseif(NOT "${GEN_ANDROID_TARGET_NAME}" STREQUAL "")
        set(GEN_ANDROID_PROJECT_NAME "${GEN_ANDROID_TARGET_NAME}")
      elseif(NOT "${PROJECT_NAME}" STREQUAL "")
        set(GEN_ANDROID_PROJECT_NAME "${PROJECT_NAME}")
      else()
        get_filename_component(GEN_ANDROID_PROJECT_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
      endif()
    endif()

    if(NOT DEFINED GEN_ANDROID_ABI OR "${GEN_ANDROID_ABI}" STREQUAL "")
      if(DEFINED ANDROID_ABI AND NOT "${ANDROID_ABI}" STREQUAL "")
        set(GEN_ANDROID_ABI "${ANDROID_ABI}")
      elseif(DEFINED CMAKE_ANDROID_ARCH_ABI AND NOT "${CMAKE_ANDROID_ARCH_ABI}" STREQUAL "")
        set(GEN_ANDROID_ABI "${CMAKE_ANDROID_ARCH_ABI}")
      else()
        set(GEN_ANDROID_ABI "arm64-v8a")
      endif()
    endif()

    if(NOT DEFINED GEN_ANDROID_TARGET_SDK OR "${GEN_ANDROID_TARGET_SDK}" STREQUAL "")
      set(GEN_ANDROID_TARGET_SDK "35")
    endif()

    if(NOT DEFINED GEN_ANDROID_MIN_SDK OR "${GEN_ANDROID_MIN_SDK}" STREQUAL "")
      if(DEFINED ANDROID_PLATFORM AND NOT "${ANDROID_PLATFORM}" STREQUAL "")
        _gen_android_extract_api_level("${ANDROID_PLATFORM}" GEN_ANDROID_MIN_SDK)
      else()
        set(GEN_ANDROID_MIN_SDK "24")
      endif()
    endif()

    if(NOT DEFINED GEN_ANDROID_OUTPUT_DIR OR "${GEN_ANDROID_OUTPUT_DIR}" STREQUAL "")
      set(GEN_ANDROID_OUTPUT_DIR "${CMAKE_BINARY_DIR}")
    endif()

    if(NOT DEFINED GEN_ANDROID_SOURCE_ASSETS_DIR OR "${GEN_ANDROID_SOURCE_ASSETS_DIR}" STREQUAL "")
      if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../assets")
        set(GEN_ANDROID_SOURCE_ASSETS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../assets")
      elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/assets")
        set(GEN_ANDROID_SOURCE_ASSETS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/assets")
      else()
        set(GEN_ANDROID_SOURCE_ASSETS_DIR "")
      endif()
    endif()

    if(NOT DEFINED GEN_ANDROID_GENERATED_MANIFEST OR "${GEN_ANDROID_GENERATED_MANIFEST}" STREQUAL "")
      set(GEN_ANDROID_GENERATED_MANIFEST "${GEN_ANDROID_OUTPUT_DIR}/.gen_android_package/AndroidManifest.xml")
    endif()

    if(NOT DEFINED GEN_ANDROID_JAVA_HOME)
      set(GEN_ANDROID_JAVA_HOME "")
    endif()

    if(NOT DEFINED GEN_ANDROID_NDK_ROOT OR "${GEN_ANDROID_NDK_ROOT}" STREQUAL "")
      set(_GEN_ANDROID_NDK_ABS "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-ndk")
      file(RELATIVE_PATH GEN_ANDROID_NDK_ROOT "${GEN_ANDROID_OUTPUT_DIR}" "${_GEN_ANDROID_NDK_ABS}")
    endif()

    if(NOT DEFINED GEN_ANDROID_SDK_ROOT OR "${GEN_ANDROID_SDK_ROOT}" STREQUAL "")
      set(_GEN_ANDROID_SDK_ABS "${_GEN_ANDROID_FRAMEWORK_ROOT}/ThirdPartyLibraries/android-sdk")
      file(RELATIVE_PATH GEN_ANDROID_SDK_ROOT "${GEN_ANDROID_OUTPUT_DIR}" "${_GEN_ANDROID_SDK_ABS}")
    endif()

    if(NOT DEFINED GEN_ANDROID_APP_ID OR "${GEN_ANDROID_APP_ID}" STREQUAL "")
      set(GEN_ANDROID_APP_ID "com.gen.${GEN_ANDROID_PROJECT_NAME}")
    endif()

    if(NOT DEFINED GEN_ANDROID_APP_LABEL OR "${GEN_ANDROID_APP_LABEL}" STREQUAL "")
      set(GEN_ANDROID_APP_LABEL "${GEN_ANDROID_PROJECT_NAME}")
    endif()

    if(NOT DEFINED GEN_ANDROID_SHARED_LIBRARY OR "${GEN_ANDROID_SHARED_LIBRARY}" STREQUAL "")
      if(TARGET "${GEN_ANDROID_TARGET_NAME}")
        set(GEN_ANDROID_SHARED_LIBRARY "$<TARGET_FILE:${GEN_ANDROID_TARGET_NAME}>")
      else()
        set(GEN_ANDROID_SHARED_LIBRARY "${GEN_ANDROID_OUTPUT_DIR}/lib${GEN_ANDROID_PROJECT_NAME}.so")
      endif()
    endif()

    foreach(_GEN_ANDROID_VAR
      GEN_ANDROID_TARGET_NAME
      GEN_ANDROID_PROJECT_NAME
      GEN_ANDROID_ABI
      GEN_ANDROID_TARGET_SDK
      GEN_ANDROID_MIN_SDK
      GEN_ANDROID_OUTPUT_DIR
      GEN_ANDROID_SOURCE_ASSETS_DIR
      GEN_ANDROID_GENERATED_MANIFEST
      GEN_ANDROID_JAVA_HOME
      GEN_ANDROID_NDK_ROOT
      GEN_ANDROID_SDK_ROOT
      GEN_ANDROID_APP_ID
      GEN_ANDROID_APP_LABEL
      GEN_ANDROID_SHARED_LIBRARY)
      _gen_android_strip_quotes(${_GEN_ANDROID_VAR} ${_GEN_ANDROID_VAR})
    endforeach()

    foreach(_GEN_ANDROID_VAR
      GEN_ANDROID_OUTPUT_DIR
      GEN_ANDROID_SOURCE_ASSETS_DIR
      GEN_ANDROID_GENERATED_MANIFEST
      GEN_ANDROID_JAVA_HOME
      GEN_ANDROID_NDK_ROOT
      GEN_ANDROID_SDK_ROOT)
      _gen_android_to_cmake_path("${${_GEN_ANDROID_VAR}}" ${_GEN_ANDROID_VAR})
    endforeach()

    _gen_android_to_abs_path("${GEN_ANDROID_OUTPUT_DIR}" "${CMAKE_CURRENT_BINARY_DIR}" _GEN_ANDROID_OUTPUT_DIR_ABS)

    _gen_android_relativize_path("${GEN_ANDROID_SOURCE_ASSETS_DIR}" "${_GEN_ANDROID_OUTPUT_DIR_ABS}" GEN_ANDROID_SOURCE_ASSETS_DIR)
    _gen_android_relativize_path("${GEN_ANDROID_GENERATED_MANIFEST}" "${_GEN_ANDROID_OUTPUT_DIR_ABS}" GEN_ANDROID_GENERATED_MANIFEST)
    _gen_android_relativize_path("${GEN_ANDROID_NDK_ROOT}" "${_GEN_ANDROID_OUTPUT_DIR_ABS}" GEN_ANDROID_NDK_ROOT)
    _gen_android_relativize_path("${GEN_ANDROID_SDK_ROOT}" "${_GEN_ANDROID_OUTPUT_DIR_ABS}" GEN_ANDROID_SDK_ROOT)

    if(NOT TARGET "${GEN_ANDROID_TARGET_NAME}")
      message(FATAL_ERROR "[ GEN Android Target '${GEN_ANDROID_TARGET_NAME}' does not exist when including GEN_Main_Android_BuildPackage.cmake ]")
    endif()

    message(STATUS "[ GEN Android Project name     : ${GEN_ANDROID_PROJECT_NAME} ]")
    message(STATUS "[ GEN Android ABI              : ${GEN_ANDROID_ABI} ]")
    message(STATUS "[ GEN Android Min SDK          : ${GEN_ANDROID_MIN_SDK} ]")
    message(STATUS "[ GEN Android Target SDK       : ${GEN_ANDROID_TARGET_SDK} ]")
    message(STATUS "[ GEN Android Output dir       : ${GEN_ANDROID_OUTPUT_DIR} ]")
    message(STATUS "[ GEN Android NDK root (input) : ${GEN_ANDROID_NDK_ROOT} ]")
    message(STATUS "[ GEN Android SDK root (input) : ${GEN_ANDROID_SDK_ROOT} ]")
   #message(STATUS "[ GEN Android Shared library   : ${GEN_ANDROID_SHARED_LIBRARY} ]")

    gen_android_add_build_package(
      TARGET_NAME        "${GEN_ANDROID_TARGET_NAME}"
      PROJECT_NAME       "${GEN_ANDROID_PROJECT_NAME}"
      TARGET_SDK         "${GEN_ANDROID_TARGET_SDK}"
      MIN_SDK            "${GEN_ANDROID_MIN_SDK}"
      SHARED_LIBRARY     "${GEN_ANDROID_SHARED_LIBRARY}"
      OUTPUT_DIR         "${GEN_ANDROID_OUTPUT_DIR}"
      SOURCE_ASSETS_DIR  "${GEN_ANDROID_SOURCE_ASSETS_DIR}"
      GENERATED_MANIFEST "${GEN_ANDROID_GENERATED_MANIFEST}"
      JAVA_HOME          "${GEN_ANDROID_JAVA_HOME}"
      NDK_ROOT           "${GEN_ANDROID_NDK_ROOT}"
      SDK_ROOT           "${GEN_ANDROID_SDK_ROOT}"
      APP_ID             "${GEN_ANDROID_APP_ID}"
      APP_LABEL          "${GEN_ANDROID_APP_LABEL}"
      ABI                "${GEN_ANDROID_ABI}"
    )
  endfunction()

endif()


# --------------------------------------------------------------------
# Entry point

if(CMAKE_SCRIPT_MODE_FILE)
  _gen_android_build_package_impl()
elseif(NOT DEFINED GEN_ANDROID_BUILD_PACKAGE_SKIP_AUTORUN OR NOT GEN_ANDROID_BUILD_PACKAGE_SKIP_AUTORUN)
  _gen_android_build_package_autorun()
endif()
