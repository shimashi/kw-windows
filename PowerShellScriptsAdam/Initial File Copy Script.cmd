@echo off

Echo.
Echo Begin Initial File Copy Script
Echo.

REM This script creates a folder and then copies all necessary files onto the computer to be refurbished to prepare it to run the initialization scripts.
REM Run this script first, after the refurbished computer has had a fresh OS installed.  Internet connectivity is not necessary for this script, but is needed for subsequent scripts
REM This script must be saved in UTF-8 mode, not "UTF-8 wth BOM"
REM When you save the file in notepad, make sure the "Encoding" option at the bottom of the "Save As" menu has UTF-8 selected
REM Otherwise it will display every single line in the terminal which will not look good.

echo Checking to see if KindWorksScripts folder exists
echo.

IF EXIST "C:\KindWorksScripts" 
	(
		echo KindWorksScripts folder already exists
		echo.
    )
ELSE 
	(
		echo KindWorksScripts folder does not exist.  Creating one now.
		mkdir "C:\KindWorksScripts"
		echo KindsWorksScripts folder sucessfully created under C:
		echo. 
	)


echo Listing all available drives that you can copy files from:
echo.

powershell -command "Get-PSDrive -PSProvider 'FileSystem' | Where-Object { $_.Name -ne 'C' } | ForEach-Object { $_.Name + ':' }"
echo.
    
REM Ask the user to type in the drive letter where the KindWorks files reside
setlocal enabledelayedexpansion
choice /c ABCDEFGHIJKLMNOPQRSTUVWXYZ /n /m "Enter the drive letter where the KindWorks installation files reside:"
set "letter=%errorlevel%"
echo.
REM echo letter is now: !letter! 

    
REM Convert the key that the user just pressed into a variable called "selected_drive"
set "letters=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set /a index=!letter! - 1
set "selected_drive=!letters:~%index%,1!"

echo You selected the following drive letter: !selected_drive!     
echo.
    

REM Start copying the five files needed to initialize the KindWorks computers
REM The source folder is <mapped drive letter>:\KindWorksScripts
REM The destination folder is C:\KindWorksScripts
REM After each copy, check to make sure the file exists in the destination.

REM Set a variable to count the number of files properly copied.  Increment after each sucessfull copied file.
set "success_count=0"

set "file1=%selected_drive%:\KindWorksScripts\Bootup Bypass Script.cmd"
REM echo file1 is now %file1%
echo.
Copy "%file1%" "C:\KindWorksScripts\"
echo.
IF EXIST "C:\KindWorksScripts\Bootup Bypass Script.cmd" 
	(
		echo %file1% copied sucessfully to C drive
		set /a success_count+=1
		echo.
	)
ELSE
	(
		echo %file1% was NOT copied sucessfully to C drive.
		echo.
	)


set "file2=%selected_drive%:\KindWorksScripts\Initialize Script.ps1"
REM echo file2 is now %file1%
echo.
Copy "%file2%" "C:\KindWorksScripts\"
echo.
IF EXIST "C:\KindWorksScripts\Initialize Script.ps1"
	(
		echo %file2% copied sucessfully to C drive
		set /a success_count+=1
		echo.
    )
ELSE
	(
		echo %file2% was NOT copied sucessfully to C drive.
		echo.
	)


set "file3=%selected_drive%:\KindWorksScripts\Update Apps.cmd"
REM echo file3 is now %file3%
echo.
Copy "%file3%" "C:\KindWorksScripts\"
echo.
IF EXIST "C:\KindWorksScripts\Update Apps.cmd"
	(
		echo %file3% copied sucessfully to C drive
		set /a success_count+=1
		echo.
    )
ELSE
	(
		echo %file3% was NOT copied sucessfully to C drive.
		echo.
	)


set "file4=%selected_drive%:\KindWorksScripts\Update Apps.ps1"
REM echo file4 is now %file4%
echo.
Copy "%file4%" "C:\KindWorksScripts\"
echo.
IF EXIST "C:\KindWorksScripts\Update Apps.ps1"
	(
		echo %file4% copied sucessfully to C drive
		set /a success_count+=1
		echo.
    )
ELSE
	(
		echo %file4% was NOT copied sucessfully to C drive.
		echo.
	)


set "file5=%selected_drive%:\KindWorksScripts\KindWorks.pow"
REM echo file5 is now %file5%
echo.
Copy "%file5%" "C:\KindWorksScripts\"
echo.
IF EXIST "C:\KindWorksScripts\KindWorks.pow"
	(
		echo %file5% copied sucessfully to C drive
		set /a success_count+=1
		echo.
    )
ELSE
	(
		echo %file5% was NOT copied sucessfully to C drive.
		echo.
	)

REM At the end, before pause:
echo.
echo ========================================
echo Copy Summary:
echo ========================================
echo Successfully copied: %success_count% file(s)
echo ========================================

endlocal

start "" "C:\KindWorksScripts\"

Echo Initial File Copy Script complete.  You can now run the scripts from the local C: drive.
Echo.

pause
