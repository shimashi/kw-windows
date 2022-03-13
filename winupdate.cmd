
:: Windows update
echo Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force > c:\msupdate.ps1
echo Install-Module PSwindowsUpdate -Force >>  c:\msupdate.ps1
echo Install-WindowsUpdate -MicrosoftUpdate  -Verbose -AcceptAll -AutoReboot >> c:\msupdate.ps1

@powershell -NoProfile -ExecutionPolicy Bypass -Command "& 'c:\msupdate.ps1'"
type %%tmp%%\msupdate.ps1
pause
