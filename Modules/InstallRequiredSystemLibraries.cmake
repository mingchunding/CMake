# By including this file, all files in the CMAKE_INSTALL_DEBUG_LIBRARIES,
# will be installed with INSTALL_PROGRAMS into /bin for WIN32 and /lib
# for non-win32. If CMAKE_SKIP_INSTALL_RULES is set to TRUE before including
# this file, then the INSTALL command is not called.  The use can use 
# the variable CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS to use a custom install 
# command and install them into any directory they want.
# If it is the MSVC compiler, then the microsoft run
# time libraries will be found add automatically added to the
# CMAKE_INSTALL_DEBUG_LIBRARIES, and installed.  
# If CMAKE_INSTALL_DEBUG_LIBRARIES is set and it is the MSVC
# compiler, then the debug libraries are installed when available.
# If CMAKE_INSTALL_MFC_LIBRARIES is set then the MFC run time
# libraries are installed as well as the CRT run time libraries.

IF(MSVC)
  FILE(TO_CMAKE_PATH "$ENV{SYSTEMROOT}" SYSTEMROOT)
  IF(MSVC70)
    SET(__install__libs
      "${SYSTEMROOT}/system32/msvcp70.dll"
      "${SYSTEMROOT}/system32/msvcr70.dll"
      )
  ENDIF(MSVC70)
  IF(MSVC71)
    SET(__install__libs
      "${SYSTEMROOT}/system32/msvcp71.dll"
      "${SYSTEMROOT}/system32/msvcr71.dll"
      )
  ENDIF(MSVC71)
  IF(MSVC80)
    # Find the runtime library redistribution directory.
    FIND_PATH(MSVC80_REDIST_DIR NAMES x86/Microsoft.VC80.CRT/Microsoft.VC80.CRT.manifest
      PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VisualStudio\\8.0;InstallDir]/../../VC/redist"
      )
    MARK_AS_ADVANCED(MSVC80_REDIST_DIR)
    SET(MSVC80_CRT_DIR "${MSVC80_REDIST_DIR}/x86/Microsoft.VC80.CRT")

    # Install the manifest that allows DLLs to be loaded from the
    # directory containing the executable.
    SET(__install__libs
      "${MSVC80_CRT_DIR}/Microsoft.VC80.CRT.manifest"
      "${MSVC80_CRT_DIR}/msvcm80.dll"
      "${MSVC80_CRT_DIR}/msvcp80.dll"
      "${MSVC80_CRT_DIR}/msvcr80.dll"
      )

    IF(CMAKE_INSTALL_DEBUG_LIBRARIES)
      SET(MSVC80_CRT_DIR
        "${MSVC80_REDIST_DIR}/Debug_NonRedist/x86/Microsoft.VC80.DebugCRT")
      SET(__install__libs ${__install__libs}
        "${MSVC80_CRT_DIR}/Microsoft.VC80.DebugCRT.manifest"
        "${MSVC80_CRT_DIR}/msvcm80d.dll"
        "${MSVC80_CRT_DIR}/msvcp80d.dll"
        "${MSVC80_CRT_DIR}/msvcr80d.dll"
        )
    ENDIF(CMAKE_INSTALL_DEBUG_LIBRARIES)

  ENDIF(MSVC80)
  IF(CMAKE_INSTALL_MFC_LIBRARIES)
    IF(MSVC70)
      SET(__install__libs ${__install__libs}
        "${SYSTEMROOT}/system32/mfc70.dll"
        )
    ENDIF(MSVC70)
    IF(MSVC71)
      SET(__install__libs ${__install__libs}
        "${SYSTEMROOT}/system32/mfc71.dll"
        )
    ENDIF(MSVC71)
    IF(MSVC80)
      IF(CMAKE_INSTALL_DEBUG_LIBRARIES)
        SET(MSVC80_MFC_DIR
          "${MSVC80_REDIST_DIR}/Debug_NonRedist/x86/Microsoft.VC80.DebugMFC")
        SET(__install__libs ${__install__libs}
          "${MSVC80_MFC_DIR}/Microsoft.VC80.DebugMFC.manifest"
          "${MSVC80_MFC_DIR}/mfc80d.dll"
          "${MSVC80_MFC_DIR}/mfc80ud.dll"
          "${MSVC80_MFC_DIR}/mfcm80d.dll"
          "${MSVC80_MFC_DIR}/mfcm80ud.dll"
          )
      ENDIF(CMAKE_INSTALL_DEBUG_LIBRARIES)
        
      SET(MSVC80_MFC_DIR "${MSVC80_REDIST_DIR}/x86/Microsoft.VC80.MFC")
      # Install the manifest that allows DLLs to be loaded from the
      # directory containing the executable.
      SET(__install__libs ${__install__libs}
        "${MSVC80_MFC_DIR}/Microsoft.VC80.MFC.manifest"
        "${MSVC80_MFC_DIR}/mfc80.dll"
        "${MSVC80_MFC_DIR}/mfc80u.dll"
        "${MSVC80_MFC_DIR}/mfcm80.dll"
        "${MSVC80_MFC_DIR}/mfcm80u.dll"
        )
    ENDIF(MSVC80)
    IF(MSVC80)
      # include the language dll's for vs8 as well as the actuall dll's
      SET(MSVC80_MFCLOC_DIR "${MSVC80_REDIST_DIR}/x86/Microsoft.VC80.MFCLOC")
      # Install the manifest that allows DLLs to be loaded from the
      # directory containing the executable.
      SET(__install__libs ${__install__libs}
        "${MSVC80_MFCLOC_DIR}/Microsoft.VC80.MFCLOC.manifest"
        "${MSVC80_MFCLOC_DIR}/mfc80chs.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80cht.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80enu.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80esp.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80deu.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80fra.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80ita.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80jpn.dll"
        "${MSVC80_MFCLOC_DIR}/mfc80kor.dll"
        )
    ENDIF(MSVC80)
  ENDIF(CMAKE_INSTALL_MFC_LIBRARIES)
  FOREACH(lib
      ${__install__libs}
      )
    IF(EXISTS ${lib})
      SET(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS
        ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS} ${lib})
    ENDIF(EXISTS ${lib})
  ENDFOREACH(lib)
ENDIF(MSVC)

# Include system runtime libraries in the installation if any are
# specified by CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS.
IF(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)
  IF(NOT CMAKE_SKIP_INSTALL_RULES)
    IF(WIN32)
      INSTALL_PROGRAMS(/bin ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS})
    ELSE(WIN32)
      INSTALL_PROGRAMS(/lib ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS})
    ENDIF(WIN32)
  ENDIF(NOT CMAKE_SKIP_INSTALL_RULES)
ENDIF(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)


