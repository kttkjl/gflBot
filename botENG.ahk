#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#include %A_ScriptDir%\common.ahk
#include %A_ScriptDir%\buttons.ahk

; The main loop
IfWinExist, NoxPlayer
{
    WinActivate NoxPlayer
    ;confirm it's home
    findButton("images\homeCornerButton.png")

    ; clickButton(combat)
    ; while True {
    ;     WinActivate NoxPlayer
    ;     findButton("images\expReturn.png")
    ;     smoothClick(450, 140, 700, 530)
    ;     clickButton("confirm")
    ; }
    ; clickButton(combat)
    ; findButton("images\Difficulty.png")
    ; smoothClick(140, 370, 190, 400) ; Level 4
    ; selectDifficulty("emergency")
}
