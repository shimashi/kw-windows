@echo off
REM There should be a shortcut to this file located in C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
REM This script must be saved in UTF-8 mode, not "UTF-8 wth BOM"
REM When you save the file in notepad, make sure the "Encoding" option at the bottom of the "Save As" menu has UTF-8 selected
REM Otherwise it will display every single line in the terminal which will not look good.


Echo BEGIN THE BOOTUP BYPASS SCRIPT
Echo.
Echo This script allows unsigned powershell scripts to be run
Echo.
Echo The upcoming command temporarily changes the execution policy to "bypass" for the "C:\KindWorksScripts\Initialize Script.ps1" file to run this unsigned PowerShell script
Echo.
Echo The upcoming command also runs the PowerShell script "C:\KindWorksScripts\Initialize Script.ps1" to configure first-time-use settings
Echo. 

powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy','Bypass','-File','\"C:\KindWorksScripts\Initialize Script.ps1"' -Verb RunAs"

@echo off
Echo The Bootup Bypass Script is complete
Echo.
Echo Press any key to close the window

@echo off
pause >nul
