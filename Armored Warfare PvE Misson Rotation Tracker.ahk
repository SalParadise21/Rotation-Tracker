#SingleInstance Force
SetTitleMatchMode 2
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

global OffsetVar:=0	;Controls how many minutes the time is offset
global OffsecVar:=0	;Controls how many seconds the time is offset
IfExist Offset.txt
{
	FileReadLine, OffsetVar, Offset.txt, 1
	FileReadLine, OffsecVar, Offset.txt, 2
}
MissionList=
IfNotExist Missions.txt	
{
	FileAppend, Albatross`nAnvil`nBanshee`nBasilisk`nCavalry`nCerberus`nDire Wolf, Missions.txt
	FileAppend,`nErebos`nFrostbite`nGhost Hunter`nHarbinger`nHydra`nKodiak`nLeviathan, Missions.txt
	FileAppend,`nLife Jacket`nMeltdown`nOnyx`nPerseus, Missions.txt
	FileAppend,`nPhalanx`nPrometheus`nQuarterback`nRaiding Party`nRed Opossum`nRicochet, Missions.txt
	FileAppend,`nRolling Thunder`nSapphire`nScorpio`nSnake Bite`nSpearhead, Missions.txt
	FileAppend,`nStarry Night`nStormy Winter`nTiger Claw`nTsunami`nUmbrella, Missions.txt
	FileAppend,`nWatchdog`nWildfire`nZero Hour, Missions.txt
}
Loop, Read, Missions.txt	;Missions.txt contains a list of all missions seperated by newlines
	MissionList=%MissionList%%A_LoopReadLine%|
Gui, Font, s12
yVar:=4
newTime := A_Hour * 60 + A_Min - OffsetVar + 150
if(OffsecVar > 45)
	newTime--
Transform, rVar, Mod, %newTime%, 30
CalcVar =
CalcVar += -%rVar%, minutes

HEADER_LOW_EASY := "Tiers 1-3 Standard"
HEADER_LOW_HARD := "Tiers 1-3 Hardcore"
HEADER_MID_EASY := "Tiers 4-6 Standard"
HEADER_MID_HARD := "Tiers 4-6 Hardcore"
HEADER_HIGH_EASY := "Tiers 7-10 Standard"
HEADER_HIGH_HARD := "Tiers 7-10 Hardcore"

Gui, Add, ComboBox, vHeader1 W200 X5 Y%yVar%, %HEADER_LOW_EASY%||
Gui, Add, ComboBox, vHeader2 W200 X214 Y%yVar%, %HEADER_LOW_HARD%||
Gui, Add, ComboBox, vHeader3 W200 X423 Y%yVar%, %HEADER_MID_EASY%||
Gui, Add, ComboBox, vHeader4 W200 X632 Y%yVar%, %HEADER_MID_HARD%||
Gui, Add, ComboBox, vHeader5 W200 X841 Y%yVar%, %HEADER_HIGH_EASY%||
Gui, Add, ComboBox, vHeader6 W200 X1050 Y%yVar%, %HEADER_HIGH_HARD%||

Gui, Add, Checkbox, vLockMaps gCheckLockMaps X1255 Y%yVar%, Lock maps

yVar+=45

Loop 10 {
	Gui, Add, ComboBox, vLOW_EASY%A_Index% W200 X5 Y%yVar% gSaveList R50, %MissionList%
	Gui, Add, ComboBox, vLOW_HARD%A_Index% W200 X214 Y%yVar% gSaveList R50, %MissionList%
	Gui, Add, ComboBox, vMID_EASY%A_Index% W200 X423 Y%yVar% gSaveList R50, %MissionList%
	Gui, Add, ComboBox, vMID_HARD%A_Index% W200 X632 Y%yVar% gSaveList R50, %MissionList%
	Gui, Add, ComboBox, vHIGH_EASY%A_Index% W200 X841 Y%yVar% gSaveList R50, %MissionList%
	Gui, Add, ComboBox, vHIGH_HARD%A_Index% W200 X1050 Y%yVar% gSaveList R50, %MissionList%
	yVar+=3
	Gui, Add, Text, vCD%A_Index% X1252 Y%yVar% W200, 00:00
	yVar+=10


	CalcVar+=-777, minutes

	yVar+=25
}
Loop, Read, MISSIONS_LOW_EASY.txt
	GuiControl, ChooseString, LOW_EASY%A_Index%, %A_LoopReadLine%
Loop, Read, MISSIONS_LOW_HARD.txt
	GuiControl, ChooseString, LOW_HARD%A_Index%, %A_LoopReadLine%
Loop, Read, MISSIONS_MID_EASY.txt
	GuiControl, ChooseString, MID_EASY%A_Index%, %A_LoopReadLine%
Loop, Read, MISSIONS_MID_HARD.txt
	GuiControl, ChooseString, MID_HARD%A_Index%, %A_LoopReadLine%
Loop, Read, MISSIONS_HIGH_EASY.txt
	GuiControl, ChooseString, HIGH_EASY%A_Index%, %A_LoopReadLine%
Loop, Read, MISSIONS_HIGH_HARD.txt
	GuiControl, ChooseString, HIGH_HARD%A_Index%, %A_LoopReadLine%
yVar+=-4
Gui, Add, Edit, X5 W55 vMinBox Y%yVar% Number, %OffsetVar%
Gui, Add, Edit, X63 W55 vSecBox Y%yVar% Number, %OffsecVar%
yVar--
Gui, Add, Button, X120 W295 H30 Y%yVar% gSetTimeOffset, Set Time Offset (Minutes/Seconds)
Gui, Add, Button, X945 W205 H30 Y%yVar% gClearList, Clear All Missions
Gui, Add, Button, X1155 W90 H30 Y%yVar% gHelpButton, Help
Gui, Add, Button, X1250 W90 H30 Y%yVar% gAboutButton, About
IfNotExist Pos.txt
{
	FileAppend, 0`n, Pos.txt
	FileAppend, 0, Pos.txt
}
FileReadLine, xPos, Pos.txt, 1
FileReadLine, yPos, Pos.txt, 2
Gui, Show, W1350 H460 X%xPos% Y%yPos%, Armored Warfare PvE Mission Rotation Tracker
GoSub EverySecond
SetTimer EverySecond, 1000
return

EverySecond:
newTime := A_Hour * 3600 + A_Min * 60 + A_Sec - OffsetVar * 60 - OffsecVar + 9000
Loop 10 {
	newTime -= 180
	Transform, rVar, Mod, %newTime%, 1800
	cVar:=1800-rVar
	if(cVar < 180){
		mVar:=AZ(floor(cVar/60))
		sVar:=AZ(mod(cVar,60))
		Gui, Font, cRed
		GuiControl, Text, CD%A_Index%, %mVar%:%sVar% - Active
		GuiControl, Font, CD%A_Index%
	}
	else{
		cVar-=180
		nextTime =
		nextTime += %cVar%, seconds
		FormatTime, nextTime, %nextTime%, HH:mm
		mVar:=AZ(floor(cVar/60))
		sVar:=AZ(mod(cVar,60))
		Gui, Font, cBlack
		GuiControl, Text, CD%A_Index%, %mVar%:%sVar% - %nextTime%
		GuiControl, Font, CD%A_Index%
	}
}
return

AZ(x){
	return SubStr( "0" x, -1)
}

SaveList:
	FileDelete, MISSIONS_LOW_EASY.txt
	FileDelete, MISSIONS_LOW_HARD.txt
	FileDelete, MISSIONS_MID_EASY.txt
	FileDelete, MISSIONS_MID_HARD.txt
	FileDelete, MISSIONS_HIGH_EASY.txt
	FileDelete, MISSIONS_HIGH_HARD.txt
	Loop 10 {
		GuiControlGet TempVar,, LOW_EASY%A_Index%
		FileAppend %TempVar%`n,MISSIONS_LOW_EASY.txt
		GuiControlGet TempVar,, LOW_HARD%A_Index%
		FileAppend %TempVar%`n,MISSIONS_LOW_HARD.txt
		GuiControlGet TempVar,, MID_EASY%A_Index%
		FileAppend %TempVar%`n,MISSIONS_MID_EASY.txt
		GuiControlGet TempVar,, MID_HARD%A_Index%
		FileAppend %TempVar%`n,MISSIONS_MID_HARD.txt
		GuiControlGet TempVar,, HIGH_EASY%A_Index%
		FileAppend %TempVar%`n,MISSIONS_HIGH_EASY.txt
		GuiControlGet TempVar,, HIGH_HARD%A_Index%
		FileAppend %TempVar%`n,MISSIONS_HIGH_HARD.txt
	}
return

Clearlist:
	GuiControlGet, LockMaps
	if(LockMaps)
	{
		MsgBox Maps are locked! Unlock maps to clear maps!
		
	}
	else
	{
		MsgBox, 4,, Are you sure you want to clear all missions?
		IfMsgBox Yes
			Loop 10	{
				GuiControl, Choose, LOW_EASY%A_Index%, 0
				GuiControl, Choose, LOW_HARD%A_Index%, 0
				GuiControl, Choose, MID_EASY%A_Index%, 0
				GuiControl, Choose, MID_HARD%A_Index%, 0
				GuiControl, Choose, HIGH_EASY%A_Index%, 0
				GuiControl, Choose, HIGH_HARD%A_Index%, 0
			}
			GuiControlGet OffsetVar,, MinBox
			GuiControlGet OffsecVar,, SecBox
	}
return

SetTimeOffset:
	FileDelete, Offset.txt
	GuiControlGet OffsetVar,, MinBox
	GuiControlGet OffsecVar,, SecBox
	if(OffsetVar > 29)
	{
		Transform, OffsetVar, Mod, %OffsetVar%, 30
		GuiControl,,MinBox,%OffsetVar%
	}
	if(OffsecVar > 59)
	{
		Transform, OffsecVar, Mod, %OffsecVar%, 60
		GuiControl,,SecBox,%OffsecVar%
	}
	FileAppend, %OffsetVar%`n%OffsecVar%, Offset.txt

	newTime := A_Hour * 60 + A_Min - OffsetVar + 150
	if(OffsecVar > 45)
		newTime--
	Transform, rVar, Mod, %newTime%, 30
	CalcVar =
	CalcVar += -%rVar%, minutes

	GoSub EverySecond
return

CheckLockMaps:
	GuiControlGet, LockMaps
	if(LockMaps)
	{
		Loop 10 {
			GuiControl, Disable, LOW_EASY%A_Index%
			GuiControl, Disable, LOW_HARD%A_Index%
			GuiControl, Disable, MID_EASY%A_Index%
			GuiControl, Disable, MID_HARD%A_Index%
			GuiControl, Disable, HIGH_EASY%A_Index%
			GuiControl, Disable, HIGH_HARD%A_Index%
		}
	}
	else
	{
		Loop 10 {
			GuiControl, Enable, LOW_EASY%A_Index%
			GuiControl, Enable, LOW_HARD%A_Index%
			GuiControl, Enable, MID_EASY%A_Index%
			GuiControl, Enable, MID_HARD%A_Index%
			GuiControl, Enable, HIGH_EASY%A_Index%
			GuiControl, Enable, HIGH_HARD%A_Index%
		}
	}
return

HelpButton:
	MessageText=Use the drop-down lists to select the missions that are currently active.
	MessageText=%MessageText%`nAny changes made to the drop-down lists are automatically saved.
	MessageText=%MessageText%`n`nTo adjust the time to match the contract deadline timer:
	MessageText=%MessageText%`n1) Enter a minute value in the 1st bottom left input text box
	MessageText=%MessageText%`n2) Enter a second value in the 2nd bottom left input text box
	MessageText=%MessageText%`n3) Press the "Set Time Offset" button
	MessageText=%MessageText%`n`nYou must press the "Clear All Missions" button when the map rotation
	MessageText=%MessageText%`nchanges to a new set of missions in order to properly offset the time.
	MessageText=%MessageText%`n`nEdit the Missions.txt file in order to add new missions.
	MsgBox,,Help, %MessageText%
return

AboutButton:
	MessageText=Armored Warfare PvE Mission Rotation Tracker v2.1 Lite
	MessageText=%MessageText%`n© 2016-2019 Wiser Guy
	MessageText=%MessageText%`n© 2019 Haswell (Kasuobes)
	MessageText=%MessageText%`n`nThis program is free software: you can redistribute it and/or modify
	MessageText=%MessageText%`nit under the terms of the GNU General Public License as published by
	MessageText=%MessageText%`nthe Free Software Foundation, either version 3 of the License, or
	MessageText=%MessageText%`n(at your option) any later version.
	MessageText=%MessageText%`n`nThis program is distributed in the hope that it will be useful, but
	MessageText=%MessageText%`nWITHOUT ANY WARRANTY; without even the implied warranty of
	MessageText=%MessageText%`nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	MessageText=%MessageText%`nGNU General Public License for more details.
	MessageText=%MessageText%`n`nYou should have received a copy of the GNU General Public License
	MessageText=%MessageText%`nalong with this program.  If not, see <https://www.gnu.org/licenses/>.
	MsgBox,,About, %MessageText%
return

GuiClose:
	WinGetPos, tx, ty,,,Armored Warfare PvE Mission Rotation Tracker
	FileDelete, Pos.txt
	FileAppend, %tx%`n, Pos.txt
	FileAppend, %ty%, Pos.txt	
ExitApp