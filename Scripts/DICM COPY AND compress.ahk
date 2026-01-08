; ==============================================================================
; 程序名称：DJI 视频素材自动化处理工具
; 功能说明：
; 1. 自动扫描指定目录 (E:\DCIM\DJI_001) 中的视频文件。
; 2. 自动筛选后缀名为 mp4, mov, avi, mkv 的视频，忽略图片及预览文件。
; 3. 按拍摄时间从新到旧排序，并列出带有 [时间]、[文件名]、[大小] 的选单。
; 4. 用户选择后，调用 Windows 原生进度条将视频复制到 D:\素材。
; 5. 自动执行 ffmpeg 批处理脚本进行压制处理。
; 6. 处理完成后自动打开“压缩”文件夹查看结果。
; ==============================================================================
#Requires AutoHotkey v2.0
CoordMode "Mouse", "Screen"

; --- 配置区域 ---
SourceDir := "E:\DCIM\DJI_001"
TargetDir := "D:\素材"
BatPath := "C:\lightspeed\5\code\ffmpeg"
; ----------------

if !DirExist(SourceDir) {
    MsgBox "找不到源文件夹: " SourceDir
    return
}

; 1. 获取文件列表并【筛选视频格式】
FileList := []
Loop Files, SourceDir "\*.*" {
    ; 只允许 mp4, mov, avi, mkv (不区分大小写)
    if !RegExMatch(A_LoopFileExt, "i)^(MP4|mp4|mov|avi|mkv)$")
        continue

    ; 获取大小 (换算为 MB)
    SizeMB := Round(FileGetSize(A_LoopFilePath) / 1024 / 1024, 1)
    ; 获取时间并格式化 (MM-DD HH:mm)
    TimeStr := FormatTime(FileGetTime(A_LoopFilePath), "MM-dd HH:mm")
    
    FileList.Push({
        Path: A_LoopFilePath, 
        Name: A_LoopFileName, 
        Time: FileGetTime(A_LoopFilePath),
        Size: SizeMB,
        DateDisplay: TimeStr
    })
}

; 2. 排序 (从新到旧)
QuickSort(FileList, (a, b) => b.Time > a.Time ? 1 : b.Time < a.Time ? -1 : 0)

; 3. 创建选单
if (FileList.Length = 0) {
    MsgBox "No video files found in the folder."
    return
}

VideoMenu := Menu()
MaxItems := 20 

Loop Min(FileList.Length, MaxItems) {
    F := FileList[A_Index]
    MenuText := "[" F.DateDisplay "]  " F.Name "  (" F.Size " MB)"
    VideoMenu.Add(MenuText, ProcessVideo.Bind(F.Path, F.Name))
}

VideoMenu.Show()

; --- 处理函数 ---
ProcessVideo(FilePath, FileName, *) {
    if !DirExist(TargetDir)
        DirCreate TargetDir
    
    try {
        ; Windows 原生进度条复制
        shell := ComObject("Shell.Application")
        destFolder := shell.NameSpace(TargetDir)
        
        ToolTip "正在准备复制: " FileName
        ; 16: 全部响应为“是”, 512: 显示进度条
        destFolder.CopyHere(FilePath, 16 | 512)
        ToolTip ""
        
        ; 执行 BAT
        ; 如果你看不到窗口，请把下面的 /c 改成 /k 停留查看错误
        RunWait A_ComSpec ' /c "ffmpegcovertD.bat"', BatPath
        
        ; 打开结果文件夹
        if DirExist(TargetDir "\压缩")
            Run TargetDir "\压缩"
        else
            Run TargetDir
            
    } catch Error as e {
        MsgBox "操作失败:`n" e.Message
    }
}

; 排序辅助函数
QuickSort(Arr, CompareFunc) {
    for i in Arr {
        for j in Arr {
            if (A_Index < Arr.Length && CompareFunc(Arr[A_Index], Arr[A_Index+1]) > 0) {
                temp := Arr[A_Index], Arr[A_Index] := Arr[A_Index+1], Arr[A_Index+1] := temp
            }
        }
    }
}