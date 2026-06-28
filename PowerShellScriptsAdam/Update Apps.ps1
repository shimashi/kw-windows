## This script installs a bunch of applications using Chocolatey.
## If the applications are already installed, the script will update the applications to the latest version

## The one application that couldn't be installed using Chocolately is Novabench.  This script only installs Novabench.  It does not update Novabench.

clear


##  Center the powershell window in the middle of the screen.
##  This is necessary so the PowerShell window will fit 
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$width = 800
$height = 600
$left = ($screen.Width - $width) / 2
$top = ($screen.Height - $height) / 2

$hwnd = Get-Process -Id $PID | ForEach-Object { $_.MainWindowHandle }
$null = Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
"@
[Win32]::MoveWindow($hwnd, $left, $top, $width, $height, $true)


clear

Write-host -f Cyan "`n Starting Application Update Script `n"

## Since PowerShell must be running in administrative mode to run this script, let's first check to make sure you're in administrative mode
## Note that if you called this script using the Update My Apps.cmd command prompt script, then administrative mode should already be turned on
Write-host -f white "`n Checking to make sure this script is being run in administrative mode `n"

# This "if" statement gets the current user's identity and checks to see if its roles have administrative rights

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host -f red "`n This script is not running as Administrator.  Exiting the script.`n"
    
    exit
} else {
    Write-Host -f white "`n This script is running in Administrator mode.  Proceeding with the script `n"
}



##Make sure you're on the latest version of Chocolatey

Write-host -f Yellow "`n`nCHOCOLATEY `n"
Write-host -f Green "`n Checking to see if there is an upgrade for Chocolately `n"
choco upgrade chocolatey
Write-host -f Green "`n Chocolately upgrade completed"


## Upgrade all applications.  BTW is the application is missing, this will also re-install the application


## Define an array of the applications you want to install

$applications=@("7zip", "adobereader", "AvastFreeAntivirus", "Audacity", "firefox", "gimp", "handbrake", "inkscape", "krita", "libreoffice-fresh", "tux-paint", "vlc", "zoom")



## Go through each application and install or upgrade it with Chocolatey

foreach ($application in $applications) {
    Write-host -f Yellow "`n`n$application `n"
    Write-host -f Green "`n Checking to make sure you're on the latest version of $application by checking for an upgrade `n"
    choco upgrade $application -y
    Write-host -f Green "`n $application upgrade completed"
}



## Check to see if Novabench is already installed by checking for the file "C:\Program Files\Novabench\Novabench.exe"

Write-host -f Yellow "`n Novabench `n"
if (Test-Path "C:\Program Files\Novabench\Novabench.exe") 
{
    Write-Host -f white "`n Novabench has already been installed."
} 
else 
{
    Write-Host -f green "`n Novabench has not been installed.  Installing it now"
    
    ##Download Novabench

    Write-Host -f cyan "`n Downloading Novabench from the Novabench CDN"
    Invoke-WebRequest -Uri 'https://cdn.novabench.com/novabench.msi' -OutFile 'C:\novabench.msi'

    ## Install NovaBench silently

    Write-Host -f cyan "`n Download complete.  Begin installation of Novabench"
    Start-Process "msiexec.exe" -ArgumentList "/i", "C:\novabench.msi", "/qn" -Wait
    Write-Host -f white "`n Installation of Novabench is complete."
}


write-host -F Cyan "`nEnd of application installation and upgrade script. `n"

write-host -F Green "Press any key to exit..."
[void][System.Console]::ReadKey($true)

exit
