/*
 * python.nsh
 *
 * Configure Python
 */

!include StrFunc.nsh
;${StrRep}

; On Windows NT-derived operating systems, Python.org installer for Python 2.4
; can be installed for all users or current user only.
; define the following symbol to install if Python is installed only for current user.
; !define INSTALL_IF_PYTHON_FOR_CURRENT_USER

!define STRING_PYTHON_NOT_FOUND "Python is not installed on this system. $\nPlease install Python first. $\n$\nClick OK to cancel installation and remove installation Files."

!define STRING_PYTHON_CURRENT_USER_FOUND "Python is installed for the current user only. $\n$\nOpenBazaar does not support use with Python so configured. $\n$\nClick OK to cancel installation and remove installation Files."

var PythonRoot
var PythonExecutable
var StrNoUsablePythonFound

Function ValidatePythonVersion
  ClearErrors
  MessageBox MB_OK "$PythonExecutable Here"
  nsExec::ExecToStack '"$PythonExecutable" "-c" "import sys; ver=sys.version_info[:2]; exit({True:0,False:1}[ver<(2,7) or ver>(2,7)])"'
FunctionEnd

; This must be a macro because the registry root key cannot be a variable
!macro EnumeratePython id hk_root hk
  loop${id}:
    EnumRegKey $1 HKLM "SOFTWARE\Python" $0
    DetailPrint $1
    StrCmp $1 "" done${id}
    IntOp $0 $0 + 1
    ReadRegStr $7 ${hk_root} "${hk}\$1\InstallPath" ""
    StrCpy $PythonExecutable "$7\python.exe"
    Call ValidatePythonVersion
    Pop $7
    StrCmp $7 0 ok loop${id}
  done${id}:
    StrCpy $PythonExecutable ""
!macroend

Function CheckForPython_new
    !insertmacro EnumeratePython 1 HKLM Software\Python\PythonCore
    !insertmacro EnumeratePython 2 HKLM Wow6432Node\Software\Python\PythonCore
    !insertmacro EnumeratePython 3 HKCU Software\Python\PythonCore
    !insertmacro EnumeratePython 4 HKCU Wow6432Node\Software\Python\PythonCore

  ok:
    MessageBox MB_OK "Found Python executable at '$PythonExecutable'"
    Push $PythonExecutable
    ${GetParent} $PythonExecutable $PythonRoot

FunctionEnd