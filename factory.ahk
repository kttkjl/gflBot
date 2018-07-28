#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

catchDollCapacity(scrapNo:=10, upToStar:=2, loop:=False) {
  if(loop) {
    ; If loop is true - keep looking for it
    while(True) {
      if(findButton(buildImgPath("dialogClose.png"), False)) {
        ; MsgBox, doll capacity reached, looping
        findAndClick(buildImgPath("dialogClose.png"), 148, 40)
        break
      }
    }
    returnToMain()
    runDisassemble(scrapNo:=scrapNo, upToStar:=upToStar)
  } else {
    ; img_path:=buildImgPath("dialogClose.png")
    ; res:=findButton(img_path, False)
    ; MsgBox % img_path . " , " . res
    if(findButton(buildImgPath("dialogClose.png"), False)) {
      ; MsgBox found dialogueClose
      findAndClick(buildImgPath("dialogClose.png"), 148, 40)
      returnToMain()
      runDisassemble(scrapNo:=scrapNo, upToStar:=upToStar)
      return True
    } else {
      ; If there was no dialogue box, return False
      return False
    }
    return False
  }
  return False
}

returnToMain() {
  ; MsgBox returning to main
  while(!findButton("images\homeCornerButton.png", loop=False)) {
    if (findButton("images\modalBack.png", loop=False)) {
      ; MsgBox, found modalBack
      findAndClick("images\modalBack.png", 54, 45)
    } else if (findButton(buildImgPath("returnToBase.png"), loop=False)) {
      findAndClick(buildImgPath("returnToBase.png"), 110, 63)
    } else if () {

    } else {
    }
  }
}

runDisassemble(scrapNo=5, upToStar=3) {
  goToFactoryPage()
  goToRetireTab()
  goToTDollScrap(upToStar:=upToStar)
  rand_sleep(500, 1000)
  clickScrapSlots(scrapNo:=scrapNo)
  confirmScrap()
  returnToMain()
}

goToFactoryPage() {
  ; Assuming you're at homeScreen
  while (!findButton("images\factoryScreen.png", False)) {
    clickButton("homeFactory", loop=False)
    rand_sleep(1000, 1500)
  }
  ; MsgBox found factoryhome
}

goToRetireTab() {
  ; Assuming you're at factoryScreen
  ; findAndClick(buildImgPath("factoryRetire.png"), 140, 40, loop=False)
  while (!findButton(buildImgPath("retireClicked.png"), False)) {
    findAndClick(buildImgPath("factoryRetire.png"), 140, 40, False)
    rand_sleep(1000, 1500)
  }
}

goToTDollScrap(upToStar) {
  ; MsgBox % "t doll scrap called: " . scrapNo
  while (!findButton(buildImgPath("tDollFilterButton.png"), False)) {
    findAndClick(buildImgPath("factorySelectTdoll.png"), 140, 48, False)
    rand_sleep(1000, 1500)
  }
  ; Click the filter button
  findAndClick(buildImgPath("tDollFilterButton.png"), 100, 40, False)
  ; decide on which stars to filter
  counter := upToStar
  while(counter >= 2) {
    selectFilterStar(counter)
    counter--
  }
  findAndClick(buildImgPath("tDollFilterButton.png"), 100, 40, False)
}

selectFilterStar(star) {
  filterButton := buildImgPath("starFilter" . star . ".png")
  finishCond := buildImgPath("starFilter" . star . "clicked.png")
  while(!findButton(finishCond, False)) {
    findAndClick(filterButton, 140, 60)
    rand_sleep(500, 600)
  }
}

clickScrapSlots(slots) {
  spot := 0
  x_spot := 0
  x_size := 161
  x_offset := 18
  y_offset := 18
  x_start := 14
  y_start := 112
  y_size := 286
  row_size := 5
  while(spot <= slots - 1) {
    if (x_spot > row_size) {
      x_spot := 0
    }
    ; MsgBox % "spot " . spot . " of " . slots . " is to be selected"
    _x1 := x_start + x_spot * (x_offset + x_size)
    _x2 := _x1 + x_size
    _y1 := y_start + Floor(spot/(row_size + 1)) * (y_size + y_offset)
    _y2 := _y1 + y_size
    smoothClick(_x1, _y1, _x2, _y2)
    spot++
    x_spot++
  }
}

confirmScrap() {
  findAndClick(buildImgPath("scrapOk.png"), 140, 50)
  findAndClick(buildImgPath("dismantle.png"), 140, 30)
  rand_sleep(500, 600)
  ; Two cases
  if (findButton("images/confirm.png", False)) {
    clickButton("confirm")
  }
  rand_sleep(500, 600)
}
