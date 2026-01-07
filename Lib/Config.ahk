; Config.ahk - Handle application configuration

global ScriptDir := ""
global HotkeyMode := "F7-F10" ; Default to F7-F10
global ConfigFile := A_ScriptDir "\config.ini"

Config_Init() {
    global ScriptDir, ConfigFile, HotkeyMode

    if !FileExist(ConfigFile) {
        ScriptDir := A_ScriptDir "\Scripts"
        if !DirExist(ScriptDir)
            DirCreate(ScriptDir)
        IniWrite(ScriptDir, ConfigFile, "Settings", "ScriptDir")
        IniWrite(HotkeyMode, ConfigFile, "Settings", "HotkeyMode")
    } else {
        try {
            temp := IniRead(ConfigFile, "Settings", "ScriptDir")
            ScriptDir := StrReplace(temp, '"', '')
            ScriptDir := RTrim(ScriptDir, "\")

            ; Read Hotkey Mode
            try {
                HotkeyMode := IniRead(ConfigFile, "Settings", "HotkeyMode")
            } catch {
                HotkeyMode := "F7-F10"
                IniWrite(HotkeyMode, ConfigFile, "Settings", "HotkeyMode")
            }
        } catch {
            ScriptDir := A_ScriptDir "\Scripts"
            IniWrite(ScriptDir, ConfigFile, "Settings", "ScriptDir")
        }
    }
}

Config_SaveScriptDir(newPath) {
    global ScriptDir, ConfigFile
    ScriptDir := RTrim(newPath, "\")
    IniWrite(ScriptDir, ConfigFile, "Settings", "ScriptDir")
}

Config_SaveHotkeyMode(mode) {
    global HotkeyMode, ConfigFile
    HotkeyMode := mode
    IniWrite(HotkeyMode, ConfigFile, "Settings", "HotkeyMode")
}
