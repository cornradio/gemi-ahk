#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true)

; ==============================================================================
; INCLUDES
; ==============================================================================
#Include Lib\Config.ahk
#Include Lib\FileHandler.ahk
#Include Lib\ScriptManager.ahk
#Include Lib\GuiMain.ahk
#Include Lib\Notification.ahk

; ==============================================================================
; INITIALIZATION
; ==============================================================================
Config_Init()
ScriptManager_Init()
GuiMain_Create()

; ==============================================================================
; DYNAMIC HOTKEYS
; ==============================================================================

if (HotkeyMode = "F1-F4") {
    Hotkey("F1", (*) => (GuiMain_Start(), ShowNotify("STARTED")))
    Hotkey("F2", (*) => (GuiMain_Pause(), ShowNotify("PAUSE / RESUME")))
    Hotkey("F3", (*) => (GuiMain_Stop(), ShowNotify("STOPPED")))
    Hotkey("F4", (*) => (GuiMain_CopyCoord(), ShowNotify("COORDS COPIED")))
} else {
    Hotkey("F7", (*) => (GuiMain_Start(), ShowNotify("STARTED")))
    Hotkey("F8", (*) => (GuiMain_Pause(), ShowNotify("PAUSE / RESUME")))
    Hotkey("F9", (*) => (GuiMain_Stop(), ShowNotify("STOPPED")))
    Hotkey("F10", (*) => (GuiMain_CopyCoord(), ShowNotify("COORDS COPIED")))
}

; End of auto-execute
return