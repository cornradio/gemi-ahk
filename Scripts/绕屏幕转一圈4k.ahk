; 设置坐标模式为屏幕
CoordMode "Mouse", "Screen"

; 1. 移动鼠标到 577, 147 (速度20以便看清轨迹)
MouseMove 577, 147, 20

; 2. 模拟拖动窗口绕 4K 屏幕转一圈
; 按下左键开始拖拽
Click "Down"

; 顺时针轨迹：右上 -> 右下 -> 左下 -> 返回起点
MouseMove 3840, 147, 20   ; 移至右边缘
MouseMove 3840, 2160, 20  ; 移至右下角
MouseMove 0, 2160, 20     ; 移至左下角
MouseMove 0, 147, 20      ; 移至左边缘起始高度
MouseMove 577, 147, 20    ; 回到初始点

; 松开左键
Click "Up"

; 3. 等待两秒
Sleep 2000