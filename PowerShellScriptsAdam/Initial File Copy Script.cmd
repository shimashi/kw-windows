@echo off
setlocal

Echo.
Echo Begin Initial File Copy Script
Echo.

REM This script creates a folder called "C:\KindWorksScripts" and then downloads all necessary files onto the computer to be refurbished to prepare it to run the initialization scripts.
REM This script downloads the necessary install scripts from the https://github.com/shimashi/kw-windows/ github site
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
