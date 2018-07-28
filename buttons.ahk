#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include %A_ScriptDir%\common.ahk


clickButton(button, loop=True) {
    if(button="combat") {
        image := buildImgPath("combat.png")
        sizeX = 48
        sizeY = 22
    } else if(button="startBattle") {
        image := buildImgPath("normalBattle.png")
        sizeX = 44
        sizeY = 65
    } else if(button="repair") {
        image := buildImgPath("homeRepair.png")
        sizeX = 107
        sizeY = 27
    } else if(button="confirm") {
        image := "images\confirm.png"
        sizeX = 40
        sizeY = 40
    } else if(button="43eHQ") {
        image := buildImgPath("43eHQ.png")
        sizeX = 51
        sizeY = 62
    } else if(button="43eHeli") {
        image := buildImgPath("43eHeli.png")
        sizeX = 43
        sizeY = 44
    } else if(button="02HQ") {
        image := buildImgPath("02HQ.png")
        sizeX = 43
        sizeY = 44
    } else if(button="02Heli") {
        image := buildImgPath("02Heli.png")
        sizeX = 63
        sizeY = 38
    } else if(button="place") {
        image := buildImgPath("place.png")
        sizeX = 139
        sizeY = 56
    } else if(button="54eHQ") {
        image := buildImgPath("54eHQ.png")
        sizeX = 38
        sizeY = 42
    } else if (button="54eHeli") {
        image := buildImgPath("54eHeli.png")
        sizeX = 24
        sizeY = 27
    } else if (button="moveButton") {
        image := buildImgPath("moveButton.png")
        sizeX = 57
        sizeY = 40
    } else if (button="retreatButton") {
        image := buildImgPath("retreatButton.png")
        sizeX = 49
        sizeY = 38
    } else if (button="stopBattle") {
        image := buildImgPath("stopBattle.png")
        sizeX = 87
        sizeY = 29
    } else if (button="termMiss") {
        image := buildImgPath("termMiss.png")
        sizeX = 129
        sizeY = 46
    } else if (button="endRound") {
        image := buildImgPath("endRound.png")
        sizeX = 153
        sizeY = 54
    } else if (button="homeFactory") {
        image := buildImgPath("homeFactory.png")
        sizeX = 120
        sizeY = 40
    }
    if(loop=True) {
        while(1!=0) {
            ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %image%
            if(ErrorLevel = 0) {
                smoothClick(OutputVarX, OutputVarY, OutputVarX + sizeX, OutputVarY + sizeY)
                break
            }
            rand_sleep(200, 300)
        }
    } else {
        ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %image%
        if(ErrorLevel = 0) {
            smoothClick(OutputVarX, OutputVarY, OutputVarX + sizeX, OutputVarY + sizeY)
            return True
        } else {
            return False
        }
    }
}

findButton(imagePath, loop=True) {
    if(loop=True) {
        while(1!=0) {
            ImageSearch, sortie_x, sortie_y, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %imagePath%
            if(ErrorLevel = 0) {
                break
            }
            rand_sleep(500, 1000)
        }
        return True
    } else {
        ImageSearch, sortie_x, sortie_y, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %imagePath%
        if(ErrorLevel = 0) {
            return True
        } else {
            return False
        }
    }
}

findAndClick(imagePath, sizeX, sizeY, loop=True) {
  if(loop=True) {
    while(1!=0) {
      ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %imagePath%
      if(ErrorLevel = 0) {
        smoothClick(OutputVarX, OutputVarY, OutputVarX + sizeX, OutputVarY + sizeY)
        return True
      }
    }
  } else {
    ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, *20 %imagePath%
    if(ErrorLevel = 0) {
      smoothClick(OutputVarX, OutputVarY, OutputVarX + sizeX, OutputVarY + sizeY)
      return True
    } else {
      return False
    }
  }
}

startBattle() {
    smoothClick(1005, 630, 1255, 733)
}

selectDifficulty(difficulty) {
    PixelGetcolor, color, 1230, 165
    if(color="0x00B6FF" or color="0x00B4FF") {
        if(difficulty="normal") {
            return
        } else if(difficulty="emergency") {
            clickAmount := 1
        } else {
            clickAmount := 2
        }
    } else if(color="0x0030EF") {
        if(difficulty="normal") {
            clickAmount := 2
        } else if(difficulty="emergency") {
            return
        } else {
            clickAmount := 1
        }
    } else if(color="0x634510") {
        if(difficulty="normal") {
            clickAmount := 1
        } else if(difficulty="emergency") {
            clickAmount := 2
        } else {
            return
        }
    } else {
        rand_sleep(500, 1000)
        selectDifficulty(difficulty)
    }
    Loop, %clickAmount% {
        smoothClick(424, 169, 900, 250)
    }
}

selectMission(num) {
    clickX := 450
    clickX2 := 950
    clickY := 290
    gap := 120 * (num - 1)
    smoothClick(clickX, clickY + gap, clickX2, clickY + gap + 80)
}
