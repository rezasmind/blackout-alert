@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    PowerGuard Installer Creator
echo ========================================
echo.

:: Step 1: Build the application
echo [1/4] Building PowerGuard Application...
dotnet build PowerGuard\PowerGuard.csproj -c Release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build application
    pause
    exit /b 1
)
echo   ✓ Application build completed

:: Step 2: Publish the application
echo.
echo [2/4] Publishing PowerGuard Application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build
if %errorlevel% neq 0 (
    echo ERROR: Failed to publish application
    pause
    exit /b 1
)
echo   ✓ Application publish completed

:: Step 3: Create output directory
echo.
echo [3/4] Creating output directory...
if exist "Output" rmdir /s /q "Output"
mkdir "Output"
mkdir "Output\PowerGuard-Portable"
echo   ✓ Output directory created

:: Step 4: Copy files and create installer
echo.
echo [4/4] Creating portable installer package...

:: Copy application files
xcopy "PowerGuard\bin\Release\net8.0-windows\*" "Output\PowerGuard-Portable\" /E /I /H /Y >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy application files
    pause
    exit /b 1
)

:: Create installation batch file
(
echo @echo off
echo echo ========================================
echo echo    PowerGuard Installation
echo echo ========================================
echo echo.
echo.
echo :: Check for admin privileges
echo net session ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo This installer requires administrator privileges.
echo     echo Please run as administrator.
echo     pause
echo     exit /b 1
echo ^)
echo.
echo set "INSTALL_DIR=%%ProgramFiles%%\PowerGuard"
echo set "CURRENT_DIR=%%~dp0"
echo.
echo echo Installing PowerGuard to: %%INSTALL_DIR%%
echo echo.
echo.
echo :: Create directory and copy files
echo if not exist "%%INSTALL_DIR%%" mkdir "%%INSTALL_DIR%%"
echo xcopy "%%CURRENT_DIR%%*" "%%INSTALL_DIR%%\" /E /I /H /Y ^>nul
echo.
echo :: Create Start Menu shortcut using VBScript
echo echo Creating shortcuts...
echo echo Set oWS = WScript.CreateObject^("WScript.Shell"^) ^> "%%TEMP%%\shortcut.vbs"
echo echo sLinkFile = "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^>^> "%%TEMP%%\shortcut.vbs"
echo echo Set oLink = oWS.CreateShortcut^(sLinkFile^) ^>^> "%%TEMP%%\shortcut.vbs"
echo echo oLink.TargetPath = "%%INSTALL_DIR%%\PowerGuard.exe" ^>^> "%%TEMP%%\shortcut.vbs"
echo echo oLink.WorkingDirectory = "%%INSTALL_DIR%%" ^>^> "%%TEMP%%\shortcut.vbs"
echo echo oLink.Description = "PowerGuard - Prevent data loss during power outages" ^>^> "%%TEMP%%\shortcut.vbs"
echo echo oLink.Save ^>^> "%%TEMP%%\shortcut.vbs"
echo cscript "%%TEMP%%\shortcut.vbs" ^>nul
echo del "%%TEMP%%\shortcut.vbs"
echo.
echo :: Ask for desktop shortcut
echo set /p desktop="Create desktop shortcut? (y/n): "
echo if /i "%%desktop%%"=="y" ^(
echo     echo Set oWS = WScript.CreateObject^("WScript.Shell"^) ^> "%%TEMP%%\shortcut.vbs"
echo     echo sLinkFile = "%%PUBLIC%%\Desktop\PowerGuard.lnk" ^>^> "%%TEMP%%\shortcut.vbs"
echo     echo Set oLink = oWS.CreateShortcut^(sLinkFile^) ^>^> "%%TEMP%%\shortcut.vbs"
echo     echo oLink.TargetPath = "%%INSTALL_DIR%%\PowerGuard.exe" ^>^> "%%TEMP%%\shortcut.vbs"
echo     echo oLink.WorkingDirectory = "%%INSTALL_DIR%%" ^>^> "%%TEMP%%\shortcut.vbs"
echo     echo oLink.Description = "PowerGuard - Prevent data loss during power outages" ^>^> "%%TEMP%%\shortcut.vbs"
echo     echo oLink.Save ^>^> "%%TEMP%%\shortcut.vbs"
echo     cscript "%%TEMP%%\shortcut.vbs" ^>nul
echo     del "%%TEMP%%\shortcut.vbs"
echo ^)
echo.
echo :: Register in Programs and Features
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "Publisher" /t REG_SZ /d "PowerGuard Team" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "InstallLocation" /t REG_SZ /d "%%INSTALL_DIR%%" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%%INSTALL_DIR%%\Uninstall.bat" /f ^>nul
echo.
echo :: Create uninstaller
echo ^(
echo echo @echo off
echo echo echo Uninstalling PowerGuard...
echo echo taskkill /f /im PowerGuard.exe ^^^>nul 2^^^>^^^&1
echo echo rmdir /s /q "%%INSTALL_DIR%%"
echo echo del "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^^^>nul 2^^^>^^^&1
echo echo del "%%PUBLIC%%\Desktop\PowerGuard.lnk" ^^^>nul 2^^^>^^^&1
echo echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^^^>nul 2^^^>^^^&1
echo echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PowerGuard /f ^^^>nul 2^^^>^^^&1
echo echo echo PowerGuard has been uninstalled.
echo echo pause
echo ^) ^> "%%INSTALL_DIR%%\Uninstall.bat"
echo.
echo :: Ask about auto-start
echo set /p autostart="Start PowerGuard automatically with Windows? (y/n): "
echo if /i "%%autostart%%"=="y" ^(
echo     reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "PowerGuard" /t REG_SZ /d "%%INSTALL_DIR%%\PowerGuard.exe" /f ^>nul
echo ^)
echo.
echo :: Create app data directory
echo if not exist "%%APPDATA%%\PowerGuard" mkdir "%%APPDATA%%\PowerGuard"
echo.
echo echo.
echo echo Installation completed successfully!
echo echo PowerGuard is now installed and ready to use.
echo echo.
echo.
echo :: Ask to launch
echo set /p launch="Launch PowerGuard now? (y/n): "
echo if /i "%%launch%%"=="y" ^(
echo     start "" "%%INSTALL_DIR%%\PowerGuard.exe"
echo ^)
echo.
echo pause
) > "Output\PowerGuard-Portable\Install.bat"

:: Create README file
(
echo # PowerGuard Portable Installation Package
echo.
echo ## Quick Installation
echo.
echo 1. Right-click on "Install.bat" and select "Run as administrator"
echo 2. Follow the prompts to complete installation
echo 3. PowerGuard will be available in Start Menu
echo.
echo ## Manual Usage ^(No Installation Required^)
echo.
echo You can also run PowerGuard directly without installation:
echo 1. Double-click "PowerGuard.exe" to run the application
echo 2. The application will create its settings in %%APPDATA%%\PowerGuard\
echo.
echo ## What Gets Installed
echo.
echo - Application files in C:\Program Files\PowerGuard\
echo - Start Menu shortcut
echo - Optional desktop shortcut
echo - Optional Windows startup entry
echo - Uninstaller ^(C:\Program Files\PowerGuard\Uninstall.bat^)
echo.
echo ## System Requirements
echo.
echo - Windows 10 or Windows 11
echo - .NET 8.0 Runtime ^(included^)
echo - Administrator privileges for installation
echo.
echo ## Uninstallation
echo.
echo To remove PowerGuard:
echo 1. Go to C:\Program Files\PowerGuard\
echo 2. Run "Uninstall.bat" as administrator
echo.
echo Or use Windows "Add or Remove Programs" feature.
echo.
echo ## Support
echo.
echo For support and updates: https://github.com/powerguard/powerguard
) > "Output\PowerGuard-Portable\README.txt"

echo   ✓ Portable installer package created

:: Success message
echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Output files:
echo   • Portable Package:    Output\PowerGuard-Portable\
echo   • Installation Script: Output\PowerGuard-Portable\Install.bat
echo   • README:              Output\PowerGuard-Portable\README.txt
echo.
echo Installation Instructions:
echo 1. Navigate to: Output\PowerGuard-Portable\
echo 2. Right-click 'Install.bat' and select 'Run as administrator'
echo 3. Follow the installation prompts
echo.
echo Manual Usage (No Installation):
echo 1. Navigate to: Output\PowerGuard-Portable\
echo 2. Run 'PowerGuard.exe' directly
echo.

:: Optional: Open output directory
set /p opendir="Open output directory? (y/n): "
if /i "%opendir%"=="y" (
    start "" "Output\PowerGuard-Portable"
)

echo.
echo Build completed successfully!
pause
