
## The Initialize Script configures several settings to prepare your computer for the installation of several applications
## Once this is done running, you can run the InstallOrUpdate.ps1 script which will install several apps.
## You have to run this script in an administrative shell.  The bootup_bypass_script.cmd script takes care of that for the user.
## Ideally, you would only need to run this script once.  However there is a commented-out section that will enable this script to run automatically upon startup of Windows each time.

clear


##  Temporary testing code Adam is revamping some of these scripts 6-28-2026
$tempchoice = Read-Host "Press N to cancel now if you want"

If($tempchoice -eq 'N' -or %tempchoice -eq 'n') {
Write-Host "'n Ending this script"
exit
}

Write-Host "'n Continuing script"



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



Write-host -f Yellow "`n Start Initialization Script"

##  Remove all restrictions on script execution.  This only applies to the current PowerShell session, and script running permissions will go back to normal after the script finished.
##  Also suppresses confirmation prompts so the user doesn't have to click "yes to all" every time this script is run.

Set-ExecutionPolicy Bypass -Scope Process -Force;




## Check to see if Chocolatey is installed, and if not, install it

Write-host -f Green "`n Checking to see if Chocolately is already installed on this computer"
if (Test-Path "C:\ProgramData\chocolatey\bin\choco.exe") 
{
    Write-Host -f white "`n Chocolatey is already installed on this computer.  Proceeding with the rest of the script."
} 
else 
{
    Write-Host -f white "`n Chocolately is not already installed.  Installing it now"
    write-host -f White "`n Run commands needed to prepare to use Chocolatey"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}






## Check to see if OneDrive is uninstalled.  If it is installed, then run the command to remove it.

Write-host -f green "`n Check to see if Microsoft OneDrive is installed, and if it is, remove it."
If (Get-AppxPackage -Name "*OneDrive*")
{
    Write-Host -f White "`n OneDrive does not need to be removed... proceeding with script"
}
else
{
    ## This will run if OneDrive is already installed.  It will remove OneDrive.

    Write-Host -f green "`n OneDrive is present and needs to be uninstalled... Accept any UAC prompts about OneDrive to remove it"
    C:\Windows\System32\OneDriveSetup.exe /uninstall
    Write-Host -f White "`n OneDrive has been removed."
}




## Set the Time Zone to the East Coast of the United States

# Check to see if the time zone is already set to the East Coast

Write-host -f green "`n Check to see if the time zone is set to Eastern Time (US & Canada)."
if ((Get-TimeZone).DisplayName -like "*Eastern Time (US & Canada)" ) 
    {
        Write-Host -f white "`n The time zone is already set to the Eastern Time (US & Canada).  Proceeding with script"
    } 
else
    {
    Write-Host -f cyan "`n You need to enter the time zone manually, and enable automatic time zone setting. Launching time zone settings now..."
    start ms-settings:dateandtime
    }

##  The next section is only necessary if we want this initialization script to run EVERY time the user boots up their system
##  To do this, we need to verify that a shortcut to this script lives in their auto-startup folder C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup

#Write-host -f green "`n Check to see if a shortcut to the bootup bypass CMD script exists in this users startup folder."
#if (Test-Path "C:\Users\$env:USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\bootup_bypass_script.cmd - Shortcut.lnk") 
#{
#    Write-Host -f white "`n A shortcut to the bootup bypass script already exists in this users startup folder.  Proceeding with script"
#} 
#else 
#{
#    Write-Host -f cyan "`n A shortcut to the bootup bypass script does not exist in this users startup folder.  Creating a shortcut now"
#    
#    #define the path to the bypass script
#    $targetPath = "C:\KindWorksScripts\bootup_bypass_script.cmd"
#
#    # Create a .lnk shortcut in the Startup folder
#    $shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\bootup_bypass_script.cmd - Shortcut.lnk"
    
#    # Point the shortcut link to the bypass script.
#    $WshShell = New-Object -ComObject WScript.Shell
#    $shortcut = $WshShell.CreateShortcut($shortcutPath)
#    $shortcut.TargetPath = $targetPath
    
#    # Now we have to define the properties of the shortcut itself
    
#    # Set the working directory of the shortcut to the bypass script's folder.
#    $shortcut.WorkingDirectory = Split-Path $targetPath
    
#    # Use a normal window style (you can change this if needed).
#    $shortcut.WindowStyle = 1
#    $shortcut.Save()

#}

## Place a shortcut to the script to install and update apps on the current user's Desktop
## This way, whenever a user wants to update all applications, they just need to run the script

Write-host -f green "`n Check to see if a shortcut to the Update Apps CMD script exists on this users desktop."
if (Test-Path "C:\Users\$env:USERNAME\Desktop\Update Apps.cmd.lnk") 
{
    Write-Host -f white "`n A shortcut to the Update Apps CMD script already exists on the users Desktop.  Proceeding with script"
} 
else 
{
    Write-Host -f cyan "`n A shortcut to the Update Apps CMD script does not exist on the users Desktop.  Creating a shortcut now"
    
    #define the path to the update script
    $targetPath = "C:\KindWorksScripts\Update Apps.cmd"

    ## Create a .lnk shortcut on the Desktop 
    $shortcutPath = "C:\Users\$env:USERNAME\Desktop\Update Apps.cmd.lnk"
    
    # Point the shortcut link to the update script.
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    
    # Now we have to define the properties of the shortcut itself
    
    # Set the working directory of the shortcut to the bypass script's folder.
    $shortcut.WorkingDirectory = Split-Path $targetPath
    
    #Use a normal window style (you can change this if needed).
    $shortcut.WindowStyle = 1
    $shortcut.Save()

}


## Define an array of the applications you want to install

$applications=@("7zip", "adobereader", "AvastFreeAntivirus", "Audacity", "firefox", "gimp", "handbrake", "inkscape", "krita", "libreoffice-fresh", "tux-paint", "vlc", "zoom")

## Removing "googlechrome",  from the above list of apps to install because it doesn't work with Chocolatey as of 11/2/2025

## Go through each application and install it with Chocolatey

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
    Write-Host -f white "`n Novabench has already been installed. `n"
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

## Now let's change the battery settings to those listed in the KindWorks.pow file, and make sure the command executed sucesssfully
powercfg /import "C:\KindWorksScripts\KindWorks.pow"

if ($LASTEXITCODE -eq 0) {
    Write-Host -F white "`n`n The power scheme was configured successfully."
} else {
    Write-Host -f magenta "'n`n The power scheme was not configured successfully. Exit code: $LASTEXITCODE"
}

## Now change the file view settings to show file extensions
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    Write-Host -F white "`n File extensions are now visible."
} catch {
    Write-Host -F Magenta "Failed to make file extensions visible: $($_.Exception.Message)"
}




## Now change the file view settings to show hidden files
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
    Write-Host -F white "`n Hidden files are now visible."
} catch {
    Write-Host -F Magenta "Failed to make hidden files visible: $($_.Exception.Message)"
}


## Force a restart of file explorer to see the last few settings take affect.  This command may pop up a file explorer window.
Stop-Process -Name explorer -Force
Start-Process explorer.exe

## Adjust default file saving formats in LibreOffice
## Only run the next portion of code if LibreOffice has already been installed
if (Test-Path "C:\Program Files\LibreOffice\program\soffice.exe") 
{
    Write-Host -f white "`n LibreOffice is installed.`n"
    # Ask the user if they want to make these changes now, or skip configuring LibreOffice default file format configurations for now
    $LibreOfficeChangeNow = Read-Host "Do you want to launch LibreOffice now and adjust default file saving formats? (y/n)"
    
    if ($LibreOfficeChangeNow -eq "y")
    {
        Write-Host -F green "`n Launching LibreOffice to adjust deafult file saving formats"
        Start-Process "C:\Program Files\LibreOffice\program\soffice.exe"
        Write-Host -f cyan "`n`
     Go to Tools-> Options-> Load/Save-> General-> Default File Formats and ODF Settings `n`
     Change Document type to Text documents (writer) and change Always save as to Word 2010 *.docx `n`
     Change Document type to Spreadsheets (Calc) and change Always save as to *.xlsx `n`
     Change Document type to Presentations (Impress) and change Always save as to *.pptx `n`
     Click OK and close LibreOffice"

        Read-Host "`n Press Enter to continue"
    } 
    else
    {
        Write-Host -F white "`n User chose not to proceed with LibreOffice configuration."
    }
} 
else 
{
    Write-Host -f magenta "`n LibreOffice is not installed on this device."
}



## Create folders on the Desktop with shortcuts to specific applications.  The folder names organize the shortcuts by application category

Write-host -f White "`n Create shortcuts to the apps installed in a folder called GRAPHICS"

#Create an instance of the Windows Script Host Shell COM object, which allows you to create shortcut files

$WshShell = New-Object -ComObject WScript.Shell

# Hard code the shortcut folder
$ShortcutFolder = "C:\Users\User\Desktop\GRAPHICS"

# Ensure the shortcut folder exists
if (-not (Test-Path $ShortcutFolder))
{
    Write-host -f green "`n GRAPHICS folder not found.  Creating it now"
    New-Item -Path $ShortcutFolder -ItemType Directory | Out-Null 
}
else
{
    Write-host -f green "`n GRAPHICS folder already exists on the Desktop"
}


## Create shortcuts for all apps in the GRAPHICS category

# Shortcut: GIMP
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\GIMP 3.0.4.lnk")
$Shortcut.TargetPath = "C:\Users\User\AppData\Local\Programs\GIMP 3\bin\gimp-3.exe"
$Shortcut.WorkingDirectory = "$env:USERPROFILE"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "GIMP 3.0.4"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Inkscape Drawing Program
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Inkscape Drawing Program.lnk")
$Shortcut.TargetPath = "C:\Program Files\Inkscape\bin\inkscape.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Inkscape"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Inkview Graphics Viewer
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Inkview Graphics Viewer.lnk")
$Shortcut.TargetPath = "C:\Program Files\Inkscape\bin\inkview.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Inkscape"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Krita Painting Program
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Krita Painting Program.lnk")
$Shortcut.TargetPath = "C:\Program Files\Krita (x64)\bin\krita.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Krita (x64)"
$Shortcut.IconLocation = "C:\Program Files\Krita (x64)\shellex\krita.ico,0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Tux Paint (for Kids!)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Tux Paint (for Kids!).lnk")
$Shortcut.TargetPath = "C:\Program Files\TuxPaint\tuxpaint.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\TuxPaint"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

Write-host -f Yellow "`n End shortcut creation for GRAPHICS folder.  They were created in $ShortcutFolder"

## Create shortcuts for all apps in the INTERNET category

Write-host -f White "`n Create shortcuts to the apps installed in a folder called INTERNET"

$WshShell = New-Object -ComObject WScript.Shell

# Hard code the shortcut folder
$ShortcutFolder = "C:\Users\User\Desktop\INTERNET"

# Create the INTERNET folder if it does not already exist
if (-not (Test-Path $ShortcutFolder))
{
    Write-host -f green "`n INTERNET folder not found.  Creating it now"
    New-Item -Path $ShortcutFolder -ItemType Directory | Out-Null 
}
else
{
    Write-host -f green "`n INTERNET folder already exists on the Desktop"
}

# Shortcut: Firefox
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Firefox.lnk")
$Shortcut.TargetPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Mozilla Firefox"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Google Chrome
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Google Chrome.lnk")
$Shortcut.TargetPath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Google\Chrome\Application"
$Shortcut.IconLocation = "C:\Program Files\Google\Chrome\Application\chrome.exe,0"
$Shortcut.Description = "Access the Internet"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Microsoft Edge
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Microsoft Edge.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$Shortcut.WorkingDirectory = "C:\Program Files (x86)\Microsoft\Edge\Application"
$Shortcut.IconLocation = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe,0"
$Shortcut.Description = "Browse the web"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Zoom
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Zoom.lnk")
$Shortcut.TargetPath = "C:\Program Files\Zoom\bin\Zoom.exe"
$Shortcut.IconLocation = "C:\Program Files\Zoom\bin\Zoom.exe,0"
$Shortcut.Description = "Zoom"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

Write-host -f Yellow "`n End shortcut creation for INTERNET folder.  They were created in $ShortcutFolder"

## Create shortcuts for all apps in the MEDIA category

Write-host -f White "`n Create shortcuts to the apps installed in a folder called MEDIA"

$WshShell = New-Object -ComObject WScript.Shell

# Hard code the shortcut folder
$ShortcutFolder = "C:\Users\User\Desktop\MEDIA"
if (-not (Test-Path $ShortcutFolder))
{
    Write-host -f green "`n MEDIA folder not found.  Creating it now"
    New-Item -Path $ShortcutFolder -ItemType Directory | Out-Null
}
else
{
    Write-host -f green "`n MEDIA folder already exists on the Desktop"
}


# Shortcut: Audacity Audio File Editor
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Audacity Audio File Editor.lnk")
$Shortcut.TargetPath = "C:\Program Files\Audacity\Audacity.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\Audacity"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: HandBrake Video Converter
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\HandBrake Video Converter.lnk")
$Shortcut.TargetPath = "C:\Program Files\HandBrake\HandBrake.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\HandBrake"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Movies & TV
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Movies & TV.lnk")
$Shortcut.TargetPath = ""
$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll,115"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Windows Media Player
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Windows Media Player.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Windows Media Player\wmplayer.exe"
$Shortcut.Arguments = "/prefetch:1"
$Shortcut.WorkingDirectory = "%ProgramFiles(x86)%\Windows Media Player"
$Shortcut.IconLocation = "%ProgramFiles(x86)%\Windows Media Player\wmplayer.exe,0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

Write-host -f Yellow "`n End shortcut creation for INTERNET folder.  They were created in $ShortcutFolder"

## Create shortcuts for all apps in the OFFICE category

Write-host -f White "`n Create shortcuts to the apps installed in a folder called OFFICE"

# PowerShell script to recreate shortcuts in 'C:\Users\User\Shortcuts\OFFICE'
$WshShell = New-Object -ComObject WScript.Shell

# Hard code the shortcut folder
$ShortcutFolder = "C:\Users\User\Desktop\OFFICE"
if (-not (Test-Path $ShortcutFolder))
{
    Write-host -f green "`n OFFICE folder not found.  Creating it now"
    New-Item -Path $ShortcutFolder -ItemType Directory | Out-Null
}
else
{
    Write-host -f green "`n OFFICE folder already exists on the Desktop"
}


# Shortcut: 7-Zip File Manager
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\7-Zip File Manager.lnk")
$Shortcut.TargetPath = "C:\Program Files\7-Zip\7zFM.exe"
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Adobe Acrobat
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Adobe Acrobat.lnk")
$Shortcut.TargetPath = "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$Shortcut.IconLocation = "C:\Windows\Installer\{AC76BA86-1033-FF00-7760-BC15014EA700}\_SC_Acrobat.ico,0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Base (Database program like Microsoft Access)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Base (Database program like Microsoft Access).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\sbase.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\program\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Manage databases, create queries and reports to track and manage your information by using Base."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Calc (Spreadsheet program like Microsoft Excel)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Calc (Spreadsheet program like Microsoft Excel).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\scalc.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Perform calculations, analyze information and manage lists in spreadsheets by using Calc."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Draw (Graphics program like Microsoft Publisher)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Draw (Graphics program like Microsoft Publisher).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\sdraw.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Create and edit drawings, flow charts, and logos by using Draw."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Impress (Presentation program like Microsoft PowerPoint)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Impress (Presentation program like Microsoft PowerPoint).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\simpress.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Create and edit presentations for slideshows, meeting and Web pages by using Impress."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Math (Mathematical equation program)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Math (Mathematical equation program).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\smath.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\program\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Create and edit scientific formulas and equations by using Math."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice Writer (Document program like Microsoft Word)
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice Writer (Document program like Microsoft Word).lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\swriter.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "Create and edit text and images in letters, reports, documents and Web pages by using Writer."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: LibreOffice
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\LibreOffice.lnk")
$Shortcut.TargetPath = "C:\Program Files\LibreOffice\program\soffice.exe"
$Shortcut.WorkingDirectory = "C:\Program Files\LibreOffice\"
$Shortcut.IconLocation = ",0"
$Shortcut.Description = "LibreOffice, the office productivity suite provided by The Document Foundation. See https://www.documentfoundation.org"
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Notepad
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Notepad.lnk")
$Shortcut.TargetPath = "C:\Windows\System32\notepad.exe"
$Shortcut.WorkingDirectory = "%HOMEDRIVE%%HOMEPATH%"
$Shortcut.IconLocation = "%windir%\system32\notepad.exe,0"
$Shortcut.Description = "Creates and edits text files using basic text formatting."
$Shortcut.WindowStyle = 1
$Shortcut.Save()

# Shortcut: Sticky Notes
$Shortcut = $WshShell.CreateShortcut("$ShortcutFolder\Sticky Notes.lnk")
$Shortcut.TargetPath = ""
$Shortcut.IconLocation = ",0"
$Shortcut.WindowStyle = 1
$Shortcut.Save()


Write-host -f Yellow "`n End shortcut creation for OFFICE folder.  They were created in $ShortcutFolder"

## Let's set the execution policy back to restricted to prevent the user from running unsigned scripts in the future
set-executionpolicy restricted -Scope Process -Force;
Write-Host -F White "`n Windows Execution Policy has been set to $(Get-ExecutionPolicy)"

write-host -F Yellow "`nEnd of the Initialization Script.`n`n"
