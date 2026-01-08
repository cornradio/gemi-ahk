#Requires AutoHotkey v2.0
#NoTrayIcon
DetectHiddenWindows(true)

MainHWND := 396298

Loop 1 {
    ; --- USER CODE START ---
#Requires AutoHotkey v2.0
#SingleInstance Off

; --- Create Menu ---
NetMenu := Menu()

; --- Section: IP Info & Leak Tests ---
NetMenu.Add("IP.skk.moe (IP CN/Oter/Ping Speed)", (*) => Run("https://ip.skk.moe"))
NetMenu.Add("IPPure.com (IP Human/Bot)", (*) => Run("https://ippure.com"))
NetMenu.Add("Ping0.cc (IP IDC/Home/Location)", (*) => Run("https://ping0.cc"))
NetMenu.Add("DNS Leak Test (BrowserLeaks)", (*) => Run("https://browserleaks.com/dns"))
NetMenu.Add("DNSLog.org (DNS Logging)", (*) => Run("https://dnslog.org/"))
NetMenu.Add("IP-searching (bad ip detect)", (*) => Run("http://8.153.164.13/tool/IP.html"))

NetMenu.Add() ; Separator

; --- Section: Speed Test & All-in-One ---
NetMenu.Add("IPCheck.ing (IP & Speed Test)", (*) => Run("https://ipcheck.ing/#/"))
NetMenu.Add("Speedtest.cn (China Mainland Speedtest)", (*) => Run("https://www.speedtest.cn/"))
NetMenu.Add("Speedtest.net (Global Speedtest)", (*) => Run("https://www.speedtest.net"))
NetMenu.Add() ; Separator

; --- Section: Advanced Tools ---
NetMenu.Add("Ping.pe (Global Latency/Loss)", (*) => Run("https://ping.pe"))
NetMenu.Add("Check-Host (Global Availability)", (*) => Run("https://check-host.net"))
NetMenu.Add() ; Separator

NetMenu.Add(" Mic Test (WebcamMicTest)", (*) => Run("https://webcammictest.com/check-mic.html"))
NetMenu.Add(" Frame Rate Test (TestUFO)", (*) => Run("https://www.testufo.com/framerates#count=3&pps=960&hdr=0"))
NetMenu.Add(" Keyboard Test (Ratatype)", (*) => Run("https://www.ratatype.com/keyboard-test/"))
NetMenu.Add(" Gamepad Test (HardwareTester)", (*) => Run("https://hardwaretester.com/gamepad"))
; --- Section: Exit ---
NetMenu.Add("Exit Menu", (*) => ExitApp())

; Show menu at mouse cursor position
NetMenu.Show()

; Exit script immediately after menu is closed or item is selected
ExitApp()
    ; --- USER CODE END ---

    if WinExist('ahk_id ' MainHWND)
        try SendMessage(0x401, DllCall('GetCurrentProcessId'), A_Index, , 'ahk_id ' MainHWND, , , , 500)
}