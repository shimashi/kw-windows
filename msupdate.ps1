#Set-ExecutionPolicy -Scope process -ExecutionPolicy Unrestricted   
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSwindowsUpdate -Force
Install-WindowsUpdate -MicrosoftUpdate  -Verbose -AcceptAll -AutoReboot