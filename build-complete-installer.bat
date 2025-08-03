@echo off
echo ========================================
echo   PowerGuard Complete Installer Build
echo ========================================
echo.

echo This script will create a complete PowerGuard installer package
echo including the application and all Vazir Matn fonts.
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
set /p createzip="Create ZIP archive for distribution? (y/n): "

:: Run PowerShell script
if /i "%createzip%"=="y" (
    powershell -ExecutionPolicy Bypass -File "create-complete-installer.ps1" -CreateZip
) else (
    powershell -ExecutionPolicy Bypass -File "create-complete-installer.ps1"
)

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Installer creation failed
    pause
    exit /b 1
)

echo.
echo Complete installer package created successfully!
echo.
echo The package includes:
echo   ✓ PowerGuard application with Persian UI
echo   ✓ Complete Vazir Matn font family (9 weights)
echo   ✓ Professional installation script
echo   ✓ Comprehensive uninstaller
echo   ✓ Documentation and version info
echo.
pause
