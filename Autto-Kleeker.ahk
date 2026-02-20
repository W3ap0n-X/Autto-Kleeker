#NoEnv
Process, Priority, , A
SetKeyDelay, 0
SetMouseDelay, -1
SetDefaultMouseSpeed, 0

OpeningMsg := AK_INI("Options", "OpeningMsg", "Auto-Kleecker Activated")
TooltipTime := AK_INI("Options", "TooltipTime", 5000)
IsPaused := false
AK_Title:= "Autto-Kleecker"
AK_Version := "1.0.0"
AK_GUI_Size := "w400 h400"
AK_HELP := % {"Opening Greeting" : "This is the text you see on the tooltip when you first run the script. Feel free to have fun with it." , "ToolTip TimeOut" : "This is how long the little yellow popups will last before disappearing. Make sure that this is always a number", "Speed Settings" : "You can set each speed individually by specifying the number of milliseconds. Make sure that these are always numbers. Numpad0 is not shown as it is set to always have no delay."}
global IsPaused, OpeningMsg, TooltipTime, AK_HELP

AK_Startup:
AK_TT(OpeningMsg)

Return

^+r::
    AK_MSG("Reloading Script")
    Reload
Return

NumpadDot::
    Suspend, Toggle
    IsPaused := !IsPaused ? true : false
    AK_TT("Autto-Kleecker " . (!IsPaused ? "Activated" : "De-Activated"))
Return

Numpad0::
Numpad1::
Numpad2::
Numpad3::
Numpad4::
Numpad5::
Numpad6::
Numpad7::
Numpad8::
Numpad9::
    ClickSpeed := % AK_INI("Speed", SubStr(A_ThisHotkey, 0, 1), 200)
    
    AK_AutoClick(ClickSpeed, A_ThisHotkey)
    AK_TT(ClickSpeed)
Return


AK_AutoClick(delay, hotkey){
    Sleep, % delay
    KeyIsDown := GetKeyState(hotkey , "P")
    if(KeyIsDown > 0){
        Click
    }
}


AK_MSG(msg, title:="Autto-Kleecker", options:="", timeout:=""){
	MsgBox, % options, %title%, %msg%, %timeout%
}

AK_TT(msg:="", timeout:=3000){
	ToolTip 
	ToolTip % msg
	SetTimer, AK_TT-Kill, %timeout%
    return

    AK_TT-Kill:
		SetTimer, AK_TT-Kill, Off
		ToolTip
    return
}

AK_INI(sec, key:="", default:="", ini:=""){
	If !ini
		ini :=  % A_WorkingDir . "\Autto-Kleeker.ini"
	IniRead, val, %ini%, %sec%, %key%, %default%
	Return val
}

AK_INI_W(sec, key:="", val:="", ini:=""){
	If !ini
		ini :=  % A_WorkingDir . "\Autto-Kleeker.ini"
	IniWrite, %val%, %ini%, %sec%, %key%
	Return
}

^NumpadDot::
AK_GUI:
    Gui, AutoKleeker:New, +OwnDialogs, %AK_Title% - v%AK_Version%
    Gui, AutoKleeker:Default

    Gui, AutoKleeker:Add, Tab3, x5 y5 w390 +Theme, Options
	Gui, AutoKleeker:Tab, Options
    
	Gui, AutoKleeker:Add, text, x+0 y+0 W0 H0 +section 
    Gui, AutoKleeker:Add, text, xs+5 y+5 w125 vAK_TX_Greeting_Label, Opening Greeting 
    Gui, AutoKleeker:Add, Edit, xp y+5 w125 vAK_ED_Greeting, % OpeningMsg
    Gui, AutoKleeker:Add, Button, xp+130 yp w45 h24 gAK_Update_Greeting vAK_BT_Greeting_Save, Save

    Gui, AutoKleeker:Add, text, xp+60 ys+5 w125 vAK_TX_TooltipTime_Label, Tooltip Timeout
    Gui, AutoKleeker:Add, Edit, xp y+5 w125 vAK_ED_TooltipTime, % TooltipTime
    Gui, AutoKleeker:Add, Button, xp+130 yp w45 h24 gAK_Update_TooltipTime vAK_BT_TooltipTime_Save, Save

    Gui, AutoKleeker:Add, Tab3, x5 y100 w190 +Theme, Speeds
	Gui, AutoKleeker:Tab, Speeds
    Gui, AutoKleeker:Add, text, x+0 y+0 W0 H0 +section 

    SpeedCount := 1
    Loop % 9 {
        Gui, AutoKleeker:Add, text, % "xs+5 y+5 w45 vAK_TX_Speed" . SpeedCount . "_Label", % "Speed " . SpeedCount
        Gui, AutoKleeker:Add, Edit, % "xp+50 yp w75 vAK_ED_Speed" . SpeedCount, % AK_INI("Speed", SpeedCount, 200)
        Gui, AutoKleeker:Add, Button, % "xp+80 yp w45 h24 gAK_Update_Speed vAK_BT_Save_Speed" . SpeedCount, Save
        SpeedCount++
    }
    
    Gui, AutoKleeker:Add, Tab3, x205 y100 w190 +Theme, Help
	Gui, AutoKleeker:Tab, Help
    Gui, AutoKleeker:Add, text, x+0 y+0 W0 H0 +section 
    Gui, AutoKleeker:Add, text, xs+5 y+5 w125 vAK_Help1_Label, Opening Greeting 
    Gui, AutoKleeker:Add, Edit, xp y+5 w180 +ReadOnly vAK_ED_Help1, % AK_HELP["Opening Greeting"]

    Gui, AutoKleeker:Add, text, xp y+5 w125 vAK_Help2_Label, ToolTip TimeOut 
    Gui, AutoKleeker:Add, Edit, xp y+5 w180 +ReadOnly vAK_ED_Help2, % AK_HELP["ToolTip TimeOut"]

    Gui, AutoKleeker:Add, text, xp y+5 w125 vAK_Help3_Label, Speed Settings 
    Gui, AutoKleeker:Add, Edit, xp y+5 w180 +ReadOnly vAK_ED_Help3, % AK_HELP["Speed Settings"]

    Gui, AutoKleeker:Show, %AK_GUI_Size%
Return

AK_Update_TooltipTime:
    GuiControlGet, AK_ED_TooltipTime
    AK_MSG(AK_ED_TooltipTime)
    AK_INI_W("Options", "TooltipTime", AK_ED_TooltipTime)
    TooltipTime := AK_INI("Options", "TooltipTime", 5000)
    GuiControl,, AK_ED_TooltipTime , % TooltipTime
    AK_MSG("TooltipTime Updated: " . TooltipTime)
Return

AK_Update_Greeting:
    GuiControlGet, AK_ED_Greeting
    AK_MSG(AK_ED_Greeting)
    AK_INI_W("Options", "OpeningMsg", AK_ED_Greeting)
    OpeningMsg := AK_INI("Options", "OpeningMsg", 5000)
    GuiControl,, AK_ED_Greeting , % OpeningMsg
    AK_MSG("TooltipTime Updated: " . OpeningMsg)
Return

AK_Update_Speed:
    AK_MSG(A_GuiControl)
    AK_Set_Speed(SubStr(A_GuiControl, 0, 1) )
Return

AK_Set_Speed(key){
    NewSpeed := 0
    GuiControlGet, NewSpeed, , % "AK_ED_Speed" . key 
    AK_INI_W("Speed", key, NewSpeed)
    AK_MSG("Speed " . key . " updated: " . AK_INI("Speed", key, 200))
}
