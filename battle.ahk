#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; DEFAULT LOCALE, ENG
global locale:="EN"
#include %A_ScriptDir%\locale.ahk
#include %A_ScriptDir%\factory.ahk
#include %A_ScriptDir%\common.ahk
#include %A_ScriptDir%\buttons.ahk
#include %A_ScriptDir%\maps.ahk
#include %A_ScriptDir%\repair.ahk
#include %A_ScriptDir%\exceptionHandle.ahk


; The main loop
IfWinExist, NoxPlayer
{
  WinActivate NoxPlayer
  while True {
    runRepairCycle(False, 40)
    ; handleDollLimit()
    run43e()
    ; run02()
    ; clickScrapSlots(10)
    ; run54eRetreat()
    rand_sleep(2000, 3000)
  }
}

\::
Pause
Suspend
return
