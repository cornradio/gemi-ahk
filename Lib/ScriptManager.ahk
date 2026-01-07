; ScriptManager.ahk - Manage script lifecycle with Wrapper Loop

global RunningScripts := Map()
global TempFolder := A_ScriptDir "\Temp"

ScriptManager_Init() {
    global RunningScripts := Map()
    if !DirExist(TempFolder)
        DirCreate(TempFolder)
}

ScriptManager_Start(fileName, targetCount) {
    global ScriptDir, RunningScripts, TempFolder

    if RunningScripts.Has(fileName) {
        return 0
    }

    userCodePath := ScriptDir "\" fileName
    if !FileExist(userCodePath)
        return 0

    ; Read the actual script content
    userCode := FileRead(userCodePath)

    ; Create a wrapped runner script
    ; targetCount = 0 means infinite
    loopHeader := (targetCount = "0") ? "Loop" : "Loop " targetCount

    ; Use a more robust way to build the script to avoid quote/escape issues
    nl := "`r`n"
    sc := Chr(59) ; Semicolon character to avoid being treated as a comment in this file

    ; Target the specific GUI window handle
    targetHWND := MainGui.Hwnd

    runnerCode := "#Requires AutoHotkey v2.0" nl
    runnerCode .= "#NoTrayIcon" nl
    runnerCode .= "DetectHiddenWindows(true)" nl nl
    runnerCode .= "MainHWND := " targetHWND nl nl
    runnerCode .= loopHeader " {" nl
    runnerCode .= "    " sc " --- USER CODE START ---" nl
    runnerCode .= userCode nl
    runnerCode .= "    " sc " --- USER CODE END ---" nl nl
    runnerCode .= "    if WinExist('ahk_id ' MainHWND)`r`n"
    runnerCode .=
        "        try SendMessage(0x401, DllCall('GetCurrentProcessId'), A_Index, , 'ahk_id ' MainHWND, , , , 500)`r`n"
    runnerCode .= "}"

    runnerPath := TempFolder "\Runner_" fileName
    if FileExist(runnerPath)
        FileDelete(runnerPath)

    FileAppend(runnerCode, runnerPath)

    try {
        Run('AutoHotkey.exe "' runnerPath '"', , , &pid)
        RunningScripts[fileName] := pid
        return pid
    } catch Error as err {
        MsgBox("Failed to start runner:`n" err.Message, "Error", 16)
        return 0
    }
}

ScriptManager_Stop(fileName) {
    global RunningScripts
    if RunningScripts.Has(fileName) {
        pid := RunningScripts[fileName]
        try ProcessClose(pid)
        RunningScripts.Delete(fileName)
        return true
    }
    return false
}

ScriptManager_Pause(fileName) {
    global RunningScripts
    if RunningScripts.Has(fileName) {
        pid := RunningScripts[fileName]
        ; 0x111 is WM_COMMAND, 65306 is AHK_PAUSE
        PostMessage(0x111, 65306, , , "ahk_class AutoHotkey ahk_pid " pid)
        return true
    }
    return false
}

ScriptManager_IsRunning(fileName) {
    global RunningScripts
    if RunningScripts.Has(fileName) {
        pid := RunningScripts[fileName]
        if !ProcessExist(pid) {
            RunningScripts.Delete(fileName)
            return false
        }
        return true
    }
    return false
}
