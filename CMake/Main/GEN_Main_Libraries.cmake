# --------------------------------------------------------------------
# GEN_Libraries.cmake
# Libraries of GEN 
# --------------------------------------------------------------------



# set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES ${DEFAULT_TARGET_PROPS})


# --------------------------------------------------------------------
# Windows

if(COMPILE_FOR_WINDOWS)  
 
  if(APPFLOW_CONSOLE_FEATURE AND (NOT APPFLOW_GRAPHICS_NOTCONSOLE_FEATURE))    
        
    set_target_properties(${CMAKE_PROJECT_NAME}  PROPERTIES LINK_FLAGS /SUBSYSTEM:CONSOLE)

  else()

    if(GRP_FEATURE)

      set_target_properties(${CMAKE_PROJECT_NAME}  PROPERTIES LINK_FLAGS /SUBSYSTEM:WINDOWS )
      
    endif()

  endif()

  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS wlanapi)
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS bcrypt)

  if(XTRACE_FEATURE OR DIO_FEATURE)    

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS ws2_32) 
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS iphlpapi)           

  endif()


  if(XSYSTEM_FEATURE)          

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS secur32)      
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS powrprof)

  endif()


  if(DIO_STREAMUSB_FEATURE)      

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS setupapi)    

  endif()  

  
  if(DIO_STREAMBLUETOOTH_FEATURE OR DIO_STREAMBLUETOOTHLE_FEATURE)      

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS bthprops)
    
  endif()  


  if(DIO_STREAMTWIFI_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS wlanapi)
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS ole32.lib)

  endif()


  if(DIO_PCAP_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS wpcap)

  endif()


  if(DIO_WINDOWSWFP_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS fwpuclnt)

  endif()


  if(DATABASES_SQL_MYSQL_FEATURE)    

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS libmysql.lib)

  endif()


  if(DATABASES_SQL_POSTGRESQL_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS libpq.lib)

  endif() 


  if(DIO_PCAP_FEATURE)

    if(COMPILE_FOR_WINDOWS_INTEL_32)
    
      target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC ${GEN_DIRECTORY_THIRDPARTYLIBRARIES_NPCAP_WINX32_LIB})

    endif()  

   
    if(COMPILE_FOR_WINDOWS_INTEL_64)
    
      target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC ${GEN_DIRECTORY_THIRDPARTYLIBRARIES_NPCAP_WINX64_LIB})

    endif()  

  endif()  

  
  if(SND_FEATURE)      

    # winmm: ICMP timing (timeBeginPeriod) and OpenAL Soft WASAPI path may need it.
    # avrt: required by OpenAL Soft WASAPI (AvSetMmThreadCharacteristics*).
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS winmm.lib)
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS avrt.lib)

  endif()


  if(GRP_OPENGL_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS synchronization dxgi)

  endif()


endif()


# --------------------------------------------------------------------
# Linux

if(COMPILE_FOR_LINUX)
  
  if((COMPILE_FOR_LINUX_ARM_RPI) OR (COMPILE_FOR_LINUX_ARM_RPI_64))   

    target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC "${RPI_SYSROOT}/lib/arm-linux-gnueabihf"  "${RPI_SYSROOT}/usr/lib/arm-linux-gnueabihf")     

  endif() 
  
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS stdc++)  
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS pthread)  
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS rt)  
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS dl) 
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS m)   
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS atomic)
  
  if(XSYSTEM_FEATURE)  

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS asound)    

  endif()


  if(DIO_STREAMUSB_FEATURE)

   list(APPEND GEN_SO_THIRDPARTY_LIBRARYS udev)  

  endif()


  if(DIO_STREAMBLUETOOTH_FEATURE OR DIO_STREAMBLUETOOTHLE_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS bluetooth)

  endif()  


  if(DIO_STREAMWIFI_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS iw)    

  endif()


  if(DIO_PCAP_FEATURE)   
 
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS pcap)

  endif()


  if(DATABASES_SQL_MYSQL_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS mysqlclient)

  endif()


  if(DATABASES_SQL_POSTGRESQL_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS pq)

  endif() 

  if(GRP_FEATURE)

    if(LINUX_X11_FEATURE)

      # XSync used by GRPLINUXScreenX11 is Xlib (libX11), not libXext.
      # XF86VidMode / Xext APIs are not called by GEN.
      list(APPEND GEN_SO_THIRDPARTY_LIBRARYS X11)
      list(APPEND GEN_SO_THIRDPARTY_LIBRARYS Xrandr)

    endif()

    if(GEN_LINUX_WAYLAND_ACTIVE)

      # wayland-cursor is not used yet (cursor theme restore is comment-only).
      list(APPEND GEN_SO_THIRDPARTY_LIBRARYS wayland-client)
      list(APPEND GEN_SO_THIRDPARTY_LIBRARYS xkbcommon)

      if(GRP_OPENGL_FEATURE)
        list(APPEND GEN_SO_THIRDPARTY_LIBRARYS wayland-egl)
      endif()

    endif()

  endif()


  if(LINUX_DIO_DBUS_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS dbus-1)

  endif()
  
  
  if(GRP_OPENGL_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS GLESv2)
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS EGL)

  endif()


endif()


# ----------------------------------------
# Android
  
if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)   

  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS android)
  list(APPEND GEN_SO_THIRDPARTY_LIBRARYS log)

  if(SND_FEATURE)

    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS OpenSLES)

  endif()

   
  if(GRP_OPENGL_FEATURE)
    
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS GLESv3)
    list(APPEND GEN_SO_THIRDPARTY_LIBRARYS EGL)

  endif()
    
endif()



# ----------------------------------------
# Google Tests

if(GOOGLETEST_FEATURE)

  include(GoogleTest)

  if(GOOGLETEST_EXECFORDISCOVER_FEATURE)

    gtest_discover_tests(${CMAKE_PROJECT_NAME})

  endif()

endif()


include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_LibraryProvisioning.cmake")   


target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC ${GEN_SO_THIRDPARTY_LIBRARYS})

string(REPLACE ";" ", " _GEN_THIRDPARTY_LIBRARYS "${GEN_THIRDPARTY_LIBRARYS}")
string(REPLACE ";" ", " _GEN_SO_THIRDPARTY_LIBRARYS "${GEN_SO_THIRDPARTY_LIBRARYS}")

message(STATUS "[ GEN ThirdParty libraries in source : ${_GEN_THIRDPARTY_LIBRARYS} ]")    
message(STATUS "[ GEN ThirdParty libraries in binary : ${_GEN_SO_THIRDPARTY_LIBRARYS} ]")
