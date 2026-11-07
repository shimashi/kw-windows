REM This script launhes a PowerShell command and runs a battery check on your laptop 
REM It produces a report in .HTML style in the folder C:\KindworksScripts\battery-report.html

REM First check to see if the folder C:\KindworksScripts exists, and if not, create it
IF EXIST "C:\KindworksScripts" 
	(
		echo %file1% already exists on the C drive
	)

IF NOT EXIST "C:\KindWorksScripts"  
	(
		echo C:\KindWorksScripts does not exist, creating it now
		mkdir c:\KindworksScripts
	)


REM Run the PowerShell command to produce the report.  You need to elevate proviledges
@powershell -NoProfile -ExecutionPolicy Bypass -Command "powercfg /batteryreport /output 'C:\KindworksScripts\battery-report.html'"
@pause 
