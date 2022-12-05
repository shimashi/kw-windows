@echo off
SET mypath=%~dp0
@powershell -NoProfile -ExecutionPolicy Bypass "((New-Object System.Net.WebClient).DownloadFile(' https://cdn.novabench.com/novabench.msi', 'c:\novabench.msi'))"

:: Install choco and add choco to path
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
:: Install packages
FOR %%G IN (chocolatey, brave, bitwarden, zoom, 7zip, Audacity, firefox, gimp, handbrake, inkscape, krita,  libreoffice-fresh, adobereader, tux-paint, vlc, googlechrome ) DO (choco upgrade %%G -y)

MsiExec.exe /i 	c:\novabench.msi /qn
cd %mypath%
del /Q  %public%\desktop\*
xcopy /E /Y ".\folders\*"  %public%\desktop\

mkdir c:\kindworks
@powershell -NoProfile -ExecutionPolicy Bypass -Command "powercfg /batteryreport /output 'C:\kindworks\battery-report.html'"
systeminfo > "c:\kindworks\system_info.txt"
@pause 
