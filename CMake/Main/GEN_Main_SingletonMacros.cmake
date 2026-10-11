# --------------------------------------------------------------------
# GEN_Main_SingletonMacros.cmake
# Main: Macros for Singletons
# --------------------------------------------------------------------


# --- eXtension ------------------------------------------------------

set(GEN_MACRO  "-DGEN_XFACTORY=XFACTORY::GetInstance()")
add_definitions(${GEN_MACRO}) 

set(GEN_MACRO  "-DGEN_XSLEEP=XSLEEP::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XLOG=XLOG::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XSYSTEM=XSYSTEM::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XPROCESSMANAGER=XPROCESSMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XPATHSMANAGER=XPATHSMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})

if(XTRANSLATION_FEATURE)
  set(GEN_MACRO  "-DGEN_XTRANSLATION=XTRANSLATION::GetInstance()")
  add_definitions(${GEN_MACRO})
endif()

set(GEN_MACRO  "-DGEN_XPUBLISHER=XPUBLISHER::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XSHAREDMEMORYMANAGER=XSHAREDMEMORYMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XDRIVEIMAGEMANAGER=XDRIVEIMAGEMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_XEEPROMMEMORYMANAGER=XEEPROMMEMORYMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})


# --- Data Input/Output Manager --------------------------------------

set(GEN_MACRO  "-DGEN_DIOFACTORY=DIOFACTORY::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_DIOGPIO=DIOGPIO::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_DIODNSRESOLVER=DIODNSRESOLVER::GetInstance()")
add_definitions(${GEN_MACRO})

set(GEN_MACRO  "-DGEN_DIOALERTS=DIOALERTS::GetInstance()")
add_definitions(${GEN_MACRO})

# --- App Flow -------------------------------------------------------

set(GEN_MACRO  "-DGEN_APPFLOWALERTS=APPFLOWALERTS::GetInstance()")
add_definitions(${GEN_MACRO})


# --- Graphics Manager -----------------------------------------------

set(GEN_MACRO  "-DGEN_GRPFACTORY=GRPFACTORY::GetInstance()")
add_definitions(${GEN_MACRO})


# --- Input Manager --------------------------------------------------

set(GEN_MACRO  "-DGEN_INPMANAGER=INPMANAGER::GetInstance()")
add_definitions(${GEN_MACRO})


# --- Sound Manager --------------------------------------------------

set(GEN_MACRO  "-DGEN_SNDFACTORY=SNDFACTORY::GetInstance()")
add_definitions(${GEN_MACRO})


# --- User Interface -------------------------------------------------

set(GEN_MACRO  "-DGEN_USERINTERFACE=UI_MANAGER::GetInstance()")
add_definitions(${GEN_MACRO})


