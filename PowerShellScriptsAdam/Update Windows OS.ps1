Write-Host -f Yellow "`n Starting the script `n"


##  Remove all restrictions on script execution.  This only applies to the current PowerShell session, and script running permissions will go back to normal after the script finished.
##  Also suppresses confirmation prompts so the user doesn't have to click "yes to all" every time this script is run.

## Set the execution polity once to allow these scripts to run
Write-Host -F White "`n Set-ExecutionPolicy Bypass"
try 
{
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    Write-Host -F Green "`n Set-ExecutionPolicy Bypass executed fine"
}

 catch
 {
    Write-Warning "`n Set-ExecutionPolicy Bypass -Scope Process -Force DID NOT WORK!"
 }


##  Center the powershell window in the middle of the screen.
##  This is necessary so the PowerShell window will fit 
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$width = 1000
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


try
{
    ## This needs admin rights to run"
    Write-Host -F White "`n Delete the broken module directory to clear out the corrupted files"
    
    Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host -F Green "`n Delete the broken module directory to clear out the corrupted files executed properly, double checking..."
    
    
    Get-Module -ListAvailable PSWindowsUpdate
    Write-Host -F Green "`n OK, Delete the broken module directory has been properly verified, it worked"
}
catch
{
    Write-Warning "`n Deleting the broken module directory DID NOT WORK!"
}

try
{
    Write-Host -f White "`n Updating security protocols and package providers to download modules securely"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Write-Host -f Green "`n Updating security protocols and package providers to download modules securely worked properly"
}
catch
{
Write-Warning "`n Updated security protocols and package provider DID NOT WORK!"
}


try
{
   write-host -f White "`n Install the module directly from the official PowerShell Gallery for all users"
   Install-Module -Name PSWindowsUpdate -Force -Scope AllUsers -AllowClobber
   write-host -f Green "`n Installing the module directly from the official PowerShell Gallery for all users worked properly"

   write-host -f White "`n Check that the required .dll file now exists in the module directory"
   Test-Path "C:\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate\*\PSWindowsUpdate.dll"
   write-host -f Green "`n The required .dll file now exists in the module directory"
 }
catch
{
    Write-Warning "`n Install the module directly from the official PowerShell Gallery DID NOT WORK!"
}












try {
            Write-host -f White "`n`n Import the PSWindowsUpdate module"
            Import-Module PSWindowsUpdate -Force
            Write-Host -F Green "`n The PSWindowsUpdate module was imported properly"
            
    }

catch 
    {
            Write-Warning "`n`n The PSWindowsUpdate modeule was not imported propery!"
    }


Read-Host "`n `n Press Enter to continue"

try {
            Write-Host -F White "`n Check the PSWindowsUpdate command"
            Get-Command -Module PSWindowsUpdate
            Write-Host -F Green "`n Get PSWindowsUpdate command module executed properly"
            
            Write-Host -F Green "`n You should see a list of cmdlets display in the console without any error messages."

    }

catch 
    {
            Write-Warning "`n Get-Command -Module PSWindowsUpdate was CAUGHT!"
    }



    

Read-Host "`n `n Press Enter to continue"




try {
            Write-Host -F White "`n Run the Get-WindowsUpdate -MicrosoftUpdate command"
            Get-WindowsUpdate -MicrosoftUpdate
            Write-Host -F Green "`n Get-WindowsUpdate -MicrosoftUpdate executed properly"

    }

catch 
    {
            Write-Warning "`n Get-WindowsUpdate -MicrosoftUpdate did not run properly!"
    }



Read-Host "`n `n Press Enter to continue"

try {
            Write-Host -F White "`n Run the Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot command, this may take awhile"
            Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot
            Write-Host -F Green "`n Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot executed properly"

    }

catch 
{
    Write-Warning "`n Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot did not run properly!"
}

Write-Host -F Yellow "`n End the Update Windows OS.ps1 script"
