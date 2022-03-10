@echo off
@powershell -NoProfile -ExecutionPolicy Bypass "((New-Object System.Net.WebClient).DownloadFile(' https://cdn.novabench.com/novabench.msi', 'c:\novabench.msi'))"

:: Install choco and add choco to path
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
:: Install packages
FOR %%G IN (chocolatey, zoom, 7zip, Audacity, firefox, gimp, handbrake, inkscape, krita, libreoffice, adobereader, tux-paint, vlc, googlechrome ) DO (choco upgrade %%G -fy)

MsiExec.exe /i 	c:\novabench.msi /qn
del /Q  %public%\desktop\*
xcopy /E /Y ".\folders\*"  %public%\desktop\
@pause 
