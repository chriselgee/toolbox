; Edits file attributes -MAJ LG, 14 Mar 15

; Disables the little "H" systray icon while program runs
#NoTrayIcon
; Allows more than one copy to run at once
#SingleInstance, OFF

Gui, Add, Text, x16 y10 w370 h30 , Welcome to Elgee's file attribte changer.  Specify a file/files, pick attributes to change', and hit "Giddyup!"
Gui, Add, Edit, x16 y50 w370 vFilePath, .\*.*
Gui, Add, Text, x160 y250 , Note: If you set a file to read only, you cannot change its date.

Gui, Add, CheckBox, x400 y10 w180 h30 vSetAttribs, Set file attributes?
Gui, Add, CheckBox, x400 y35 w180 h30 vReadOnly, Read Only
Gui, Add, CheckBox, x400 y60 w180 h30 vArchive, Archive
Gui, Add, CheckBox, x400 y85 w180 h30 vSystem, System
Gui, Add, CheckBox, x400 y110 w180 h30 vHidden, Hidden
Gui, Add, CheckBox, x400 y135 w180 h30 vOffline, Offline
Gui, Add, CheckBox, x400 y160 w180 h30 vTemporary, Temporary


Gui, Add, CheckBox, x10 y75 w140 h30 vSetTime, Set file date/time?
Gui, Add, Text, x10 y105 w30 h20 , Year
Gui, Add, Edit, x10 y125 w30 h20 vYear, 1999
Gui, Add, Text, x45 y105 w30 h20 , Month
Gui, Add, Edit, x45 y125 w30 h20 vMonth, 12
Gui, Add, Text, x80 y105 w30 h20 , Day
Gui, Add, Edit, x80 y125 w30 h20 vDay, 31
Gui, Add, Text, x10 y155 w30 h20 , Hour
Gui, Add, Edit, x10 y175 w30 h20 vHour, 11
Gui, Add, Text, x45 y155 w40 h20 , Minute
Gui, Add, Edit, x45 y175 w30 h20 vMinute, 59
Gui, Add, Text, x80 y155 w40 h20 , Second
Gui, Add, Edit, x80 y175 w30 h20 vSecond, 59

Gui, Add, CheckBox, x10 y205 w100 vCreated, Created
Gui, Add, CheckBox, x10 y230 w100 vModified, Modified
Gui, Add, CheckBox, x10 y255 w100 vAccessed, Accessed

Gui, Add, CheckBox, x160 y75 w200 h30 vRecurse, Recurse through subs?
Gui, Add, Radio, x160 y105 w200 h30 vNoFolders checked, Don't operate on folders
Gui, Add, Radio, x160 y130 w200 h30 vYesFolders, Do operate on folders
Gui, Add, Radio, x160 y155 w200 h30 vOnlyFolders, Only operate on folders


Gui, Add, Button, x276 y200 w110 h30 Default, &Giddyup!

Gui, Show, x135 y109 h280 w537, Elgee's File Attribute Changer

Return
GuiClose:
ButtonCancel:
; Esc::ExitApp  ;Escape key will exit if you uncomment this line
ExitApp

; This defines the actions of the Giddyup! button
ButtonGiddyup!:
	Gui, Submit, NoHide	;commits edit box data to variables
	; MsgBox, Giddyup!`n vFilePath is %FilePath% `n vSetTime is %SetTime% `n vSetAttribs is %SetAttribs%

	If YesFolders
		Folders = 1
	else if OnlyFolders
		Folders = 2
	else
		Folders = 0
	
	if (SetAttribs = 0 and SetTime = 0)
		MsgBox, Please pick Set file attributes or Set file date/time
	
	If SetAttribs
	{
		Attribs = 
		
		If ReadOnly
			Attribs := Attribs . "+R"
		else
			Attribs := Attribs . "-R"
		If Archive
			Attribs := Attribs . "+A"
		else
			Attribs := Attribs . "-A"
		If System
			Attribs := Attribs . "+S"
		else
			Attribs := Attribs . "-S"
		If Hidden
			Attribs := Attribs . "+H"
		else
			Attribs := Attribs . "-H"
		If Offline
			Attribs := Attribs . "+O"
		else
			Attribs := Attribs . "-O"	
		If Temporary
			Attribs := Attribs . "+T"
		else
			Attribs := Attribs . "-T"	
		
		MsgBox, SetAttribs! `n Attribs is %Attribs%
		FileSetAttrib, %Attribs%, %FilePath%, %Folders%, %Recurse%
	}
	
	If SetTime
	{
		TDStamp = %Year%%Month%%Day%%Hour%%Minute%%Second%
		; MsgBox, TDStamp is %TDStamp% `n Folders is %Folders%
		; MsgBox % "TDStamp length is ". StrLen(TDStamp)
		
		if StrLen(TDStamp) < 14
		{
			MsgBox, Please use 4-digit year and 2-digits for all other time/date fields
			return
		}
		
		if Created
			FileSetTime, %TDStamp%, %FilePath%, C, %Folders%, %Recurse%
		
		if Modified
			FileSetTime, %TDStamp%, %FilePath%, M, %Folders%, %Recurse%
			
		if Accessed
			FileSetTime, %TDStamp%, %FilePath%, A, %Folders%, %Recurse%
	}
return
