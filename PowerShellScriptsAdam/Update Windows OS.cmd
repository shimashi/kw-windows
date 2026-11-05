
REM Windows update

Import-Module PSWindowsUpdate

Get-WindowsUpdate -MicrosoftUpdate

Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

pause
