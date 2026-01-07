; Notification.ahk - Subtle OSD notifications for AHK v2

global NotifyGui := unset

ShowNotify(text, duration := 1500) {
    global NotifyGui

    ; Destroy previous if exists to prevent overlap
    if IsSet(NotifyGui)
        NotifyGui.Destroy()

    NotifyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Disabled -DPIScale")
    NotifyGui.BackColor := "000000"

    NotifyGui.SetFont("s14 Bold", "Verdana")
    ; Use a semi-transparent dark theme
    NotifyGui.Add("Text", "w400 h50 cFFFFFF Center +0x200", text) ; 0x200 is center vertical

    NotifyGui.Show("xCenter y20 NoActivate")
    WinSetTransparent(200, NotifyGui.Hwnd)

    SetTimer(() => (IsSet(NotifyGui) ? NotifyGui.Destroy() : ""), -duration)
}
