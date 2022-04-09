mkdir c:\kindworks
@powershell -NoProfile -ExecutionPolicy Bypass -Command "powercfg /batteryreport /output 'C:\kindworks\battery-report.html'"
@pause 