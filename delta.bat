@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ==================================================
echo       DELTA PLANEL by vn
echo ==================================================
echo 1. Auto-Scan Network for Active Devices
echo 2. Shutdown a remote computer
echo 3. Abort a remote shutdown
echo 4. Exit
echo ==================================================
set /p choice="Select an option (1-4): "

if "%choice%"=="1" goto auto_scan
if "%choice%"=="2" goto shutdown_remote
if "%choice%"=="3" goto abort_remote
if "%choice%"=="4" exit
goto menu

:auto_scan
echo Detecting network settings...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "IPv4 Address"') do (
    set "localip=%%a"
)
for /f "tokens=1,2,3 delims=." %%a in ("%localip: =%") do (
    set "subnet=%%a.%%b.%%c"
)

echo Scanning %subnet%.0/24... Please wait.
for /L %%i in (1,1,254) do (
    ping -n 1 -w 300 %subnet%.%%i | find "Reply" >nul
    if !errorlevel! equ 0 (
        echo [ACTIVE] %subnet%.%%i
    )
)
echo.
echo Scan complete.
timeout /t 3 >nul
goto menu

:shutdown_remote
set /p target="Enter the Computer Name or IP address: "
set /p time="Enter delay in seconds (or 0 for immediate): "
shutdown /s /m \\%target% /t %time% /c "Remote shutdown initiated by Admin"
echo Command sent to %target%.
timeout /t 3 >nul
goto menu

:abort_remote
set /p target="Enter the Computer Name or IP address to abort: "
shutdown /a /m \\%target%
echo Abort command sent to %target%.
timeout /t 3 >nul
goto menu