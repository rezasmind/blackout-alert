@echo off
echo ========================================
echo    PowerGuard Font Downloader
echo ========================================
echo.

echo This script will download Vazir Matn fonts for better Persian text rendering.
echo The fonts will be downloaded from the official Vazir Matn repository.
echo.

:: Check PowerShell availability
powershell -Command "Write-Host 'PowerShell is available'" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not available
    echo This script requires PowerShell to download fonts
    pause
    exit /b 1
)

:: Run PowerShell script
echo Starting font download...
powershell -ExecutionPolicy Bypass -File "download-fonts.ps1"

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Font download script failed
    echo You can manually download fonts from: https://github.com/rastikerdar/vazirmatn/releases
    pause
    exit /b 1
)

echo.
echo Font download completed!
echo You can now build the PowerGuard application with improved Persian fonts.
pause
