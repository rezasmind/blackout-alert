@echo off
echo ========================================
echo   PowerGuard Portable Installer Build
echo ========================================
echo.

echo This script will create a portable installer for PowerGuard.
echo The installer will work on any Windows system without requiring
echo additional installer software like NSIS or WiX.
echo.

:: Check PowerShell availability
powershell -Command "Write-Host 'PowerShell is available'" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not available
    echo This script requires PowerShell to run
    pause
    exit /b 1
)

:: Ask user preferences
set /p createzip="Create ZIP archive? (y/n): "

:: Run PowerShell script
if /i "%createzip%"=="y" (
    powershell -ExecutionPolicy Bypass -File "create-portable-installer.ps1" -CreateZip
) else (
    powershell -ExecutionPolicy Bypass -File "create-portable-installer.ps1"
)

if %errorlevel% neq 0 (
    echo.
    echo ERROR: PowerShell script failed
    pause
    exit /b 1
)

echo.
echo Portable installer build completed!
pause
