#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ===================================================
; Calculates a path that mimics human mouse movements
; ===================================================
RandomBezier( X0, Y0, Xf, Yf, O="" ) {
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 200
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 100
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 100
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
}

; ============================================================
; A smooth path into click. Path generates 2 to 4 checkpoints
; ============================================================
smoothClick(topX, topY, botX, botY, doClick=1) {
    x_coords := NormRand(topX, botX)
    y_coords := NormRand(topY, botY)
    mouseSpeed := rand(200, 321)
    RandomBezier(0, 0, x_coords, y_coords, "T" . mouseSpeed . " RO P2-3")
    rand_sleep(250, 400)
    if(doClick=1) {
        Click
    }
}

small_click() {
    mouseSpeed := rand(50, 125)
    randomFactor := rand(1, 100)
    MouseGetPos, xpos, ypos
    xpos += rand(-10, 10)
    ypos += rand(-10, 10)
    clicks := rand(0, 3)
    if(randomFactor > 50){
        RandomBezier(0, 0, xpos, ypos, "T" . mouseSpeed . " RO P2")
    }
    if(randomFactor > 80) {
        Loop, %clicks%
        {
            Click
            rand_sleep(50, 100)
        }
    }
    Click ; do just a simple click 1/4 of the time
}

rand_sleep(time_low, time_high) { ; Probably unnecessary, but set sleep to be semi-random to alleviate some banhammer suspicion.  Not like this is really detectable-
        Random, rand, %time_low%, %time_high% ; Generate sleep time between time_low and time_high in ms
        Sleep %rand% ; Sleep the generated time
}


NormRand( lo=0.0, hi=1 ) {
    Static x := 0x7FFFFFFF
    result := lo + ( hi - lo ) * (Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)
        +Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+Rand(-x,x)+12*x) / (24*x)
    return Ceil(result)
}

Rand(x,y) { ;just a random wrappr
    Random, var,%x%,%y%
    Return var
}

/*
 SetTimerF:
    An attempt at replicating the entire SetTimer functionality
       for functions. Includes one-time and recurring timers.

    Thanks to SKAN for initial code and conceptual research.
    Modified by infogulch to copy SetTimer features

 On User Call:
    returns: true if success or false if failure
    p1: Function name
    p2: Delay (int)(0 to stop timer, positive to start, negative to run once)
    p3: (optional) Pointer to data (uInt)(must be persistent at another location)
    p4: (optional) Length of data (uInt)
    Note: p3 & p4 don't necessarily have to be a pointer and length
       , but they must be numerical (positive/negative/float)

 On Timer: (user)
    p3 and p4 are passed as the first and second params if the function accepts them
    ErrorLevel is set to the TickCount

 On Timer: (internal)
    p1: HWND (unused)
    p2: uMsg (unused)
    p3: idEvent (timer id) used internally
       ( as per http://msdn.microsoft.com/en-us/library/ms644907 )
    p4: dwTime (tick count) Set ErrorLevel to this before user function call
*/
SetTimerF( p1, p2="", p3=0, p4=0 ) {
 Static tmrs, CBA

 if !CBA
    CBA := RegisterCallback( A_ThisFunc, "", 4 )
 If IsFunc( p1 ) {
    if RegExMatch(tmrs, "(?i)^(?<pre>.*)(?<=^|;)(?<tmr>\d+)," p1 ",[^;]*;(?<post>.*)$", _)
        ret := DllCall( "KillTimer", UInt,0, UInt, _tmr ), tmrs := _pre _post
    if (p2 = 0)
        return ret
    return !!tmr := DllCall( "SetTimer", UInt,0, UInt,0, UInt,p2 ? Abs(p2) : (p2 := 250), UInt,CBA )
       , tmrs .= tmr "," p1 "," p2 "," (p3+=0) "," (p4+=0) ";"
 }
    RegExMatch(tmrs, "^(?<pre>.*)(?<=^|;)" p3 ",(?<func>[\da-zA-Z@#$_]+),(?<delay>-?\d+),(?<ptr>\d*),(?<len>\d*);(?<post>.*)$", _)
    if (_delay < 0)
        DllCall( "KillTimer", UInt,0, UInt, p3 ), tmrs := _pre _post
    ErrorLevel := p4, %_func%( _ptr, _len )
}

SortArray(ByRef Array, Order="A") {
    ;Order A: Ascending, D: Descending, R: Reverse
    MaxIndex := ObjMaxIndex(Array)
    If (Order = "R") {
        count := 0
        Loop, % MaxIndex
            ObjInsert(Array, ObjRemove(Array, MaxIndex - count++))
        Return
    }
    Partitions := "|" ObjMinIndex(Array) "," MaxIndex
    Loop {
        comma := InStr(this_partition := SubStr(Partitions, InStr(Partitions, "|", False, 0)+1), ",")
        spos := pivot := SubStr(this_partition, 1, comma-1) , epos := SubStr(this_partition, comma+1)
        if (Order = "A") {
            Loop, % epos - spos {
                if (Array[pivot] > Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))
            }
        } else {
            Loop, % epos - spos {
                if (Array[pivot] < Array[A_Index+spos])
                    ObjInsert(Array, pivot++, ObjRemove(Array, A_Index+spos))
            }
        }
        Partitions := SubStr(Partitions, 1, InStr(Partitions, "|", False, 0)-1)
        if (pivot - spos) > 1    ;if more than one elements
            Partitions .= "|" spos "," pivot-1        ;the left partition
        if (epos - pivot) > 1    ;if more than one elements
            Partitions .= "|" pivot+1 "," epos        ;the right partition
    } Until !Partitions
}

clickDrag(startX1, startY1, startX2, startY2, moveX, moveY) {
    startX := NormRand(startX1, startX2)
    startY := NormRand(startY1, startY2)
    destX := startX + moveX
    destY := startY + moveY
    SendMode Event
    MouseClickDrag, L, %startX%, %startY%, %destX%, %destY%, 5
    SendMode Input
}

buildImgPath(imagePath) {
  return (imgDir . "\" . imagePath)
}
