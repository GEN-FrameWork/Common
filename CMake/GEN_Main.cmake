# --------------------------------------------------------------------
# GEN_Main.cmake
# Main of GEN
# --------------------------------------------------------------------


if(NOT GEN_DETECT_PLATFORM_COMPILER)

  message(STATUS "[GEN]-------------------------------------------------------------------------------------------------------------------------------------[GEN]")
  
  option(GEN_MAIN_INIT "Main Init"  ON)
  
endif()


# --------------------------------------------------------------------
# Compile Selection
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Platform-Compiler.cmake") 


# --------------------------------------------------------------------
# Dependencies for source 
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Dependencies.cmake") 

  
# --------------------------------------------------------------------
# Warnings control
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Warnings.cmake") 


# --------------------------------------------------------------------
# Set Directories
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_SetDirectories.cmake")


# --------------------------------------------------------------------
# Set Enviroment
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Environment.cmake")


# -------------------------------------------------------------------- 
# Debug management and memory control
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_DebugMemCtrl.cmake") 


# --------------------------------------------------------------------
# Macros for Singletons
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_SingletonMacros.cmake") 


# --------------------------------------------------------------------
# Create Coverage
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_CoverageCreateInfo.cmake")  



# --------------------------------------------------------------------
# SOURCES

# --------------------------------------------------------------------
# Sources
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources.cmake") 


# --------------------------------------------------------------------
if(COMPILE_FOR_WINDOWS)
    
  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_Windows.cmake") 
     
endif()


# --------------------------------------------------------------------
if(COMPILE_FOR_LINUX)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_WaylandProtocols.cmake")
  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_Linux.cmake")

endif()


# -------------------------------------------------------------------- 
if(COMPILE_FOR_ANDROID32 OR COMPILE_FOR_ANDROID64)      

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_Android.cmake")           

endif()   


# --------------------------------------------------------------------
if(COMPILE_FOR_STM32)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_STM32.cmake")           

endif()


# --------------------------------------------------------------------
if(COMPILE_FOR_ESP32)

  include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_ESP32.cmake")           

endif()


# --------------------------------------------------------------------
# Sources Third Party Libraries
include("${GEN_DIRECTORY}/Common/CMake/Main/GEN_Main_Sources_ThirdPartyLibraries.cmake") 

