#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#include %A_ScriptDir%\common.ahk
#include %A_ScriptDir%\buttons.ahk
#include %A_ScriptDir%\factory.ahk

safeClick() {
  smoothClick(680, 475, 810, 530)
  FileAppend, safeClickin, *
  rand_sleep(500, 700)
}

tryCombat(){
  while (True) {
    ; are we at mission screen

    if(findButton("imagesEng\missionScreen.png", loop=False)){
      ; MsgBox, MISSION SCREEN FOUND
      rand_sleep(2000, 2500)  ;for fuckin' expds
      findButton("imagesEng\missionScreen.png") ;let expds finish, and pause here
      break
    }
    ; are we at home

    if(findButton("images\homeCornerButton.png", loop=False)) {
      ; MsgBox, MISSON SCREEN NOT FOUND
      clickButton("combat", loop=False)
    }
  }
}


run54eRetreat(){
  WinActivate NoxPlayer
  ; if(!findButton("images\homeCornerButton.png", loop=False)){
  ; 	return
  ; }
  ;foundMission = False
  ; FileAppend, running 54ERetreat `n, *
  ;FileAppend, foundMission %foundMission%`n, *
  ; while(True) {
  ;   MsgBox, Error level is %ErrorLevel% `n, *
  ;   ; Check screen
  ;   global atCombat = False
  ;   atCombat := tryCombat()
  ;   ; FileAppend, after tryCombat Error level is %ErrorLevel% - atCombat is %atCombat% `n, *
  ;
  ;   if(atCombat){
  ;     MsgBox, Error level is %ErrorLevel% `n, *
  ;     break
  ;   }
  ; }
  tryCombat()
  rand_sleep(500, 700)
  selectDifficulty("emergency")
  rand_sleep(300, 500)
  ;smoothClick(210, 650, 303, 705) ;Click chapter 5 - game start will always default to 1
  rand_sleep(300, 500)
  selectMission(4)
  rand_sleep(300, 500)
  clickButton("startBattle")
  rand_sleep(1000, 2000)
  clickButton("54eHQ")	;works
  rand_sleep(300, 600)
  clickButton("place")	;places first team on HQ
  rand_sleep(500, 700)
  clickDrag(545, 150, 780, 200, 0, 500)	;Drags the map up
  rand_sleep(200, 400)
  clickDrag(545, 150, 780, 200, 0, 500)	;Drags the map up
  rand_sleep(200, 400)
  clickDrag(545, 150, 780, 200, 0, 500)	;Drags the map up
  clickButton("54eHeli")	;works
  rand_sleep(300, 600)
  clickButton("place")	;places the 2nd team on HeliPad
  rand_sleep(300, 600)

  clickDrag(545, 700, 780, 650, 0, -600)	;Drags the map down
  rand_sleep(200, 400)
  clickDrag(545, 700, 780, 650, 0, -600)	;Drags the map down
  rand_sleep(200, 400)
  clickDrag(545, 700, 780, 650, 0, -600)	;Drags the map down

  rand_sleep(300, 600)
  startBattle()
  rand_sleep(3000, 4000)
  findButton("images\cancelMission.png") 	;will loop here if not found
  ; Battle clicks here
  smoothClick(1017, 558, 1059, 599)	; First position - Helipad
  smoothClick(1072, 292, 1110, 320)	; Right
  finishBattle()
  smoothClick(1061, 352, 1120, 413)	; Second position
  smoothClick(872, 436, 944, 487)	; Center
  finishBattle()
  smoothClick(880, 360, 944, 413)	; Third position
  smoothClick(764, 520, 805, 560)	; Left
  finishBattle()
  smoothClick(764, 520, 805, 560)	; Fourth position
  smoothClick(1017, 558, 1059, 599)	; Home
  rand_sleep(300, 600)
  clickButton("moveButton")
  ; Retreat
  rand_sleep(300, 500)
  while(!findButton("images\retreatButton.png", loop=False)){
    smoothClick(1017, 558, 1059, 599)	; Home
    rand_sleep(2000, 2500)
  }
  rand_sleep(300, 500)
  clickButton("retreatButton")
  clickButton("confirm")
  clickButton("stopBattle")
  clickButton("termMiss")
}

getTo43Screen(){
  WinActivate NoxPlayer
  findButton("images\homeCornerButton.png", loop=True)
  tryCombat()
  selectDifficulty("emergency")
  rand_sleep(300, 500)
  selectMission(3)
  rand_sleep(300, 500)
  clickButton("startBattle")
  rand_sleep(1000, 2000)
}

run43e() {
  getTo43Screen()
  rand_sleep(500, 750)
  caughtCapacity := catchDollCapacity(scrapNo:=10, upToStar:=3)
  if (caughtCapacity) {
    getTo43Screen()
  }
  clickButton("43eHQ")
  rand_sleep(300, 600)
  clickButton("place")
  clickButton("43eHeli")
  rand_sleep(300, 600)
  clickButton("place")
  rand_sleep(300, 600)
  startBattle()
  rand_sleep(3000, 4000)
  findButton("images\cancelMission.png")
  smoothClick(1050, 500, 1110, 534)	; First position - Helipad
  smoothClick(1040, 345, 1085, 370)	; First enemy
  finishBattle()
  smoothClick(1040, 365, 1080, 405)	; Second position
  smoothClick(1100, 215, 1140, 250)	; Second enemy
  finishBattle()
  smoothClick(1100, 370, 1140, 410)	; Third position
  smoothClick(1010, 210, 1050, 250)	; Third Enemy
  finishBattle()
  smoothClick(1010, 370, 1050, 400)	; Fourth position
  smoothClick(1015, 165, 1055, 185)	; Boss
  findButton("images\pause.png")
  rand_sleep(300, 600)
  clickDrag(540, 525, 680, 650, 0, -100)
  finishBattle()
  smoothClick(1105, 678, 1250, 740) 	; End
  finishSortie()
}

getTo02Screen() {
  WinActivate NoxPlayer
  tryCombat()
  rand_sleep(500, 700)
  selectMission(2)
  rand_sleep(300, 500)
  findButton("imagesEng\normalBattle.png")  ;just to make fucking sure
  clickButton("startBattle")
  rand_sleep(500, 750)
}
run02() {
  getTo02Screen()
  ; caughtCapacity := False
  rand_sleep(500, 750)
  caughtCapacity := catchDollCapacity(scrapNo:=10, upToStar:=3)
  if (caughtCapacity) {
    getTo02Screen()
  }
  rand_sleep(1000, 2000)
  findButton("imagesEng\02HQ.png")
  clickButton("02HQ")
  rand_sleep(300, 600)
  clickButton("place")
  clickButton("02Heli")
  rand_sleep(300, 600)
  clickButton("place")
  rand_sleep(300, 600)
  startBattle()
  rand_sleep(2000, 2500)
  ; ;;During Battle
  smoothClick(230, 350, 280, 400)
  smoothClick(300, 200, 350, 220)
  finishBattle()
  smoothClick(310, 360, 370, 410)
  smoothClick(290, 180, 330, 230)
  finishBattle()
  smoothClick(310, 360, 370, 410)
  smoothClick(500, 420, 550, 470)
  finishBattle()

  ; First end round
  clickButton("endRound")
  ; rand_sleep(11000, 11500)  ;old end condition, shit code

  ; endcondition here - fuck
  while(1!=0) {
    PixelSearch, OutputVarX, OutputVarY, 1188, 57, 1188, 57, "0x00BAFF", 15, Fast
    if(ErrorLevel=0) {
      break
    }
    ; PixelGetColor, pixelColor, 1188, 57
    ; if(pixelColor = "0x00BAFF") {
    ;     break
    ; }
    ; rand_sleep(100, 200)
  }

  rand_sleep(2000, 300)
  ;; DRAG THIS SHIT UP
  clickDrag(545, 150, 780, 200, 0, 500)	;Drags the map up
  rand_sleep(200, 400)
  clickDrag(545, 150, 780, 200, 0, 500)	;Drags the map up
  rand_sleep(200, 400)

  ;;2nd round
  ; findbutton("imagesEng\turn02.png") ; doesn't work
  smoothClick(510, 560, 560, 610)
  smoothClick(640, 360, 690, 410)
  rand_sleep(1000, 1050)
  smoothClick(490, 270, 540, 320)
  finishBattle()

  smoothClick(490, 270, 540, 320)
  smoothClick(780, 260, 830, 310)
  finishBattle()

  ;;Last Battle
  smoothClick(780, 260, 830, 310)
  smoothClick(960, 300, 1010, 350)
  finishBattle()

  ;;End round
  ;;End Condition:
  findbutton("imagesEng\02EndCond.png")
  rand_sleep(1200, 1250)
  smoothClick(1110, 670, 1250, 710)

  finishSortie()
  ; rand_sleep(60000, 60000)
}

finishSortie() {
  findButton("images\missionEnd.png")
  while(!findButton("images\homeCornerButton.png", loop=False)){
    smoothClick(650, 450, 770, 550)
  }
}

finishBattle(rapid=False) {
  findButton("images\leader.png")
  ; smoothClick(300, 200, 1000, 600)
  ; rand_sleep(100, 500)
  ; smoothClick(300, 200, 1000, 600)
  ; rand_sleep(100, 500)
  ; smoothClick(300, 200, 1000, 600)
  ; rand_sleep(100, 500)
  while(!findbutton(buildImgPath("endTurn.png"), False)){
    smoothClick(300, 200, 1000, 600)
    rand_sleep(100, 200)
  }
  rand_sleep(2000, 2200)
}
