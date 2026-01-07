#Requires AutoHotkey v2.0
#NoTrayIcon
DetectHiddenWindows(true)

MainHWND := 4000356

Loop {
    ; --- USER CODE START ---
; 设置坐标模式为屏�?
CoordMode "Mouse", "Screen"

; 1. 移动鼠标�?577, 147 (速度20以便看清轨迹)
MouseMove 577, 147, 20

; 2. 模拟拖动窗口�?4K 屏幕转一�?
; 按下左键开始拖�?
Click "Down"

; 顺时针轨迹：右上 -> 右下 -> 左下 -> 返回起点
MouseMove 3840, 147, 20   ; 移至右边�?
MouseMove 3840, 2160, 20  ; 移至右下�?
MouseMove 0, 2160, 20     ; 移至左下�?
MouseMove 0, 147, 20      ; 移至左边缘起始高�?
MouseMove 577, 147, 20    ; 回到初始�?

; 松开左键
Click "Up"

; 3. 等待两秒
Sleep 2000
    ; --- USER CODE END ---

    if WinExist('ahk_id ' MainHWND)
        try SendMessage(0x401, DllCall('GetCurrentProcessId'), A_Index, , 'ahk_id ' MainHWND, , , , 500)
}