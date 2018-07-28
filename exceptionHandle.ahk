#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include %A_ScriptDir%\common.ahk
#include %A_ScriptDir%\buttons.ahk

; Runs doll limit - need others to check condition
handleDollLimit() {
  WinActivate NoxPlayer
  ; We're inside the close confirm window
  ; findAndClick("imagesEng\repairDialogClose.png", 148, 40)
  findAndClick("imagesEng\modalBack.png", 54, 45)
  findAndClick("imagesEng\returnToBase.png", 110, 63)

  ; Wait for homeScreen
  findButton("images\homeCornerButton.png")

  ; Handle expd shenanigans here - TODO
  while(1){
    ; Find that screen, as long as we're not there, keep runnin this shit
    ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 "imagesEng\factoryScreen.png"
    if(ErrorLevel = 0) {
      break
    } else {
      ; keep tryin that button
      findAndClick("imagesEng\homeFactory.png", 120, 40)
      ; Pause a bit after clicking it
      rand_sleep(1000, 1200)
    }
  }

  ; CLick the retirebutton
  findAndClick("imagesEng\factoryRetire.png", 140, 60)
  findAndClick("imagesEng\factorySelectTdoll.png", 140, 48)

}
