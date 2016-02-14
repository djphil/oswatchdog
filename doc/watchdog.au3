#include <File.au3>
Local $iDelete = FileDelete ("log/watchdog.log")
Local $hFile = FileOpen("log/watchdog.log", 1)
_FileWriteLog($hFile, "[Start WatchDog]")

Local $url_contrat_ini = "inc/watchdog.ini"
Local $sChemin
Local $timeCheck = Int(IniRead($url_contrat_ini, "Watchdog", "refresh", "Default Value"))
Local $listeSection = IniReadSectionNames($url_contrat_ini)

HotKeySet("{ESC}", "Terminate")
_FileWriteLog($hFile, "[Number of Simulator]: " & $listeSection[0]-1)

While 1
    $listeSection = IniReadSectionNames($url_contrat_ini)
    If Not @error Then
        For $i = 1 To $listeSection[0]
            If $listeSection[$i] <> "Watchdog" Then
                $sChemin = IniRead($url_contrat_ini, $listeSection[$i], "path", "Default Value")
            If WinExists ( "C:\Windows\system32\cmd.exe - " & $sChemin ) Then
            Else
                _FileWriteLog($hFile, "[Restart Simulator]: " & $listeSection[$i] & " Path: " & $sChemin )
                Run(@ComSpec & " /c start " & $sChemin)
            EndIf
            EndIf
        Next
    EndIf

    if WinKill("OpenSim") = 1 Then
        msgbox(4096, "", "Auto Close OpenSim Crash Windows", 3)
    EndIf
    Sleep ($timeCheck)
WEnd

Func Terminate()
    _FileWriteLog($hFile, "[Stop WatchDog]")
    FileClose($hFile)
    Exit
EndFunc
