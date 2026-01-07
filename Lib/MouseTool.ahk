; MouseTool.ahk - Mouse Position Locator (v2)

global MouseGui := unset
global MouseToolGUI_Active := false

MouseTool_Show() {
    global MouseGui, MouseToolGUI_Active
    
    if MouseToolGUI_Active {
        MouseGui.Show()
        return
    }
    
    MouseGui := Gui("+AlwaysOnTop +ToolWindow", "Mouse Locator")
    MouseGui.SetFont("s10", "Segoe UI")
    MouseGui.CoordDisplay := MouseGui.Add("Text", "x10 y10 w200", "X: 0, Y: 0")
    MouseGui.Add("Text", "x10 y40 w220", "Hotkey: [Alt + C] to copy coords")
    MouseGui.Add("Button", "x10 y70 w100 h30", "Copy Manually").OnEvent("Click", (*) => MouseTool_Copy())
    
    MouseGui.OnEvent("Close", (*) => MouseGui.Hide())
    MouseGui.Show("w240 h110")
    MouseToolGUI_Active := true
    
    SetTimer(MouseTool_Update, 100)
}

MouseTool_Update() {
    global MouseGui, MouseToolGUI_Active
    if !WinExist("Mouse Locator") {
        SetTimer(MouseTool_Update, 0)
        return
    }
    MouseGetPos(&x, &y)
    MouseGui.CoordDisplay.Value := "X: " x ", Y: " y
}

MouseTool_Copy() {
    MouseGetPos(&x, &y)
    A_Clipboard := x ", " y
    ToolTip("Copied: " x ", " y)
    SetTimer(() => ToolTip(), -1000)
}

#HotIf WinActive("Mouse Locator") or (IsSet(MouseGui) and MouseGui.Visible)
!c:: {
    MouseTool_Copy()
}
#HotIf
