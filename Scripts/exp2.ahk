; 强制当前逻辑使用屏幕坐标系 (Screen)
CoordMode("Mouse", "Screen")

; 移动鼠标到屏幕绝对坐标起点
MouseMove(504, 643)

; 从当前位置 (504, 643) 拖拽到屏幕坐标 (566, 1101)，速度 10
MouseClickDrag("Left", 504, 643, 566, 1101, 10)

; 等待两秒
Sleep(2000)

; 从当前位置拖拽回屏幕坐标起点，速度 10
MouseClickDrag("Left", 566, 1101, 504, 643, 10)

; 等待两秒
Sleep(2000)