/*
List of Shortcuts
=================

^+SPACE		Toggle always on top
#WheelUp/down	change tranparency
^!S		open notepad
^!D		Diary prompt
^!W		Vocabulary prompt
!^R		Reset transparency
!^T		Current tranparency
>!x		clickthroable the window
>!z		unclickthroable the window
^+v		Paste plain text
End of List of Shortcuts
*/


#InstallKeybdHook
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.  
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.




^+SPACE::  Winset, Alwaysontop, , A

;open 6th item on taskbar
;^!W:: send #{6}

;Opens notepad
^!S:: 
IfWinExist, Untitled - Notepad
	WinActivate
else
	Runwait notepad
;send ^+{SPACE} ; for keeping notepad always on top
return

^!D::
  ; Show the Input Box to the user.
  inputbox, text, Diary,,,300,100

  ; Format the time-stamp.
  current=%A_DD%-%A_MM%-%A_YYYY% %A_Hour%:%A_Min%

  ; Write this data to the diary.txt file.
  fileappend, %current%`n%text%`n`n, diary.txt
return

^!w::
  ; Show the Input Box to the user.
  inputbox, word, Enter a new word,,,300,100

  ; Write this data to the vocabulary.txt file.
  fileappend, %word%`n, vocabulary.txt
return

;Paste plain text
^+v::                            ; Text–only paste from ClipBoard
   Clip0 = %ClipBoardAll%
   ClipBoard = %ClipBoard%       ; Convert to text
   Send ^v                       ; For best compatibility: SendPlay
   Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
   ClipBoard = %Clip0%           ; Restore original ClipBoard
   VarSetCapacity(Clip0, 0)      ; Free memory
Return


; opacity of a window
;pasted from somewhere else but indepently works
; changing window transparencies
#WheelUp::  ; Increments transparency up by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans + 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    else
    {
        WinSet, Transparent, OFF, A
        WinSet, Transparent, 255, A
    }
return
#WheelDown::  ; Increments transparency down by 3.375% (with wrap-around)
    DetectHiddenWindows, on
    WinGet, curtrans, Transparent, A
    if ! curtrans
        curtrans = 255
    newtrans := curtrans - 8
    if newtrans > 0
    {
        WinSet, Transparent, %newtrans%, A
    }
    ;else
    ;{
    ;    WinSet, Transparent, 255, A
    ;    WinSet, Transparent, OFF, A
    ;}
return
!^R::  ; Reset Transparency Settings
    WinSet, Transparent, 255, A
    WinSet, Transparent, OFF, A
return
!^T::  ; Press Win+G to show the current settings of the window under the mouse.
    MouseGetPos,,, MouseWin
    WinGet, Transparent, Transparent, ahk_id %MouseWin%
    ToolTip Translucency:`t%Transparent%`n
	Sleep 2000
	ToolTip
return
;end of previous code

>!x::
WinGet, currentWindow, ID, A
addToWinArr(currentWindow)
WinSet, ExStyle, +0x80020, ahk_id %currentWindow%
return

>!z::
MouseGetPos,,, MouseWin ; Gets the unique ID of the window under the mouse
addToWinArr(MouseWin)
WinSet, ExStyle, -0x80020, ahk_id %currentWindow%
Return

TurnOffSI:
SplashImage, off
SetTimer, TurnOffSI, 1000, Off
Return

addToWinArr(chwnd){
	global winArr
	if (!winArr.hasKey(chwnd))
		winArr[chwnd] := true
}

Exit:
	for currentWindow, b in winArr
	{
		WinSet, ExStyle, -0x80020, ahk_id %currentWindow%
		WinSet, Trans, 255, ahk_id %currentWindow%
		Winset, AlwaysOnTop, off, ahk_id %currentWindow%
	}
	ExitApp
return
