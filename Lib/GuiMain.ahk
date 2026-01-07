; GuiMain.ahk - Main Interface (v2)

global MainGui, MainLV, CoordText, LoopCountInput, HotkeyChoice, BtnStart, BtnPause, BtnStop, ListHeader

GuiMain_Create() {
    global MainGui, MainLV, CoordText, ScriptDir, LoopCountInput, HotkeyChoice, BtnStart, BtnPause, BtnStop, ListHeader,
        HotkeyMode

    MainGui := Gui("+Resize", "gemi-ahk")
    MainGui.SetFont("s10", "Segoe UI")

    ; Top Toolbar
    MainGui.Add("Button", "x10 y10 w100 h30", "Refresh List").OnEvent("Click", (*) => GuiMain_Refresh())
    MainGui.Add("Button", "x115 y10 w100 h30", "Set Directory").OnEvent("Click", (*) => GuiMain_SetDir())
    MainGui.Add("Button", "x220 y10 w100 h30", "Open Folder").OnEvent("Click", (*) => GuiMain_OpenDir())

    ; Hotkey Mode Selector
    MainGui.Add("Text", "x330 y16", "Hotkeys:")
    HotkeyChoice := MainGui.Add("DropDownList", "x390 y13 w80 Choose1", ["F7-F10", "F1-F4"])
    HotkeyChoice.Text := HotkeyMode
    HotkeyChoice.OnEvent("Change", GuiMain_OnHotkeyChange)

    ; Links Toolbar
    MainGui.SetFont("cBlue underline")
    MainGui.Add("Text", "x480 y18", "[Gemini]").OnEvent("Click", (*) => Run("https://gemini.google.com/"))
    MainGui.Add("Text", "x535 y18", "[AHKv2]").OnEvent("Click", (*) => Run("https://www.autohotkey.com/v2/"))
    MainGui.Add("Text", "x590 y18", "[Git]").OnEvent("Click", (*) => Run("https://github.com/cornradio/gemi-ahk"))
    MainGui.SetFont("Norm cDefault")

    ; List View
    ListHeader := MainGui.Add("Text", "x10 y50", "Script List (Ready)")
    MainLV := MainGui.Add("ListView", "x10 y75 w620 h250", ["Script Name", "Status", "PID", "Count", "Target"])
    MainLV.ModifyCol(1, 240)
    MainLV.ModifyCol(2, 100)
    MainLV.ModifyCol(3, 80)
    MainLV.ModifyCol(4, 80)
    MainLV.ModifyCol(5, 80)
    MainLV.OnEvent("DoubleClick", (lv, row) => GuiMain_Start())

    ; Loop Settings
    MainGui.Add("Text", "x10 y335", "Loop Quantity (0 = Infinite):")
    LoopCountInput := MainGui.Add("Edit", "x180 y332 w80 h25", "0")
    MainGui.Add("UpDown", "vMyUpDown Range0-999999", 1)

    ; Coordinate & Status Display
    MainGui.SetFont("s11 Bold", "Segoe UI")
    MainGui.Add("GroupBox", "x10 y360 w260 h65", "Mouse Tracker")
    CoordText := MainGui.Add("Text", "x20 y385 w240 cRed", "X: 0, Y: 0")
    MainGui.SetFont("Norm s10")

    ; Control Bar with Dynamic Labels
    BtnStart := MainGui.Add("Button", "x280 y370 w110 h45", "START")
    BtnStart.OnEvent("Click", (*) => GuiMain_Start())

    BtnPause := MainGui.Add("Button", "x400 y370 w110 h45", "PAUSE")
    BtnPause.OnEvent("Click", (*) => GuiMain_Pause())

    BtnStop := MainGui.Add("Button", "x520 y370 w110 h45", "STOP")
    BtnStop.OnEvent("Click", (*) => GuiMain_Stop())

    MainGui.OnEvent("Close", (*) => ExitApp())
    OnMessage(0x401, UpdateIterationCount)

    GuiMain_UpdateHotkeyLabels()
    GuiMain_Refresh()
    MainGui.Show("w640 h440")

    SetTimer(GuiMain_UpdateStatus, 1000)
    SetTimer(GuiMain_UpdateMouse, 100)
}

GuiMain_OnHotkeyChange(*) {
    global HotkeyChoice, HotkeyMode
    HotkeyMode := HotkeyChoice.Text
    Config_SaveHotkeyMode(HotkeyMode)
    GuiMain_UpdateHotkeyLabels()
    Reload() ; Reload to apply new global hotkeys
}

GuiMain_UpdateHotkeyLabels() {
    global HotkeyMode, BtnStart, BtnPause, BtnStop, ListHeader
    if (HotkeyMode = "F1-F4") {
        BtnStart.Text := "F1`nSTART"
        BtnPause.Text := "F2`nPAUSE"
        BtnStop.Text := "F3`nSTOP"
        ListHeader.Value := "Script List (F1:Start, F2:Pause, F3:Stop, F4:Copy)"
    } else {
        BtnStart.Text := "F7`nSTART"
        BtnPause.Text := "F8`nPAUSE"
        BtnStop.Text := "F9`nSTOP"
        ListHeader.Value := "Script List (F7:Start, F8:Pause, F9:Stop, F10:Copy)"
    }
}

UpdateIterationCount(wParam, lParam, msg, hwnd) {
    global MainLV
    pid := wParam
    count := lParam
    loop MainLV.GetCount() {
        if (MainLV.GetText(A_Index, 3) = String(pid)) {
            MainLV.Modify(A_Index, , , , , count)
            break
        }
    }
}

GuiMain_Refresh() {
    global MainLV
    MainLV.Delete()
    scripts := FileHandler_GetScripts()
    for name in scripts {
        status := ScriptManager_IsRunning(name) ? "Running" : "Stopped"
        pid := RunningScripts.Has(name) ? RunningScripts[name] : "-"
        MainLV.Add(, name, status, pid, "0", "-")
    }
}

GuiMain_UpdateStatus() {
    global MainLV
    loop MainLV.GetCount() {
        appName := MainLV.GetText(A_Index, 1)
        isRunning := ScriptManager_IsRunning(appName)
        status := isRunning ? "Running" : "Stopped"
        pid := RunningScripts.Has(appName) ? RunningScripts[appName] : "-"

        oldStatus := MainLV.GetText(A_Index, 2)
        if (oldStatus != status) {
            MainLV.Modify(A_Index, , , status, pid)
            if (!isRunning) {
                MainLV.Modify(A_Index, , , , , "0", "-")
            }
        }
    }
}

GuiMain_UpdateMouse() {
    global CoordText
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    CoordText.Value := "X: " x ", Y: " y
}

GuiMain_Start() {
    global LoopCountInput
    row := MainLV.GetNext()
    if !row
        return
    name := MainLV.GetText(row, 1)
    target := LoopCountInput.Value
    if RunningScripts.Has(name)
        ScriptManager_Stop(name)
    pid := ScriptManager_Start(name, target)
    if (pid) {
        MainLV.Modify(row, , , "Running", pid, "0", (target = "0" ? "∞" : target))
    }
}

GuiMain_Stop() {
    row := MainLV.GetNext()
    if !row
        return
    name := MainLV.GetText(row, 1)
    ScriptManager_Stop(name)
    MainLV.Modify(row, , , "Stopped", "-", "0", "-")
}

GuiMain_Pause() {
    row := MainLV.GetNext()
    if !row
        return
    name := MainLV.GetText(row, 1)
    ScriptManager_Pause(name)
}

GuiMain_CopyCoord() {
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    A_Clipboard := x ", " y
    ToolTip("Copied: " x ", " y)
    SetTimer(() => ToolTip(), -1000)
}

GuiMain_SetDir() {
    global ScriptDir
    newDir := DirSelect("*" ScriptDir, 1, "Select script directory")
    if (newDir != "") {
        Config_SaveScriptDir(newDir)
        GuiMain_Refresh()
    }
}

GuiMain_OpenDir() {
    global ScriptDir
    Run('explorer "' ScriptDir '"')
}
