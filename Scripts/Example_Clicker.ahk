#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; 1. Open Screenshot Tool (Ctrl + 1)
Send("^1")
Sleep(250)

; 2. Drag to select area
MouseMove(5, 179)
Sleep(80)
MouseClickDrag("Left", 5, 179, 619, 1064, 0)
Sleep(300)

;shift + c
Send("+c")
Sleep(1500)

MouseMove(5, 179)
Sleep(80)
MouseClick("Left", 5, 179)
Sleep(300)

Send("^v")
Sleep(200)
Send("{Enter}----------{Enter}")
Sleep(200)

ToolTip("Task Completed")
Sleep(1000)