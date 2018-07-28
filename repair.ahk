#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#include %A_ScriptDir%\common.ahk
#include %A_ScriptDir%\buttons.ahk

runRepairCycle(brute, threshold)  {
  WinActivate NoxPlayer ;Makes sure the window is Active
  findButton("images\homeCornerButton.png")
  ;if we found the home menu
  ; MsgBox, 1 brute value is: %brute%
  ; MsgBox, threshold value is: %threshold%
  checkRepairs(brute:=brute, threshold:=threshold)
  ; rand_sleep(50000, 60000)
}

checkRepairs(brute, threshold) {
  findButton("images\homeCornerButton.png")
  ; MsgBox, 2 brute value is:  %brute%
  if(brute=False) {
    ; Responsive to needing repairs
    if (!findButton("imagesEng\repairExclaim.png", False)) {
      ; MsgBox, bruteno repairs not needed
      return 0  ;returns 0 if no repairs are needed
    }
    ; MsgBox, bruteno - repairs needed
    clickButton("repair")
    rand_sleep(1000, 1500)
    findAndClick("imagesEng\repairDollButton.png", 31, 31)
    while(True) {
      if(findButton("imagesEng\dialogClose.png", False)) {
        ; MsgBox, dialogClose found
        findAndClick("imagesEng\dialogClose.png", 148, 40)
        break
      } else {
        rand_sleep(1000, 1200)
        ; MsgBox, dialogClose not found
        repairSlots := getRepairSlots(threshold)
        doRepair(repairSlots)
        break
      }
    }
    ; Return to main screen
    returnToMain()
    ; findAndClick("imagesEng\returnToBase.png", 110, 63)
  } else {
    ; MsgBox, bruteyes
    ; Repair anyway
    clickButton("repair")
    findAndClick("imagesEng\repairDollButton.png", 44, 44)
    rand_sleep(1000, 1500)
    if(findButton("imagesEng\dialogClose.png", False)) {
      ; If no repair needed
      findAndClick("imagesEng\dialogClose.png", 148, 40)
    } else {
      repairSlots := getRepairSlots(threshold)
      doRepair(repairSlots)
    }
    ; rand_sleep(1000, 1200)
    ; findAndClick("imagesEng\returnToBase.png", 110, 63)
  }
  returnToMain()
}

doRepair(repairArray){
  if (repairArray.Length() = 0){
    ; MsgBox, repairArray is empty
    findAndClick("imagesEng\repairCancel.png", 124, 67)
    return
  }
  Loop % repairArray.Length(){
    ; MsgBox % repairSlots[A_Index]
    _x1:= 50 + repairArray[A_Index] * (16 + 161)
    ; MsgBox % "x1 is " . _x1
    _x2:= _x1 + 100
    ; MsgBox % "x2 is " . _x2
    smoothClick(_x1, 200, _x2, 350)
  }
  findAndClick("imagesEng\repairOk.png", 146, 93)
  findAndClick("imagesEng\quickRepairYes.png", 70, 66)
  findAndClick("imagesEng\repairConfirmOk.png", 154, 56)
  findAndClick("imagesEng\dialogClose.png", 148, 40)
}

getRepairSlots(threshold){
  HPBarEmpty:="0x101010"
  HPBarFull:="0x42CF5A"
  HPBarLength:=159
  HP_X_Diff:=20
  row1_HP_Y:=365
  row1start:=17
  rowLength:=6
  rowPos:=0
  slotsToRepair:=[]
  while(rowPos < rowLength + 1){
    X1:=row1start + rowPos * (HP_X_Diff + HPBarLength)
    X2:=row1start + rowPos * (HP_X_Diff + HPBarLength) + HPBarLength
    calcX:=  X1 + (X2 - X1) * threshold/100

    ; Search for Full HP
    PixelSearch, OutputVarX, OutputVarY, %calcX%, %row1_HP_Y%, %calcX%, %row1_HP_Y%, %HPBarFull%, 15, Fast
    if (ErrorLevel!=0) {
        ; If can't find full HP, try find Empty HP
        PixelSearch, OutputVarX, OutputVarY, %calcX%, %row1_HP_Y%, %calcX%, %row1_HP_Y%, %HPBarEmpty%, 15, Fast
        if(ErrorLevel!=0){
          ; Break when HPFull and HPEmpty can't be found because no repair needed
          break
        }
    }
    ;; THEN FINE SEARCH
    ; PixelSearch, OutputVarX, OutputVarY, X1, Y1, X2, Y2, ColorID , Variation, Fast|RGB
    ; PixelGetcolor, color, %calcX%, %row1_HP_Y%
    PixelSearch, OutputVarX, OutputVarY, %calcX%, %row1_HP_Y%, %calcX%, %row1_HP_Y%, %HPBarFull%, 30, Fast
    if(ErrorLevel) {  ;if we can't find green
      ; MsgBox, needsRepair slotPos - %rowPos%
      slotsToRepair.Push(rowPos)
    }
    rowPos++
  }
  return slotsToRepair
}
