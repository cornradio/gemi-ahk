; FileHandler.ahk - Handle file list

FileHandler_GetScripts() {
    global ScriptDir
    scripts := []
    Loop Files, ScriptDir "\*.ahk" {
        scripts.Push(A_LoopFileName)
    }
    return scripts
}

FileHandler_Delete(fileName) {
    global ScriptDir
    try FileDelete(ScriptDir "\" fileName)
}
