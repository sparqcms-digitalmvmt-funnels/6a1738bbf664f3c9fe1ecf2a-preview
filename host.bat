@echo off
title Local Preview Server

echo =========================================
echo   Starting local preview server
echo =========================================
echo.

:: Check if Python is installed, install via winget if missing
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Python not found. Attempting to install via winget...
    winget install Python.Python.3 --accept-source-agreements --accept-package-agreements
    if %errorlevel% neq 0 (
        echo.
        echo [ERROR] Automatic installation failed.
        echo Please install Python manually from https://www.python.org/downloads/
        echo Make sure to check "Add Python to PATH" during installation.
        echo.
        pause
        exit /b
    )
    :: Refresh PATH so python is available in this session
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYS_PATH=%%B"
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USR_PATH=%%B"
    set "PATH=%SYS_PATH%;%USR_PATH%"
    echo [INFO] Python installed successfully.
    echo.
)

set PORT=5500

:: Start Python HTTP server in the background
echo [1/2] Starting Python HTTP server on port %PORT%...
start /B python -m http.server %PORT%

:: Give the server a moment to start
timeout /t 1 >nul

:: Open browser at localhost
echo [2/2] Opening browser at http://localhost:%PORT%...
start "" "http://localhost:%PORT%"

echo.
echo Press any key to shut down the server...
pause >nul

:: Clean up
taskkill /F /IM python.exe >nul 2>&1
echo Stopped. You can close this window.
pause
