@echo off
SET mypath=%~dp0
@powershell -NoProfile -ExecutionPolicy Bypass "((New-Object System.Net.WebClient).DownloadFile(' https://cdn.novabench.com/novabench.msi', 'c:\novabench.msi'))"

:: Install choco and add choco to path
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
:: Install packages
FOR %%G IN (chocolatey,  zoom, 7zip, Audacity, firefox, gimp, handbrake, inkscape, krita,  libreoffice-fresh, adobereader, tux-paint, vlc ) DO (choco upgrade %%G -y)

choco upgrade googlechrome -y --ignore-checksums

MsiExec.exe /i 	c:\novabench.msi /qn
cd %mypath%
del /Q  %public%\desktop\*
xcopy /E /Y ".\folders\*"  %public%\desktop\

mkdir c:\kindworks
@powershell -NoProfile -ExecutionPolicy Bypass -Command "powercfg /batteryreport /output 'C:\kindworks\battery-report.html'"
systeminfo > "c:\kindworks\system_info.txt"

:: Remove One Drive
TASKKILL /f /im OneDrive.exe
%systemroot%\SysWOW64\OneDriveSetup.exe /uninstall

@pause 
