CoordMode "Mouse", "Screen"

; 1. 获取最新视频 (直接使用环境变量拼接路径)
LatestFile := ""
Loop Files, EnvGet("USERPROFILE") "\Videos\*.*"
    if (LatestFile = "" || FileGetTime(A_LoopFilePath) > FileGetTime(LatestFile))
        LatestFile := A_LoopFilePath

; 2. 复制、执行、打开
if (LatestFile != "") {
    if !DirExist("D:\素材")
        DirCreate "D:\素材"
    FileCopy LatestFile, "D:\素材", 1
    RunWait "ffmpegcovertD.bat", "C:\lightspeed\5\code\ffmpeg"
    Run "D:\素材\压缩"
}