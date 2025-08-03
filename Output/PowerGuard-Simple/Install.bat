@echo off
echo ========================================
echo    PowerGuard Simple Installer
echo ========================================
echo.
echo Installing PowerGuard...

:: Check admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run as administrator
    pause
    exit /b 1
)

set "INSTALL_DIR=%ProgramFiles%\PowerGuard"

:: Stop running instances
taskkill /f /im PowerGuard.exe >nul 2>&1

:: Create directory and copy files
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
xcopy "%~dp0*" "%INSTALL_DIR%\" /E /I /H /Y /Q >nul

:: Create Start Menu shortcut
powershell -Command "^& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut^('%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk'^); $Shortcut.TargetPath = '%INSTALL_DIR%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'PowerGuard'; $Shortcut.Save^(^)}" >nul 2>&1

:: Register in Programs
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\Uninstall.bat" /f >nul

:: Create uninstaller
(
echo @echo off
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo rmdir /s /q "%INSTALL_DIR%"
echo del "%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^>nul 2^>^&1
echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^>nul 2^>^&1
echo echo Uninstalled
echo pause
) > "%INSTALL_DIR%\Uninstall.bat"

echo Installation completed!
echo.
set /p launch="Launch PowerGuard now? ^(y/n^): "
if /i "%launch%"=="y" start "" "%INSTALL_DIR%\PowerGuard.exe"
pause
