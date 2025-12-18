@echo off

REM This script kicks off the InstallOrUpdate powershell script, in administrative mode, to install several apps on the user's computer
REM This script must be saved in UTF-8 mode, not "UTF-8 wth BOM"
REM When you save the file in notepad, make sure the "Encoding" option at the bottom of the "Save As" menu has UTF-8 selected
REM Otherwise it will display every single line in the terminal which will not look good.

Echo This script will install several applications, and will update them if they are already installed
Echo.

REM I removed '-NoExit', after Argumentlist
powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy','Bypass','-File','\"C:\KindWorksScripts\Update Apps.ps1"' -Verb RunAs"

Echo Script complete.  You can run this script again in the future to update your apps

pause