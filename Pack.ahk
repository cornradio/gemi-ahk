#Requires AutoHotkey v2.0
; Pack.ahk - 自动化打包脚本 (支持 v1/v2 共存环境)

; 1. 寻找编译器 Ahk2Exe.exe
compilerPath := ""
possibleCompilers := [
    A_ProgramFiles "\AutoHotkey\Compiler\Ahk2Exe.exe",
    A_AppData "\Local\Programs\AutoHotkey\Compiler\Ahk2Exe.exe",
    "C:\Program Files\AutoHotkey\v2\Compiler\Ahk2Exe.exe"
]
for p in possibleCompilers {
    if FileExist(p) {
        compilerPath := p
        break
    }
}

; 2. 寻找 v2 内核 (Base) - 关键步骤
basePath := ""
possibleBases := [
    A_ProgramFiles "\AutoHotkey\v2\AutoHotkey64.exe",
    A_ProgramFiles "\AutoHotkey\v2\AutoHotkey32.exe",
    A_AppData "\Local\Programs\AutoHotkey\v2\AutoHotkey64.exe"
]
for p in possibleBases {
    if FileExist(p) {
        basePath := p
        break
    }
}

if (compilerPath = "" || basePath = "") {
    MsgBox "找不到编译器或 v2 内核。`n编译器: " (compilerPath ? "已找到" : "未找到") "`n内核: " (basePath ? "已找到" : "未找到")
    ExitApp
}

; 3. 设置路径
sourceScript := A_ScriptDir "\Main.ahk"
outputExe := A_ScriptDir "\gemi-ahk.exe"

; 4. 执行带 /base 参数的打包命令
MsgBox "正在启动 v2 编译器进行打包..."
; /in: 源码, /out: 输出, /base: 强制使用 v2 内核
RunWait('"' compilerPath '" /in "' sourceScript '" /out "' outputExe '" /base "' basePath '"')

if FileExist(outputExe) {
    MsgBox "打包成功！`n生成文件: " outputExe "`n使用了内核: " basePath
} else {
    MsgBox "打包失败，请尝试手动运行 Ahk2Exe 并选择 v2 版本的 Base。"
}
