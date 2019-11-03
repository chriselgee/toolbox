; Sends user-entered text to most recently used program  -LTLG, 27JUN06

; Disables the little "H" systray icon while program runs
#NoTrayIcon
; Allows more than one copy to run at once
#SingleInstance, OFF

Gui, Add, Edit, x16 y50 w370 h70 vTextFodder,
Gui, Add, Text, x206 y120 w40 h20 , Times:
Gui, Add, Button, x276 y120 w110 h30 Default, &Giddyup!
Gui, Add, Edit, x246 y120 w30 h20 vFireCount, 1
Gui, Add, Text, x16 y10 w370 h30 , Welcome to Elgee's text enter-er.  Simply enter the text you want typed`, choose how many times you want it typed`, and hit "Giddyup!"
Gui, Add, Text, x396 y10 w50 h90 , Modifiers:`n`n! Alt`n^ Ctrl`n+ Shift`n# Win
Gui, Add, CheckBox, x16 y120 w180 h30 vRawify, Interpret modifiers and special characters (at right)
Gui, Add, Text, x456 y10 w70 h170 , Special:`n`n{PAUSE}`n{TAB}`n{ALTDOWN}`n{CTRLUP}`n{DEL}`n{BS}`n{ENTER}`n{LEFT}`n{HOME}`n{{}, {}}, {!}, {+}`netc...
Gui, Add, Edit, x246 y160 w30 h20 vDelayify, 0
Gui, Add, Text, x16 y160 w220 h20 , Number of milliseconds between keystrokes
Gui, Add, Edit, x246 y180 w30 h20 vPausin, 0
Gui, Add, Text, x16 y180 w220 h20 , Number of milliseconds in a {PAUSE}
Gui, Add, Text, x396 y100 w50 h80 , Reserved:`n`n{, }`n!, ^, +, #
; Generated using SmartGUI Creator 4.0
Gui, Show, x135 y109 h208 w537, Elgee's Typer

Return
GuiClose:
ButtonCancel:
Esc::ExitApp  ;Escape key will exit
ExitApp

; This defines the actions of the Giddyup! button
ButtonGiddyup!:
	Gui, Submit, NoHide	;commits edit box data to variables
	Gui, Minimize		;Minimizes the GUI
	; MsgBox, TextFodder is %TextFodder%`nFireCount is %FireCount%`nRawify is %Rawify%`nDelayify is %Delayify%`nDelayify is %A_KeyDelay%`nPausin is %Pausin%
	SetKeyDelay, % Delayify
	
	Loop, % FireCount
	{
		IfEqual, Rawify, 0
		{
			;MsgBox Raw
			SendRaw, %TextFodder%
		}
		Else
		{
			PauseCheck(TextFodder,Pausin)	;send text, and pause time for check and typing
		}
	}
	
	GUI, Restore		;brings back the GUI
return

PauseCheck(Fodder, Pausin)
{
	StringGetPos, pos, Fodder, {PAUSE}
	If pos > 0
	{
		StringLeft, LeftBit, Fodder, pos
		StringRight, RightBit, Fodder, StrLen(Fodder) - pos - 7
		
		; MsgBox, I would PauseCheck %LeftBit%, wait for %Pausin%, and PauseCheck %RightBit%
		
		PauseCheck(LeftBit, Pausin)
		Sleep, Pausin
		PauseCheck(RightBit, Pausin)
	}
	Else
	{
		Send, %Fodder%
	}
	
}
