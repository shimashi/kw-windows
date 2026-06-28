@echo off
setlocal

REM Note that as of 6/28/2026, this script is not needed.  It was only useful if a refurbisher prefers to copy the PowerShell installation scripts to a thumb drive first, and then insert the thumbdrive into the computer to be refurbished.  This will properly copy the files off the thumbdrive and onto the computer in the correct location, whch is C:\KindWorksScripts.  I think this version of the sript no longer accounts for the USB thumb drive anymore.  That code might be in an older version of the code.

REM in the future, the latest PowerShell installation scripts can easily be downloaded directly from Github using the instructions outlined in the beginnign of the instructional Word document in this respository.

Echo.
Echo Begin Initial File Copy Script
Echo.

REM This script creates a folder called "C:\KindWorksScripts" and then downloads all necessary files onto the computer to be refurbished to prepare it to run the initialization scripts.

REM Run this script first, after the refurbished computer has had a fresh OS installed.  Internet connectivity is necessary for this script
REM This script must be saved in UTF-8 mode, not "UTF-8 wth BOM"
REM When you save the file in notepad, make sure the "Encoding" option at the bottom of the "Save As" menu has UTF-8 selected
REM Otherwise it will display every single line in the terminal which will not look good.

echo Checking to see if KindWorksScripts folder exists
echo.

REM --- Create Paths ---
set ZIPFILE=%USERPROFILE%\Desktop\kw-windows.zip
set EXTRACTDIR=%USERPROFILE%\Desktop\AllExtractedScripts
set TARGETDIR=C:\KindWorksScripts

REM --- Create a folder for the extracted zip files if needed ---
if not exist "%EXTRACTDIR%" (
    mkdir "%EXTRACTDIR%"
)

REM --- Extract ZIP into AllExtractedScripts ---
powershell -command "Expand-Archive -Path '%ZIPFILE%' -DestinationPath '%EXTRACTDIR%' -Force"

REM --- GitHub ZIPs extract into kw-windows-main ---
set REPOFOLDER=%EXTRACTDIR%\kw-windows-main
set SOURCEFOLDER=%REPOFOLDER%\PowerShellScriptsAdam

REM --- Create target folder if needed ---
if not exist "%TARGETDIR%" (
    mkdir "%TARGETDIR%"
)

REM --- Move files ---
if exist "%SOURCEFOLDER%" (
    move "%SOURCEFOLDER%\*" "%TARGETDIR%"
    echo Files moved successfully.
) else (
    echo ERROR: Folder "%SOURCEFOLDER%" not found.
)

endlocal


start "" "C:\KindWorksScripts\"

Echo Initial File Copy Script complete.  You can now run the scripts from the local C: drive.
Echo.

pause
