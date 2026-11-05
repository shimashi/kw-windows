
REM Windows OS Update Script
REM The purpose of this script is to update the Windows operating system to the most recent version


powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
"Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\KindWorksScripts\Initialize Script.ps1""'"

pause
