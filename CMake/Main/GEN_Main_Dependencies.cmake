# --------------------------------------------------------------------
# GEN_Main_Dependencies.cmake
# Main: Dependencies 
# --------------------------------------------------------------------


set(CMAKE_CXX_STANDARD 11)

#set(CMAKE_CXX_EXTENSIONS OFF) 

add_definitions(-DUNICODE)


# --------------------------------------------------------------------
# Special

if(ANONYMOUS_MODE_FEATURE)
  
  add_definitions(-DANONYMOUS_MODE)

endif()


# --------------------------------------------------------------------

if(COMPILE_WITH_CLANG AND COMPILE_FOR_LINUX)

  add_definitions(-Dregister=)    # Delete register use

endif()


# --------------------------------------------------------------------
# Platforms General

if(COMPILE_FOR_WINDOWS)
  
  option(XFILE_FEATURE                                          "XFile"                                                   ON )
  option(XTRANSLATION_FEATURE                                   "Translation"                                             ON )     
  
endif()


if(COMPILE_FOR_LINUX)
 
  option(XFILE_FEATURE                                          "XFile"                                                   ON )
  option(XTRANSLATION_FEATURE                                   "Translation"                                             ON )     
  #option(XPROCESSMANAGER_FEATURE                                "Process Manager"                                         ON )    # TO REVISATED 
  
endif()

 
if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)   

  option(XFILE_FEATURE                                          "XFile"                                                   ON )
  option(XTRANSLATION_FEATURE                                   "Translation"                                             ON )

endif()


if(DIO_LEDNEOPIXELWS2812B_FEATURE)

  if(COMPILE_FOR_LINUX_ARM_RPI OR COMPILE_FOR_LINUX_ARM_RPI_64)

    option(DIO_LEDNEOPIXELWS2812B_RPI5_FEATURE                 "Led Neopixel WS2812B Raspberry Pi 5"                      ON )
    option(THIRDPARTYLIBRARIES_RPI5_WS281X_FEATURE             "RPI5 WS281X Library"                                      ON )

  endif()

endif()


if(COMPILE_FOR_STM32)
 
endif()


if(COMPILE_FOR_ESP32)

  option(XSLEEP_FEATURE                                         "Sleep functions"                                         ON )
  option(XSYSTEM_FEATURE                                        "System functions"                                        ON )
  option(XTRANSLATION_FEATURE                                   "Translation"                                             ON ) 

endif()


# --------------------------------------------------------------------
# App Modes


if(APPMODE_SERVICE_FEATURE)

  add_definitions(-DAPPMODE_SERVICE_ACTIVE)  

endif()


if(APPMODE_LIBRARY_DINAMIC_FEATURE)
  
  add_definitions(-DAPPMODE_LIBRARY_DINAMIC_ACTIVE)
  
endif()


if(APPMODE_LIBRARY_STATIC_FEATURE)
  
  add_definitions(-DAPPMODE_LIBRARY_STATIC_ACTIVE)

endif()


# --------------------------------------------------------------------
# Special

if(XTRACE_FEATURE)
 
  if(NOT XTRACE_NOINTERNET_FEATURE)

    option(DIO_FEATURE                                          "Input/Output"                                            ON )
    option(DIO_PUBLICINTERNETIP_FEATURE                         "Public Internet IP"                                      ON )  

  endif()

endif()
 

# --------------------------------------------------------------------
# Application 

if(APPFLOW_FEATURE)

  add_definitions(-DAPPFLOW_ACTIVE)
  
  option(XPUBLISHER_FEATURE                                     "XPublisher"                                              ON )
  option(XSYSTEM_FEATURE                                        "System functions"                                        ON )


  if(APPFLOW_EXTENDED_APPLICATIONHEADER_FEATURE)  

    add_definitions(-DAPPFLOW_EXTENDED_APPLICATIONHEADER_ACTIVE)

  endif()


  if(APPFLOW_EXTENDED_INTERNETSTATUS_FEATURE)
  
    add_definitions(-DAPPFLOW_EXTENDED_INTERNETSTATUS_ACTIVE)    

    option(DIO_FEATURE                                          "Input/Output"                                            ON )
    option(DIO_PUBLICINTERNETIP_FEATURE                         "Public Internet IP"                                      ON )
    option(DIO_WEBSERVER_RESOLVEENDPOINT_FEATURE                "Web Server Resolved End Point"                           ON ) 
    option(APPFLOW_INTERNETSERVICES_FEATURE                     "Application Flow Internet Services"                      ON )  
    option(APPFLOW_CFG_INTERNETSERVICES_FEATURE                 "Application Flow CFG Internet services"                  ON )
    option(APPFLOW_EXTENDED_FEATURE                             "Application Flow Extended"                               ON )  
    
  endif()


  if(APPFLOW_EXTENDED_APPLICATIONSTATUS_FEATURE)
      
    add_definitions(-DAPPFLOW_EXTENDED_APPLICATIONSTATUS_ACTIVE)
    
    option(DIO_WEBSERVER_RESOLVEENDPOINT_FEATURE                "Web Server Resolved End Point"                           ON )
    option(APPFLOW_CHECKRESOURCESHARDWARE_FEATURE               "Application Flow Check Resources Hardware"               ON )  
    option(APPFLOW_CFG_CHECKRESOURCESHARDWARE_FEATURE           "Application Flow CFG Check Resorces HW"                  ON ) 
    option(APPFLOW_EXTENDED_FEATURE                             "Application Flow Extended"                               ON )  
  
        
  endif()
  

  if(APPFLOW_EXTENDED_FEATURE)
     
   add_definitions(-DAPPFLOW_EXTENDED_ACTIVE)
  
   option(DIO_FEATURE                                           "Input/Output"                                            ON )
   option(APPFLOW_LOG_FEATURE                                   "Application Flow Log"                                    ON )  
   option(APPFLOW_CFG_FEATURE                                   "Application Flow CFG"                                    ON ) 
   option(APPFLOW_CFG_LOG_FEATURE                               "Application Flow CFG LOG"                                ON ) 
   
  endif()
              
  
  if(APPFLOW_CHECKRESOURCESHARDWARE_FEATURE)

    add_definitions(-DAPPFLOW_CHECKRESOURCESHARDWARE_ACTIVE)

    option(XSCHEDULER_FEATURE                                   "XScheduler"                                              ON )
    #option(APPFLOW_CFG_INTERNETSERVICES_FEATURE                 "Application Flow CFG Internet services"                  ON )      

  endif()


  if(APPFLOW_INTERNETSERVICES_FEATURE)

    add_definitions(-DAPPFLOW_INTERNETSERVICES_ACTIVE)
    
    option(DIO_FEATURE                                          "Input/Output"                                            ON )
    option(DIO_CHECKCONNECTIONS_FEATURE                         "Check Connections"                                       ON )
    option(DIO_PUBLICINTERNETIP_FEATURE                         "Public Internet IP"                                      ON )
    option(XSCHEDULER_FEATURE                                   "XScheduler"                                              ON )
    
  endif()


  if(APPFLOW_LOG_FEATURE)

    add_definitions(-DAPPFLOW_LOG_ACTIVE)
  
  endif()


  if(APPFLOW_WEBSERVER_FEATURE)

    add_definitions(-DAPPFLOW_WEBSERVER_ACTIVE)
  
  endif()


  if(APPFLOW_UPDATE_FEATURE)

    add_definitions(-DAPPFLOW_UPDATE_ACTIVE)

    option(DIO_APPLICATIONUPDATE_FEATURE                        "Application Update"                                      ON )

  endif()


  if(APPFLOW_ALERTS_FEATURE)

    add_definitions(-DAPPFLOW_ALERTS_ACTIVE)

  endif()
  
  
  if(APPFLOW_GRAPHICS_FEATURE) 

    add_definitions(-DAPPFLOW_GRAPHICS_ACTIVE)

    option(XFSMACHINE_FEATURE                                   "XFSMachine"                                              ON )
    option(GRP_FEATURE                                          "Graphics"                                                ON )
    option(GRP_2D_FEATURE                                       "Graphics 2D"                                             ON )
    option(APPFLOW_CONSOLE_FEATURE                              "Application Flow Console"                                ON ) 
  
  endif()

 
  if(APPFLOW_GRAPHICS_NOTCONSOLE_FEATURE)

    add_definitions(-DAPPFLOW_GRAPHICS_NOTCONSOLE_ACTIVE)

  endif()


  if(APPFLOW_CONSOLE_FEATURE)
    
    add_definitions(-DAPPFLOW_CONSOLE_ACTIVE) 
    option(XCONSOLE_FEATURE                                     "Console functions"                                       ON )
  
  endif()


endif()


if(APPFLOW_GRAPHICS_FEATURE)    
  
  if(APPFLOW_GRAPHICS_NOTCONSOLE_FEATURE)
      
      message(STATUS "[ GEN APP Graphics Mode ]")
      
    else()

      message(STATUS "[ GEN APP Console + Graphics Mode ]")
  
  endif()

else()

  if(APPFLOW_GRAPHICS_FEATURE)    

    message(STATUS "[ GEN APP Console Mode ]")

  endif()

endif()


# --------------------------------------------------------------------
# Application CFG

if(APPFLOW_CFG_REMOTEFILE_FEATURE               OR
   APPFLOW_CFG_GENERAL_FEATURE                  OR 
   APPFLOW_CFG_LOG_FEATURE                      OR
   APPFLOW_CFG_INTERNETSERVICES_FEATURE         OR 
   APPFLOW_CFG_DYNDNSMANAGER_FEATURE            OR
   APPFLOW_CFG_WEBSERVER_FEATURE                OR
   APPFLOW_CFG_CHECKRESOURCESHARDWARE_FEATURE   OR
   APPFLOW_CFG_DIOLOCATION_FEATURE              OR
   APPFLOW_CFG_DNSRESOLVER_FEATURE              OR
   APPFLOW_CFG_ALERTS_FEATURE                   OR
   APPFLOW_CFG_APPUPDATE_FEATURE)
 

  add_definitions(-DAPPFLOW_CFG_ACTIVE)

  option(APPFLOW_CFG_FEATURE                                      "Application CFG"                                         ON ) 


  if(APPFLOW_CFG_SCRIPTS_FEATURE)

    add_definitions(-DAPPFLOW_CFG_SCRIPTS_ACTIVE)
    
  endif()

 
  if(APPFLOW_CFG_LOG_FEATURE)

    add_definitions(-DAPPFLOW_CFG_LOG_ACTIVE) 
  
    option(XLOG_FEATURE                                           "LOG File"                                                ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_REMOTEFILE_FEATURE)  
  
    add_definitions(-DAPPFLOW_CFG_REMOTEFILE_ACTIVE)  
  
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_GENERAL_FEATURE) 
  
    add_definitions(-DAPPFLOW_CFG_GENERAL_ACTIVE) 
  
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )

  endif()


  if(APPFLOW_CFG_LOG_FEATURE)

    add_definitions(-DAPPFLOW_CFG_LOG_ACTIVE)  

    option(APPFLOW_LOG_FEATURE                                    "Application Flow Log"                                    ON )
    option(XLOG_FEATURE                                           "LOG File"                                                ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_INTERNETSERVICES_FEATURE)  
  
    add_definitions(-DAPPFLOW_CFG_INTERNETSERVICES_ACTIVE)  
  
    option(HASH_FEATURE                                           "Hash"                                                    ON )
    option(APPFLOW_INTERNETSERVICES_FEATURE                       "Application Flow Internet Services"                      ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
    option(DIO_CHECKCONNECTIONS_FEATURE                           "Check Connections"                                       ON )
    option(DIO_NETWORKTIMEPROTOCOL_FEATURE                        "Network Time Protocol"                                   ON )
    
 
  endif()


  if(APPFLOW_CFG_DYNDNSMANAGER_FEATURE)

    add_definitions(-DAPPFLOW_CFG_DYNDNSMANAGER_ACTIVE)

  endif()


  if(APPFLOW_CFG_WEBSERVER_FEATURE)

    add_definitions(-DAPPFLOW_CFG_WEBSERVER_ACTIVE)

    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_CHECKRESOURCESHARDWARE_FEATURE)  
  
    add_definitions(-DAPPFLOW_CFG_CHECKRESOURCESHARDWARE_ACTIVE)  
  
    option(APPFLOW_CHECKRESOURCESHARDWARE_FEATURE                 "Application Flow Check Resources Hardware"               ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_DIOLOCATION_FEATURE) 
  
    add_definitions(-DAPPFLOW_CFG_DIOLOCATION_ACTIVE) 
  
    option(DIO_LOCATION_FEATURE                                   "Location API"                                            ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_DNSRESOLVER_FEATURE) 
  
    add_definitions(-DAPPFLOW_CFG_DNSRESOLVER_ACTIVE) 
  
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_ALERTS_FEATURE)  
  
    add_definitions(-DAPPFLOW_CFG_ALERTS_ACTIVE)  
  
    option(APPFLOW_ALERTS_FEATURE                                 "Application Flow Alerts"                                 ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )
  
  endif() 
  
  
  if(APPFLOW_CFG_APPUPDATE_FEATURE) 
  
    add_definitions(-DAPPFLOW_CFG_APPUPDATE_ACTIVE) 
  
    option(APPFLOW_UPDATE_FEATURE                                 "Application Flow Update"                                 ON )
    option(XFILE_CFG_FEATURE                                      "XFile Config format"                                     ON )

  endif()
  
endif()


# --------------------------------------------------------------------
# User Interface

if(USERINTERFACE_FEATURE)

  add_definitions("-DUSERINTERFACE_ACTIVE")

  if(USERINTERFACE_DEBUG_FEATURE)

    add_definitions("-DUSERINTERFACE_DEBUG")
  
  endif()

  option(XPUBLISHER_FEATURE                                       "XPublisher"                                              ON )
  option(XFSMACHINE_FEATURE                                       "XFSMachine"                                              ON )
  option(XFILE_XML_FEATURE                                        "XFile XML format"                                        ON )
  option(XFILE_ZIP_FEATURE                                        "XFile Zip format"                                        ON )  
  
  option(GRP_FEATURE                                              "Graphics"                                                ON )  
  option(GRP_BITMAP_FILE_FEATURE                                  "Graphics Bitmap Files"                                   ON )
  option(GRP_BITMAP_FILE_BMP_FEATURE                              "Graphics Bitmap File BMP"                                ON )
  option(GRP_BITMAP_FILE_JPG_FEATURE                              "Graphics Bitmap File JPG"                                ON )
  option(GRP_BITMAP_FILE_PNG_FEATURE                              "Graphics Bitmap File PNG"                                ON )
  option(GRP_BITMAP_FILE_TGA_FEATURE                              "Graphics Bitmap File TGA"                                ON )
  option(GRP_VECTOR_FILE_FEATURE                                  "Graphics Vector File"                                    ON )       
  option(GRP_VECTOR_FILE_DXF_FEATURE                              "Graphics Vector File DXF"                                ON )   
  option(GRP_VECTOR_FILE_SVG_FEATURE                              "Graphics Vector File SVG"                                ON )   
 
endif()


# --------------------------------------------------------------------
# Scripts

if(SCRIPT_FEATURE)
  
  add_definitions("-DSCRIPT_ACTIVE")

  option(XPUBLISHER_FEATURE                                       "XPublisher"                                              ON )
  option(XFSMACHINE_FEATURE                                       "XFSMachine"                                              ON )
  option(XCONSOLE_FEATURE                                         "Console functions"                                       ON ) 
  option(XPROCESSMANAGER_FEATURE                                  "Process Manager"                                         ON )


  if(SCRIPT_CACHE_FEATURE)

    add_definitions(-DSCRIPT_CACHE_ACTIVE) 
    
  endif()


  if(SCRIPT_LIB_SYSTEM_FEATURE)

    add_definitions("-DSCRIPT_LIB_SYSTEM_ACTIVE")
    
  endif()


  if(SCRIPT_LIB_PROCESS_FEATURE)

    add_definitions("-DSCRIPT_LIB_PROCESS_ACTIVE")
    
  endif()

  
  if(SCRIPT_LIB_LOG_FEATURE)

    add_definitions("-DSCRIPT_LIB_LOG_ACTIVE")
    
  endif()


  if(SCRIPT_LIB_CONSOLE_FEATURE)

    add_definitions("-DSCRIPT_LIB_CONSOLE_ACTIVE")
    
  endif()


  if(SCRIPT_LIB_WINDOW_FEATURE)

    add_definitions("-DSCRIPT_LIB_WINDOW_ACTIVE")

    option(GRP_FEATURE                                            "Graphics"                                                ON )
    option(GRP_2D_FEATURE                                         "Activate Graphics 2D"                                    ON )
    option(GRP_BITMAP_FILE_FEATURE                                "Graphics Files Bitmap Type"                              ON )

    option(APPFLOW_GRAPHICS_FEATURE                               "Application Flow Graphics"                               ON ) 
    
  endif()


  if(SCRIPT_LIB_CFG_FEATURE)

    add_definitions("-DSCRIPT_LIB_CFG_ACTIVE")
    
  endif()


  if(SCRIPT_LIB_INPUTSIMULATE_FEATURE)

    add_definitions("-DSCRIPT_LIB_INPUTSIMULATE_ACTIVE")

    option(INP_FEATURE                                            "Inputs"                                                  ON )
    option(INP_SIMULATE_FEATURE                                   "Inputs Simulate"                                         ON ) 
    
  endif()
  
  
  if(SCRIPT_LIB_DEVTEST_FEATURE)

    add_definitions("-DSCRIPT_LIB_DEVTEST_ACTIVE")
    
  endif()


  if(SCRIPT_G_FEATURE)

    add_definitions("-DSCRIPT_G_ACTIVE")
    
  endif()


  if(SCRIPT_LUA_FEATURE)

    add_definitions("-DSCRIPT_LUA_ACTIVE")
    
  endif()


  if(SCRIPT_JAVASCRIPT_FEATURE)

    add_definitions("-DSCRIPT_JAVASCRIPT_ACTIVE")
    
  endif()


endif()


# --------------------------------------------------------------------
# Databases

if(DATABASES_SQL_FEATURE)  

  add_definitions(-DDB_SQL_ACTIVE)

  option(XPUBLISHER_FEATURE                                       "XPublisher"                                              ON )
  option(XFSMACHINE_FEATURE                                       "XFSMachine"                                              ON )

  if(DATABASES_SQL_SQLITE_FEATURE)

    add_definitions(-DDB_SQLITE_ACTIVE)

    option(DATABASES_SQL                                          "DataBases SQL"                                           ON )

  endif()


  if(DATABASES_SQL_MYSQL_FEATURE)

    add_definitions(-DDB_MYSQL_ACTIVE)

    option(DATABASES_SQL                                          "DataBases SQL"                                           ON )

  endif()


  if(DATABASES_SQL_POSTGRESQL_FEATURE)

    add_definitions(-DDB_POSTGRESQL_ACTIVE)

    option(DATABASES_SQL                                          "DataBases SQL"                                           ON )

  endif()

endif()




# --------------------------------------------------------------------
# Input 

if(INP_SIMULATE_FEATURE)

  add_definitions(-DINP_SIMULATE_ACTIVE)

  option(INP_FEATURE                                              "Inputs"                                                  ON )

endif()


if(INP_CAPTURE_FEATURE)

  add_definitions(-DINP_CAPTURE_ACTIVE)
  option(INP_FEATURE                                              "Inputs"                                                  ON )
  
endif()


if(INP_FEATURE)

  add_definitions(-DINP_ACTIVE)

  option(GRP_FEATURE                                              "Graphics"                                                ON )
  option(GRP_2D_FEATURE                                           "Activate Graphics 2D"                                    ON )  

endif()



# --------------------------------------------------------------------
# Graphics 


if(GRP_2D_FEATURE)

  option(GRP_FEATURE                                              "Graphics"                                                ON )

endif()  


if(GRP_FEATURE)

  add_definitions(-DGRP_ACTIVE)

  add_definitions(-DFT_DEBUG_LEVEL_ERROR)
  add_definitions(-DFT_DEBUG_LEVEL_TRACE)
  add_definitions(-DFT2_BUILD_LIBRARY)
  
  option(GRP_DESKTOPMANAGER_FEATURE                               "Graphics Desktop Manager"                                ON )

  if(GRP_DESKTOPMANAGER_FEATURE)

    add_definitions(-DGRP_DESKTOPMANAGER_ACTIVE)

  endif()


  if(GRP_SCREEN_CUSTOMCHROMES_FEATURE)

    add_definitions(-DGRP_SCREEN_CUSTOMCHROMES_ACTIVE)

    option(USERINTERFACE_FEATURE                                  "User Interace"                                           ON )
    option(GRP_VECTOR_FILE_SVG_FEATURE                            "Graphics Vector File SVG"                                ON )

  endif()


  if(GRP_STATISTICSCHARS_FEATURE)

    add_definitions(-DGRP_STATISTICSCHARS_ACTIVE)

    option(GRP_VECTOR_FILE_SVG_FEATURE                            "Graphics Vector File SVG"                                ON )

  endif()


  if(GRP_BITMAP_FILE_BMP_FEATURE)    
    
    add_definitions(-DGRP_BITMAP_FILE_BMP_ACTIVE)    

    option(GRP_BITMAP_FILE_FEATURE                                "Graphics Bitmap File"                                    ON )
    
  endif()


  if(GRP_BITMAP_FILE_JPG_FEATURE)    
    
    add_definitions(-DGRP_BITMAP_FILE_JPG_ACTIVE)    

    option(GRP_BITMAP_FILE_FEATURE                                "Graphics Bitmap File"                                    ON )
    
  endif()
  

  if(GRP_BITMAP_FILE_PNG_FEATURE)    
    
    add_definitions(-DGRP_BITMAP_FILE_PNG_ACTIVE)    

    option(GRP_BITMAP_FILE_FEATURE                                "Graphics Bitmap File"                                    ON )
    
  endif()


  if(GRP_BITMAP_FILE_TGA_FEATURE)    
    
    add_definitions(-DGRP_BITMAP_FILE_TGA_ACTIVE)    

    option(GRP_BITMAP_FILE_FEATURE                                "Graphics Bitmap File"                                    ON )
    
  endif()


  if(GRP_VECTOR_FILE_DXF_FEATURE)

    add_definitions(-DGRP_VECTOR_FILE_DXF_ACTIVE)
  
    option(XFILE_TXT_FEATURE                                      "Activate XFile Text format"                              ON )
    option(GRP_VECTOR_FILE_FEATURE                                "Graphics Vector File"                                    ON )

  endif()


  if(GRP_VECTOR_FILE_SVG_FEATURE)

    add_definitions(-DGRP_VECTOR_FILE_SVG_ACTIVE)

    option(XFILE_XML_FEATURE                                      "XFile XML format"                                        ON )
    option(GRP_VECTOR_FILE_FEATURE                                "Graphics Vector File"                                    ON )

  endif()


  if(GRP_VECTOR_FILE_FEATURE)

    add_definitions(-DGRP_VECTOR_FILE_ACTIVE)
 
    option(XFILE_FEATURE                                          "Activate XFile"                                          ON )   

  endif()

   
  if(GRP_VIDEO_FILE_AVI_FEATURE)

    add_definitions(-DGRP_VIDEO_FILE_AVI_ACTIVE)

    option(GRP_VIDEO_FILE_FEATURE                                 "Graphics Video File"                                     ON )
    option(XFILE_RIFF_FEATURE                                     "XFile RIFF format"                                       ON )

  endif()


  if(GRP_VIDEO_FILE_FEATURE)
  
    add_definitions(-DGRP_VIDEO_FILE_ACTIVE)

  endif()


  if(GRP_OPENGL_FEATURE)

    add_definitions(-DGRP_OPENGL_ACTIVE)
    add_definitions(-DGRP_OPENGL_ES_ACTIVE)
    add_definitions(-DGRP_OPENGL_ES_VERSION=30)
    
   
    if(COMPILE_FOR_WINDOWS)

      option(THIRDPARTYLIBRARIES_ANGLE_FEATURE                        "Angle OpenGL ES Library (Windows only)"                  ON )
    
    endif()
    
  endif()


endif()


# --------------------------------------------------------------------
# Sound 

if(SND_FEATURE)

  add_definitions(-DSND_ACTIVE)

  add_definitions(-DAL_LIBTYPE_STATIC)

  if(SND_FILE_OGG_FEATURE)

    add_definitions(-DSND_FILE_OGG_ACTIVE)

  endif()

  if(SND_FILE_WAV_FEATURE)

    add_definitions(-DSND_FILE_WAV_ACTIVE)
    
    option(XFILE_RIFF_FEATURE                                     "XFile RIFF format"                                       ON )

  endif()

endif()


# --------------------------------------------------------------------
# Data Input/Output     

if(DIO_FEATURE)

  add_definitions(-DDIO_ACTIVE)

  option(DIO_DNSRESOLVER_FEATURE                                  "DNS Resolver"                                            ON )
  option(DIO_NOTIFICATIONS_MANAGER_FEATURE                        "Notifications Manager"                                   ON )
  option(DIO_WINDOWSWFP_FEATURE                                   "Windows Filtering Platform"                              OFF)
  
  
  if(DIO_APPLICATIONUPDATE_FEATURE) 
    
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
  
  endif() 
  
  
  if(DIO_WEBSERVER_FEATURE) 
  
    option(DIO_WEBSERVER_RESOLVEENDPOINT_FEATURE                  "Web Server Resolved End Point"                           ON )
    
  endif() 
  
  
  if(DIO_WEBSERVER_RESOLVEENDPOINT_FEATURE) 
  
    option(XSERIALIZABLE_JSON_FEATURE                             "Serializable JSON"                                       ON )
  
  
  endif() 
  
  
  if(DIO_PUBLICINTERNETIP_FEATURE)  
  
    add_definitions(-DDIO_PUBLICINTERNETIP_ACTIVE)  
  
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
    option(DIO_PING_FEATURE                                       "Ping"                                                    ON )   
    option(DIO_STREAMTLS_FEATURE                                  "Data Input/Output Stream TLS"                            ON )    
    
  endif() 
    
  
  if(DIO_WAKEONLAN_FEATURE) 
  
    add_definitions(-DDIO_WAKEONLAN_ACTIVE) 
  
    option(DIO_STREAMUDP_FEATURE                                  "Stream UDP"                                              ON )
  
  endif() 
  
  
  if(DIO_PING_NATIVE_FEATURE)  
  
    add_definitions(-DDIOPING_NATIVE_ACTIVE)  
  
  endif() 
  
  
  if(DIO_MPSSE_FEATURE) 
  
    add_definitions(-DDIO_MPSSE_ACTIVE) 
  
    option(DIO_STREAMUSB_FEATURE                                  "Stream USB"                                              ON )
  
  endif() 
  
  
  if(DIO_DNSPROTOCOL_MITM_SERVER) 
          
    option(DIO_STREAMUDP_FEATURE                                  "Stream UDP"                                              ON )   
    option(DIO_DNSRESOLVER_FEATURE                                "DNS Resolver"                                            ON )
  
  endif() 
  
  
  if(DIO_DNSRESOLVER_FEATURE) 
  
    add_definitions(-DDIO_DNSRESOLVER_ACTIVE) 
  
    option(DIO_STREAMUDP_FEATURE                                  "Stream UDP"                                              ON )

  endif()


  if(DIO_WINDOWSWFP_FEATURE)

    add_definitions(-DDIO_WINDOWSWFP_ACTIVE)

  endif()


  if(DIO_CHECKCONNECTIONS_FEATURE) 

    add_definitions(-DDIO_CHECKCONNECTIONS_ACTIVE)
    option(DIO_PING_FEATURE "Ping" ON )

  endif()


  if(DIO_NETWORKTIMEPROTOCOL_FEATURE)

    add_definitions(-DDIO_NETWORKTINEPROTOCOL_ACTIVE)

    option(DIO_STREAMUDP_FEATURE                                  "UDP"                                                     ON )
  
  endif() 
  
  
  if(DIO_DYNDNS_FEATURE)  
  
    add_definitions(-DDIO_DYNDNS_ACTIVE)  
  
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
    option(DIO_PUBLICINTERNETIP_FEATURE                           "Public Internet IP"                                      ON )
  
  endif() 
  
  
  if(DIO_WIFIMANAGERMODE_FEATURE) 
  
    add_definitions(-DDIO_WIFIMANAGERMODE_ACTIVE) 
  
    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )
    
  endif()


  if(DIO_NOTIFICATIONS_MANAGER_FEATURE)

    add_definitions(-DDIO_NOTIFICATIONS_MANAGER_ACTIVE)
    
  endif()


  if(DIO_PING_FEATURE)

    add_definitions(-DDIO_PING_ACTIVE)

    option(DIO_STREAMICMP_FEATURE                                 "ICMP"                                                    ON ) 
  
  endif() 
  
  
  if(DIO_COREPROTOCOL_FEATURE)  
  
    add_definitions(-DDIO_COREPROTOCOL_ACTIVE)  
    option(HASH_CRC32_FEATURE                                     "Hash CRC32"                                              ON )
    option(XUUID_FEATURE                                          "UUID functions"                                          ON )
    option(CIPHER_SYMMETRIC_AES_FEATURE                           "Cipher Symetric AES"                                     ON )
    option(CIPHER_ASYMMETRIC_X25519_FEATURE                       "Cipher Asimetric ECDSA X25519"                           ON ) 
  
  endif() 
    
    
  if(DIO_PROTOCOL_FEATURE)  
  
    add_definitions(-DDIO_PROTOCOL_ACTIVE)  
    option(DIO_STREAMCIPHER_FEATURE                               "Stream Cipher"                                           ON )
    option(DIO_STREAMUDP_FEATURE                                  "Stream UDP"                                              ON )
    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )
    option(CIPHER_SYMMETRIC_AES_FEATURE                           "Cipher Symetric AES"                                     ON )
  
   endif()  
  
  
  if(DIO_PROTOCOL_CLI_BUS_FEATURE)  
  
    add_definitions(-DDIO_PROTOCOL_CLI_BUS_ACTIVE)  
    option(DIO_PROTOCOL_CLI_FEATURE                               "Protocol in CLI"                                         ON )

  endif()


  if(DIO_PROTOCOL_CLI_FEATURE)

    add_definitions(-DDIO_PROTOCOL_CLI_ACTIVE)

    option(DIO_STREAMCIPHER_FEATURE                               "Stream Cipher"                                           ON )   
    option(DIO_STREAMUART_FEATURE                                 "Stream UART"                                             ON )
    option(DIO_STREAMUSB_FEATURE                                  "Stream USB"                                              ON )
    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )
    option(CIPHER_SYMMETRIC_AES_FEATURE                           "Cipher Symetric AES"                                     ON )
  
  endif() 
  
  
  if(DIO_STREAMCIPHER_FEATURE)  
  
    add_definitions(-DDIO_STREAMCIPHER_ACTIVE)  
  
    option(HASH_FEATURE                                           "Hash"                                                    ON )
    option(CIPHER_SYMMETRIC_FEATURE                               "Cipher Symetric"                                         ON )
  
  endif() 
  
  
  if(DIO_ALERTS_FEATURE)  
  
    add_definitions(-DDIO_ALERTS_ACTIVE)  
  
    option(DIO_ATCMD_FEATURE                                      "AT Commands"                                             ON )
    option(DIO_SMTP_FEATURE                                       "SMTP (email)"                                            ON ) 
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
    option(DIO_STREAMUDP_FEATURE                                  "Stream UDP"                                              ON )

  endif()


  if(DIO_SMTP_FEATURE)

    add_definitions(-DDIO_SMTP_ACTIVE)

    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )

  endif()


  if(DIO_SNMP_FEATURE)

    add_definitions(-DDIO_SNMP_ACTIVE)

  endif()


  if(DIO_ATCMD_FEATURE)

    add_definitions(-DDIO_ATCMD_ACTIVE)

    option(DIO_STREAMUART_FEATURE                                 "Stream UART"                                             ON )

  endif()


  if(DIO_NODEMANAGER_FEATURE)    

    add_definitions(-DDIO_NODEMANAGER_ACTIVE)

    option(DIO_NODES_FEATURE                                      "Nodes modules"                                           ON )    

  endif()


  if(DIO_NODEITEMHANDLER_SENSORAM2315_FEATURE)    

    add_definitions(-DDIO_NODEITEMHANDLER_SENSORAM2315_ACTIVE)

    option(DIO_STREAM_FEATURE                                     "Stream"                                                  ON )
    option(DIO_STREAMI2C_FEATURE                                  "Stream I2C"                                              ON ) 
    option(DIO_STREAMI2C_TEMHUMSENSOR_AM2315_FEATURE              "I2C Temperature Humidity Sensor AM2315"                  ON ) 
    option(DIO_NODES_FEATURE                                      "Nodes modules"                                           ON )
  
  endif() 
  
  
  if(DIO_NODEITEMHANDLER_GPIODIGITAL_FEATURE) 
  
    add_definitions(-DDIO_NODEITEMHANDLER_GPIODIGITAL_ACTIVE) 
  
    option(DIO_NODES_FEATURE                                      "Nodes modules"                                           ON )   
  
  endif() 
  
  
  if(DIO_NODES_FEATURE)     
  
    add_definitions(-DDIO_NODES_ACTIVE) 
  
    option(XUUID_FEATURE                                          "UUID functions"                                          ON )     

  endif()


  if(DIO_MODBUSCLIENT_FEATURE)

    add_definitions(-DDIO_MODBUSCLIENT_ACTIVE)
  
  endif()


  if(DIO_LEDNEOPIXELWS2812B_FEATURE)

    add_definitions(-DDIO_LEDNEOPIXELWS2812B_ACTIVE)
    
  endif()


  if(DIO_IEC60870_5_FEATURE)

    add_definitions(-DDIO_IEC60870_5_ACTIVE) 

    option(DIO_STREAMUART_FEATURE                                 "Stream UART"                                             ON )
    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )
    
  endif() 
  
  
  if(DIO_OBEXPUSH_FEATURE)  
  
    add_definitions(-DDIO_OBEXPUSH_ACTIVE)  
  
    option(DIO_STREAMUART_FEATURE                                 "Stream UART"                                             ON )
      
  endif()


  if(DIO_PCAP_FEATURE)

    add_definitions(-DDIO_PCAP_ACTIVE)

  endif()


  if(DIO_GPIO_FEATURE)

    add_definitions(-DDIO_GPIO_ACTIVE)

    if(DIO_GPIO_PCPARALLEL_FEATURE)

      add_definitions(-DDIO_GPIO_PCPARALLEL_ACTIVE)
  
    endif()

  endif()
  
  
  if(DIO_OSPIPELINE_FEATURE)  

    add_definitions(-DDIO_OSPIPELINE_ACTIVE)  

  endif()


  if(DIO_WEBCLIENT_FEATURE)

    add_definitions(-DDIO_WEBCLIENT_ACTIVE)

    option(DIO_STREAMTCPIP_FEATURE                                "TCPIP"                                                   ON )
    option(HASH_MD5_FEATURE                                       "Hash MD5"                                                ON )
    option(COMPRESS_GZ_FEATURE                                    "Compres GZ"                                              ON )
    option(COMPRESS_DEFLATE_FEATURE                               "Compress Deflate (raw/zlib) for HTTP Content-Encoding"   ON )

  endif()
  
  
  if(DIO_WEBSERVER_FEATURE)   
  
    add_definitions(-DDIO_WEBSERVER_ACTIVE) 
  
    option(DIO_STREAMTCPIP_FEATURE                                "TCPIP"                                                   ON )
    option(HASH_FEATURE                                           "Hash"                                                    ON )
    option(HASH_SHA1_FEATURE                                      "Hash SHA1"                                               ON )
    option(XPROCESSMANAGER_FEATURE                                "Process Manager"                                         ON )
      
  endif() 
  
  
  if(DIO_SCRAPERWEB_FEATURE)  
  
    add_definitions(-DDIO_SCRAPERWEB_ACTIVE)  
  
    option(XFILE_XML_FEATURE                                      "XFile XML format"                                        ON )
    option(XFILE_JSON_FEATURE                                     "XFile JSON format"                                       ON )
    option(DIO_WEBCLIENT_FEATURE                                  "Web Client"                                              ON )
  
  endif() 
  
  option(DIO_STREAMTLS12_FEATURE                                "TLS 1.2 (RFC 5246)"                                      ON )

  if(DIO_STREAMTLS_FEATURE OR DIO_STREAMTLS12_FEATURE) 
  
    add_definitions(-DDIO_STREAMTLS_ACTIVE) 
  
    option(DIO_STREAMTCPIP_FEATURE                                "TCPIP"                                                   ON )

    option(HASH_SHA2_FEATURE                                      "Hash SHA2"                                               ON )
    option(HASH_HMAC_FEATURE                                      "Hash HMAC"                                               ON )
    option(CIPHER_SYMMETRIC_AES_FEATURE                           "Cipher Symetric AES"                                     ON )
    option(CIPHER_SYMMETRIC_AESGCM_FEATURE                        "Cipher Symetric AES GCM"                                 ON )
    option(CIPHER_SYMMETRIC_CHACHA20POLY1305_FEATURE              "Cipher Symetric ChaCha20-Poly1305"                       ON )
    option(CIPHER_SYMMETRIC_DES_FEATURE                           "Cipher Symetric DES/3DES (PKCS#12 legacy)"                ON )
    option(CIPHER_HKDF_FEATURE                                    "Cipher HKDF"                                             ON )
    option(CIPHER_ASYMMETRIC_RSA_FEATURE                          "Cipher Asimetric RSA"                                    ON )
    option(CIPHER_ASYMMETRIC_ED25519_FEATURE                      "Cipher Asimetric Ed25519"                                ON )
    option(CIPHER_ASYMMETRIC_MLKEM768_FEATURE                     "Cipher Asimetric ML-KEM-768"                             ON )
    option(CIPHER_ASYMMETRIC_MLKEM1024_FEATURE                    "Cipher Asimetric ML-KEM-1024"                            ON )
    option(CIPHER_ASYMMETRIC_X25519_FEATURE                       "Cipher Asimetric ECDSA X25519"                           ON )
    option(XASN1_FEATURE                                          "ASN.1 functions"                                         ON )
    option(XFILE_TXT_FEATURE                                      "XFile Text format"                                       ON )

    option(HASH_FEATURE                                           "Hash"                                                    ON )
    option(CIPHER_SYMMETRIC_FEATURE                               "Cipher Symetric"                                         ON )
    option(CIPHER_ASYMMETRIC_FEATURE                              "Cipher Asymetric"                                        ON )

  endif()


  if(DIO_STREAMTLS12_FEATURE)

    add_definitions(-DDIO_STREAMTLS12_ACTIVE)

  endif()
  
  
  if(DIO_COREPROTOCOL_FEATURE)  
  
    option(COMPRESS_GZ_FEATURE                                    "Compres GZ"                                              ON )
  
  endif() 
  
  
  if(DIO_STREAMTLS_FEATURE) 
      
    option(DIO_STREAMTCPIP_FEATURE                                "Stream TCPIP"                                            ON )
  
  endif() 
  
  
  if(DIO_STREAMUART_FEATURE         OR  
     DIO_STREAMUSB_FEATURE          OR  
     DIO_STREAMICMP_FEATURE         OR  
     DIO_STREAMUDP_FEATURE          OR  
     DIO_STREAMCPIP_FEATURE         OR  
     DIO_STREAMBLUETOOTH_FEATURE    OR  
     DIO_STREAMBLUETOOTHLE_FEATURE  OR  
     DIO_STREAMSPI_FEATURE          OR  
     DIO_STREAMI2C_FEATURE) 
  
  
    option(DIO_STREAM_FEATURE                                     "Stream"                                                  ON )
    option(XSLEEP_FEATURE                                         "Sleep functions"                                         ON )
    option(XPUBLISHER_FEATURE                                     "XPublisher"                                              ON )
    option(XFSMACHINE_FEATURE                                     "XFSMachine"                                              ON )
  
    if(LINUX_DIO_NETWORKMANAGER_FEATURE)  
      
      add_definitions(-DLINUX_DIO_NETWORKMANAGER_ACTIVE)  
        
      option(LINUX_DIO_DBUS_FEATURE                               "Linux DBus"                                              ON )
        
    endif() 
      
  
    if(LINUX_DIO_DBUS_FEATURE)  
      
      add_definitions(-DLINUX_DIO_DBUS_ACTIVE)  
      
    endif() 
      
  
    if(DIO_STREAMUART_FEATURE)  
  
      add_definitions(-DDIO_STREAMUART_ACTIVE)  
  
    endif() 
  
  
    if(DIO_STREAMUSB_FEATURE) 
  
      add_definitions(-DDIO_STREAMUSB_ACTIVE) 
  
    endif() 
  
  
    if(DIO_STREAMBLUETOOTH_FEATURE) 
  
      add_definitions(-DDIO_STREAMBLUETOOTH_ACTIVE)   
  
      option(XUUID_FEATURE                                        "UUID functions"                                          ON )

    endif()


    if(DIO_STREAMBLUETOOTHLE_FEATURE)

      add_definitions(-DDIO_STREAMBLUETOOTHLE_ACTIVE)

    endif()


    if(DIO_STREAMI2C_FEATURE)

      add_definitions(-DDIO_STREAMI2C_ACTIVE)  


      if(DIO_STREAMI2C_6AXISTRACKING_LSM303DLHC_FEATURE)

        add_definitions(-DDIO_STREAMI2C_6AXISTRACKING_LSM303DLHC_ACTIVE)  
  
      endif()


      if(DIO_STREAMI2C_6AXISTRACKING_BMI270_FEATURE)

        add_definitions(-DDIO_STREAMI2C_6AXISTRACKING_BMI270_ACTIVE)  
  
      endif()


      if(DIO_STREAMI2C_9AXISTRACKING_MPU9150_FEATURE)

        add_definitions(-DDIO_STREAMI2C_9AXISTRACKING_MPU9150_ACTIVE)  
  
      endif()


      if(DIO_STREAMI2C_ADDACONVERTER_PCF8591_FEATURE)

        add_definitions(-DDIO_STREAMI2C_ADDACONVERTER_PCF8591_ACTIVE)  
  
      endif()


      if(DIO_STREAMI2C_AIRQUALITY_CCS811_FEATURE)

        add_definitions(-DDIO_STREAMI2C_AIRQUALITY_CCS811_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_EEPROM_24XXX_FEATURE)

        add_definitions(-DDIO_STREAMI2C_EEPROM_24XXX_ACTIVE)    
  
      endif()


      if(DIO_STREAMI2C_GPIO_MCP2317_FEATURE)

        add_definitions(-DDIO_STREAMI2C_GPIO_MCP2317_ACTIVE)    
  
      endif()


      if(DIO_STREAMI2C_GPIO_PCF8574_FEATURE)

        add_definitions(-DDIO_STREAMI2C_GPIO_PCF8574_ACTIVE)    
  
      endif()


      if(DIO_STREAMI2C_LIGHTSENSOR_TSL2561_FEATURE)

        add_definitions(-DDIO_STREAMI2C_LIGHTSENSOR_TSL2561_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_OLEDDISPLAY_SSD1306_FEATURE)

        add_definitions(-DDIO_STREAMI2C_OLEDDISPLAY_SSD1306_ACTIVE)    

        option(DIO_DISPLAYDEVICE_FEATURE                        "Display Device"                                            ON )

      endif()


      if(DIO_STREAMI2C_PWMCONTROLER_PCA9685_FEATURE)

        add_definitions(-DDIO_STREAMI2C_PWMCONTROLER_PCA9685_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_TEMHUMSENSOR_AM2315_FEATURE)

        add_definitions(-DDIO_STREAMI2C_TEMHUMSENSOR_AM2315_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_TEMHUMSENSOR_SHT20_FEATURE)

        add_definitions(-DDIO_STREAMI2C_TEMHUMSENSOR_SHT20_ACTIVE)    
  
      endif()


      if(DIO_STREAMI2C_MONITORGAUGE_LTC2942_FEATURE)

        add_definitions(-DDIO_STREAMI2C_MONITORGAUGE_LTC2942_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_BATTERYCHARGER_BQ24295_FEATURE)

        add_definitions(-DDIO_STREAMI2C_BATTERYCHARGER_BQ24295_ACTIVE)    

      endif()


      if(DIO_STREAMI2C_TOUCHSENSOR_AT42QT1060_FEATURE)

        add_definitions(-DDIO_STREAMI2C_TOUCHSENSOR_AT42QT1060_ACTIVE)    
  
      endif()
  
    endif()


    if(DIO_STREAMSPI_FEATURE)

      add_definitions(-DDIO_STREAMSPI_ACTIVE)
   

      if(DIO_STREAMSPI_GPIO_MCP23S17_FEATURE)
  
        add_definitions(-DDIO_STREAMSPI_GPIO_MCP23S17_ACTIVE)    

      endif()


      if(DIO_STREAMSPI_LCDDISPLAY_PCF8833_FEATURE)

        add_definitions(-DDIO_STREAMSPI_LCDDISPLAY_PCF8833_ACTIVE)    

        option(DIO_DISPLAYDEVICE_FEATURE                          "Display Device"                                          ON )

      endif()


      if(DIO_STREAMSPI_OLEDDISPLAY_SSD1306_FEATURE)

        add_definitions(-DDIO_STREAMSPI_OLEDDISPLAY_SSD1306_ACTIVE)    

        option(DIO_DISPLAYDEVICE_FEATURE                          "Display Device"                                          ON )
      
      endif()


      if(DIO_STREAMSPI_OLEDDISPLAY_SSD1331_FEATURE)

        add_definitions(-DDIO_STREAMSPI_OLEDDISPLAY_SSD1331_ACTIVE)    

        option(DIO_DISPLAYDEVICE_FEATURE                          "Display Device"                                          ON )

      endif()


      if(DIO_STREAMSPI_TFTDISPLAY_ILI9341_FEATURE)

        add_definitions(-DDIO_STREAMSPI_TFTDISPLAY_ILI9341_ACTIVE) 

        option(DIO_DISPLAYDEVICE_FEATURE                          "Display Device"                                          ON )

      endif()


      if(DIO_STREAMSPI_TFTDISPLAY_ST7789_FEATURE)

        add_definitions(-DDIO_STREAMSPI_TFTDISPLAY_ST7789_ACTIVE) 

        option(DIO_DISPLAYDEVICE_FEATURE                          "Display Device"                                          ON )

      endif()


      if(DIO_STREAMSPI_TOUCHSCREEN_STMPE610_FEATURE)

        add_definitions(-DDIO_STREAMSPI_TOUCHSCREEN_STMPE610_ACTIVE) 

      endif()

    endif()


    if(DIO_STREAMICMP_FEATURE)

      add_definitions(-DDIO_STREAMICMP_ACTIVE)

    endif()


    if(DIO_STREAMUDP_FEATURE)

      add_definitions(-DDIO_STREAMUDP_ACTIVE)

      option(HASH_FEATURE                                         "Hash"                                                    ON )
      option(HASH_CRC32_FEATURE                                   "Hash CRC32"                                              ON )

    endif()


    if(DIO_STREAMTCPIP_FEATURE)

      add_definitions(-DDIO_STREAMTCPIP_ACTIVE)

    endif()


    if(DIO_STREAMWIFI_FEATURE)

      add_definitions(-DDIO_STREAMTWIFI_ACTIVE)

    endif()

  endif()


  if(DIO_DISPLAYDEVICE_FEATURE)  

    add_definitions(-DDIO_DISPLAYDEVICE_ACTIVE)

  endif()


  if(DIO_BUSPIRATE_FEATURE)

    add_definitions(-DDIO_BUSPIRATE_ACTIVE)

  endif()

  
  if(DIO_CAMERA_FEATURE)

   option(XSCHEDULER_FEATURE                                      "XScheduler"                                              ON )  
  
  endif()


  if(DIO_APPLICATIONUPDATE_FEATURE)
   
    option(XPROCESSMANAGER_FEATURE                                "Process Manager"                                         ON )

  endif()


  if(DIO_MODBUSELECTRICMETER_FEATURE)

    option(DIO_MODBUSCLIENT_FEATURE                               "DIO ModBus Client"                                       ON )
    option(DIO_IEC60870_5_FEATURE                                 "DIO IEC 60870-5"                                         ON )

  endif()


endif()


# --------------------------------------------------------------------
# eXtended Utils


if(XFEEDBACK_CONTROL_FEATURE)

  add_definitions(-DXFEEDBACK_CONTROL_ACTIVE)    
  option(XLOG_FEATURE                                             "LOG File"                                                ON )  
  
endif()  


if(XTHREADCOLLECTED_FEATURE)

  add_definitions(-DXTHREADCOLLECTED_ACTIVE)    
  
endif()


if(XASN1_FEATURE)

  add_definitions(-DXASN1_ACTIVE)

  option(XBER_FEATURE                                             "XBER format"                                             ON )    

endif()


if(XBER_FEATURE)

  add_definitions(-DXBER_ACTIVE)

endif()


if(XSERIALIZABLE_BINARY_FEATURE)

  add_definitions(-DXSERIALIZABLE_BINARY_ACTIVE)
  
  option(XSERIALIZABLE_FEATURE                                    "Serializable functions"                                  ON )
  
endif()


if(XSERIALIZABLE_JSON_FEATURE)

  add_definitions(-DXSERIALIZABLE_JSON_ACTIVE)
  
  option(XSERIALIZABLE_FEATURE                                    "Serializable functions"                                  ON )
  
endif()


if(XSERIALIZABLE)

  add_definitions(-DXSERIALIZABLE_ACTIVE)

endif()


if(XCONSOLE_FEATURE)

  add_definitions(-DXCONSOLE_ACTIVE)  
  option(XSLEEP_FEATURE                                           "Sleep functions"                                         ON )

endif()


if(XSYSTEM_FEATURE)  

  add_definitions(-DXSYSTEM_ACTIVE)  

endif()


if(XFSMACHINE_FEATURE)

  add_definitions(-DXFSMACHINE_ACTIVE)  

endif()  


if(XSCHEDULER_FEATURE)

  add_definitions(-DXSCHEDULER_ACTIVE)  

endif()


if(XPUBLISHER_FEATURE)

  add_definitions(-DXPUBLISHER_ACTIVE)

endif()


if(XUUID_FEATURE)

  add_definitions(-DXUUID__ACTIVE)

  option(HASH_FEATURE                                             "Hash"                                                    ON )
  option(HASH_CRC32_FEATURE                                       "Hash CRC32"                                              ON )
    
endif()   
    
      
if(XLOG_FEATURE)    
    
  add_definitions(-DXLOG_ACTIVE)    
    
  option(XFILE_FEATURE                                            "XFile"                                                   ON )
  option(XFILE_ZIP_FEATURE                                        "XFile Zip format"                                        ON )
      
endif()   
    
    
if(XTRANSLATION_FEATURE)    
    
  add_definitions(-DXTRANSLATION_ACTIVE)    
    
  option(XFILE_JSON_FEATURE                                       "XFile JSON format"                                       ON )
  option(XTRANSLATION_GEN_FEATURE                                 "Translation GEN"                                         ON )

endif()


if(XTRANSLATION_GEN_FEATURE)  

  add_definitions(-DXTRANSLATION_GEN_ACTIVE)

endif()


if(XSLEEP_FEATURE)

  add_definitions(-DXSLEEP_ACTIVE) 

endif()


if(XPROCESSMANAGER_FEATURE)

  add_definitions(-DXPROCESSMANAGER_ACTIVE)
  option(XCONSOLE_FEATURE                                         "Console functions"                                       ON )

endif()


if(XSHAREDMEMORYMANAGER_FEATURE)

  add_definitions(-DXSHAREDMEMORYMANAGER_ACTIVE)

endif()


if(XDRIVEIMAGEMANAGER_FEATURE)

  add_definitions(-DXDRIVEIMAGEMANAGER_ACTIVE)

endif()   


if(XEEPROMMEMORYMANAGER_FEATURE)

  add_definitions(-DXEEPROMMEMORYMANAGER_ACTIVE)

endif() 


if(XFILE_CFG_FEATURE) 

  add_definitions(-DXFILE_CFG_ACTIVE)

  option(XFILE_INI_FEATURE                                        "XFile INI format"                                        ON )
  
endif() 
  
  
if(XFILE_INI_FEATURE)   
  
  add_definitions(-DXFILE_INI_ACTIVE) 
  
  option(XFILE_TXT_FEATURE                                        "XFile Text format"                                       ON )
  
endif() 
  
  
if(XFILE_ZIP_FEATURE)   
  
  add_definitions(-DXFILE_ZIP_ACTIVE) 
  
  option(XFILE_FEATURE                                            "XFile"                                                   ON )   
  
endif()   
  
  
if(XFILE_XML_FEATURE)   
  
  add_definitions(-DXFILE_XML_ACTIVE) 
  
  option(XFILE_TXT_FEATURE                                        "XFile Text format"                                       ON )
  
endif()   
  
  
if(XFILE_JSON_FEATURE)    
  
  add_definitions(-DXFILE_JSON_ACTIVE)  
  
  option(XFILE_TXT_FEATURE                                        "XFile Text format"                                       ON )
  
endif() 


if(XFILE_CSV_FEATURE)    
  
  add_definitions(-DXFILE_CSV_ACTIVE)  
  
  option(XFILE_TXT_FEATURE                                        "XFile Text format"                                       ON )
  
endif() 
  
  
if(XFILE_RIFF_FEATURE)  
  
  add_definitions(-DXFILE_RIFF_ACTIVE)  
  
  option(XFILE_FEATURE                                            "XFile"                                                   ON )     
  
endif()
  
  
if(XFILE_HEX_FEATURE)  

  add_definitions(-DXFILE_HEX_ACTIVE)

  option(XFILE_TXT_FEATURE                                        "XFile Text format"                                       ON )
  
endif() 
  
  
if(XFILE_DFU_FEATURE)   
  
  add_definitions(-DXFILE_DFU_ACTIVE) 
  
  option(XFILE_FEATURE                                            "XFile"                                                   ON )     
  
endif()   
  
  
if(XFILE_TXT_FEATURE) 
  
  add_definitions(-DXFILE_TXT_ACTIVE) 
  
  option(XFILE_FEATURE                                            "XFile"                                                   ON )     
  
endif()   
  
  
if(XFILE_FEATURE) 
  
  add_definitions(-DXFILE_ACTIVE) 
  
  option(CIPHER_SYMMETRIC_FEATURE                                 "Cipher"                                                  ON )
  option(CIPHER_SYMMETRIC_FEATURE                                 "Cipher Symetric"                                         ON )
  option(CIPHER_ASYMMETRIC_FEATURE                                "Cipher Asymetric"                                        ON )

endif()  


if(XASN1_FEATURE)

  add_definitions(-DXASN1_ACTIVE)

endif()


if(XLICENSE_FEATURE)
                   
  add_definitions(-DXLICENSE_ACTIVE)

  option(XUUID_FEATURE                                            "UUID functions"                                          ON )
  option(CIPHER_SYMMETRIC_FEATURE                                 "Cipher Symetric"                                         ON )
  option(CIPHER_SYMMETRIC_AES_FEATURE                             "Cipher Symetric AES"                                     ON )
  option(HASH_SHA1_FEATURE                                        "Hash SHA1"                                               ON )    
  option(HASH_SHA2_FEATURE                                        "Hash SHA2"                                               ON )

endif()


if(XFILE_ZIP_FEATURE)

  option(THIRDPARTYLIBRARIES_ZLIB_FEATURE                         "ZLib Compression Library"                                ON )

endif()



# --------------------------------------------------------------------
# Cipher

if(CIPHER_ASYMMETRIC_FEATURE)  

  if(CIPHER_ASYMMETRIC_FILEKEY_PEM)

    add_definitions(-DCIPHERKEYSFILEPEM_ACTIVE)
    option(XASN1_FEATURE                                          "ANS.1 functions"                                         ON )
  
  endif()

endif()


if(HASH_FEATURE)

  add_definitions(-DHASH_ACTIVE)

   
  if(HASH_CRC16_FEATURE)

    add_definitions(-DHASH_CRC16_ACTIVE)
  
  endif()

 
  if(HASH_CKS16_FEATURE)

    add_definitions(-DHASH_CKS16_ACTIVE)
  
  endif()

 
  if(HASH_CRC32_FEATURE)

    add_definitions(-DHASH_CRC32_ACTIVE)
  
  endif()

 
  if(HASH_MD5_FEATURE)

    add_definitions(-DHASH_MD5_ACTIVE)
  
  endif()

 
  if(HASH_SHA1_FEATURE)

    add_definitions(-DHASH_SHA1_ACTIVE)
  
  endif()

 
  if(HASH_SHA2_FEATURE)

    add_definitions(-DHASH_SHA2_ACTIVE)
  
  endif()

 
  if(HASH_COMP128V1_FEATURE)

    add_definitions(-DHASH_COMP128V1_ACTIVE)
  
  endif()

 
  if(HASH_WHIRLPOOL_FEATURE)

    add_definitions(-DHASH_WHIRLPOOL_ACTIVE)
  
  endif() 
  
  
  if(HASH_HMAC_FEATURE)

    add_definitions(-DHASH_HMAC_ACTIVE)

  endif()

endif()


if(CIPHER_SYMMETRIC_FEATURE)

  add_definitions(-DCIPHER_SYMMETRIC_ACTIVE)  

  if(CIPHER_SYMMETRIC_DES_FEATURE)

    add_definitions(-DCIPHER_SYMMETRIC_DES_ACTIVE)  

  endif()


  if(CIPHER_SYMMETRIC_AES_FEATURE)

    add_definitions(-DCIPHER_SYMMETRIC_AES_ACTIVE)
  
  endif()

  if(CIPHER_SYMMETRIC_AESGCM_FEATURE)

    add_definitions(-DCIPHER_SYMMETRIC_AESGCM_ACTIVE)

    option(CIPHER_SYMMETRIC_AES_FEATURE                           "Cipher Symetric AES"                                     ON )

  endif()

  if(CIPHER_SYMMETRIC_CHACHA20POLY1305_FEATURE)

    add_definitions(-DCIPHER_SYMMETRIC_CHACHA20POLY1305_ACTIVE)

  endif()

  if(CIPHER_SYMMETRIC_BLOWFISH_FEATURE)

    add_definitions(-DCIPHER_SYMMETRIC_BLOWFISH_ACTIVE)
  
  endif()

endif()

  
if(CIPHER_HKDF_FEATURE)

  add_definitions(-DCIPHER_HKDF_ACTIVE)

  option(HASH_FEATURE                                           "Hash"                                                    ON )
  option(HASH_HMAC_FEATURE                                      "Hash HMAC"                                               ON )

endif()
  
  
if(CIPHER_ASYMMETRIC_FEATURE)  
 
  add_definitions(-DCIPHER_ASYMMETRIC_ACTIVE)

  if(CIPHER_ASYMMETRIC_RSA_FEATURE)

    add_definitions(-DCIPHER_ASYMMETRIC_RSA_ACTIVE)

    if(CIPHER_ASYMMETRIC_FILEKEY_PEM)
  
      add_definitions(-DCIPHER_ASYMMETRIC_FILEKEY_PEM_ACTIVE)

  	endif()

  endif()

  if(CIPHER_ASYMMETRIC_ED25519_FEATURE)

    add_definitions(-DCIPHER_ASYMMETRIC_ED25519_ACTIVE)
    option(HASH_SHA2_FEATURE                                      "Hash SHA2"                                               ON )

  endif()

  if(CIPHER_ASYMMETRIC_MLKEM768_FEATURE)

    add_definitions(-DCIPHER_ASYMMETRIC_MLKEM768_ACTIVE)

  endif()

  if(CIPHER_ASYMMETRIC_MLKEM1024_FEATURE)

    add_definitions(-DCIPHER_ASYMMETRIC_MLKEM1024_ACTIVE)

  endif()

  if(CIPHER_ASYMMETRIC_X25519_FEATURE)

    add_definitions(-DCIPHER_ASYMMETRIC_X25519_ACTIVE)
  
  endif()

  # X.509, PEM/PKCS and credential loading are PKI facilities, not RSA
  # facilities.  Their common dependencies must therefore remain available
  # when RSA is disabled but another asymmetric provider is selected.
  if(CIPHER_ASYMMETRIC_ED25519_FEATURE OR CIPHER_ASYMMETRIC_MLKEM768_FEATURE OR
     CIPHER_ASYMMETRIC_MLKEM1024_FEATURE OR CIPHER_ASYMMETRIC_X25519_FEATURE OR CIPHER_ASYMMETRIC_RSA_FEATURE)

    option(HASH_FEATURE                                           "Hash"                                                    ON )
    option(HASH_SHA1_FEATURE                                      "Hash SHA1"                                               ON )
    option(XASN1_FEATURE                                          "ANS.1 functions"                                         ON )

  endif()

endif()


# --------------------------------------------------------------------
# Compress


if(COMPRESS_LZRW1KH_FEATURE)                                                              

  add_definitions(-DCOMPRESS_LZRW1KH_ACTIVE)

  option(COMPRESS_FEATURE                                         "Compress"                                                ON )
  
endif() 
  
  
if(COMPRESS_LZW_FEATURE)  
  
  add_definitions(-DCOMPRESS_LZW_ACTIVE)  
  
  option(COMPRESS_FEATURE                                         "Compress"                                                ON )
  
endif() 
  
  
if(COMPRESS_ZIP_FEATURE)  
  
  add_definitions(-DCOMPRESS_ZIP_ACTIVE)  
  
  option(COMPRESS_FEATURE                                         "Compress"                                                ON )
  
endif() 
  
  
if(COMPRESS_GZ_FEATURE)

  add_definitions(-DCOMPRESS_GZ_ACTIVE)

  option(COMPRESS_FEATURE                                         "Compress"                                                ON )
  option(THIRDPARTYLIBRARIES_ZLIB_FEATURE                         "ZLib Compression Library"                                ON )

endif()


if(COMPRESS_DEFLATE_FEATURE)

  add_definitions(-DCOMPRESS_DEFLATE_ACTIVE)

  option(COMPRESS_FEATURE                                         "Compress"                                                ON )
  option(THIRDPARTYLIBRARIES_ZLIB_FEATURE                         "ZLib Compression Library"                                ON )

endif()


if(COMPRESS_FEATURE)

  add_definitions(-DCOMPRESS_ACTIVE)
  
endif()


# --------------------------------------------------------------------
# ThirdPartyLibraries


if(GOOGLETEST_FEATURE)

  add_definitions(-DGOOGLETEST_ACTIVE)  
if(GRP_2D_FEATURE)

  option(THIRDPARTYLIBRARIES_AGG_FEATURE                          "AGG Anti-Grain Geometry Graphics 2D library"             ON )
  option(THIRDPARTYLIBRARIES_FREETYPE_FEATURE                     "Freetype Font Library"                                   ON )

endif()


if(GRP_BITMAP_FILE_JPG_FEATURE)

  option(THIRDPARTYLIBRARIES_JPEGLIB_FEATURE                      "JPEGLIB Library"                                         ON )

endif()


if(GRP_BITMAP_FILE_PNG_FEATURE)

  option(THIRDPARTYLIBRARIES_LIBPNG_FEATURE                       "LibPNG Library"                                          ON )

endif()


if(SND_FEATURE)  

  option(THIRDPARTYLIBRARIES_OPENAL_FEATURE                       "OpenAL Sound Library"                                    ON )    

endif()


if(SCRIPT_JAVASCRIPT_FEATURE)

endif()


if(GOOGLETEST_EXECFORDISCOVER_FEATURE)

  add_definitions(-DGOOGLETEST_EXECFORDISCOVER_ACTIVE)  

endif()
  option(THIRDPARTYLIBRARIES_DUKETAPE_FEATURE                     "DukeTape JavaScript Library"                             ON )

endif()


if(SCRIPT_LUA_FEATURE)

  option(THIRDPARTYLIBRARIES_LUA_SCRIPT_FEATURE                   "Lua Script Library"                                      ON )

endif()
