@echo off
REM There should be a shortcut to this file located in C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
REM This script must be saved in UTF-8 mode, not "UTF-8 wth BOM"
REM When you save the file in notepad, make sure the "Encoding" option at the bottom of the "Save As" menu has UTF-8 selected
REM Otherwise it will display every single line in the terminal which will not look good.

Echo This script must be run at startup to allow unsigned powershell scripts to be run
Echo.
Echo The upcoming command temporarily changes the execution policy to "bypass" for the "C:\KindWorksScripts\Initialize Script.ps1" file to run this unsigned PowerShell script
Echo The upcoming command also runs the PowerShell script "C:\KindWorksScripts\Initialize Script.ps1" to configure first-time-use settings
Echo. 

REM OLD delete me - powershell -ExecutionPolicy Bypass -File "C:\KindWorksScripts\Initialize Script.ps1"

powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy','Bypass','-File','\"C:\KindWorksScripts\Initialize Script.ps1"' -Verb RunAs"

@echo off
Echo Press any key to close the window of the Bootup Bypass Script

@echo off
pause >nul