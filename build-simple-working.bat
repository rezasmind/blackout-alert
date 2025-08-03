@echo off
echo ========================================
echo   PowerGuard Simple Working Build
echo ========================================
echo.

:: Step 1: Clean build
echo [1/4] Cleaning previous builds...
if exist "PowerGuard\bin" rmdir /s /q "PowerGuard\bin" >nul 2>&1
if exist "PowerGuard\obj" rmdir /s /q "PowerGuard\obj" >nul 2>&1
if exist "Output\PowerGuard-Simple" rmdir /s /q "Output\PowerGuard-Simple" >nul 2>&1
echo   ✓ Cleanup completed

:: Step 2: Build application
echo.
echo [2/4] Building PowerGuard...
dotnet build PowerGuard\PowerGuard.csproj -c Release --verbosity minimal
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    echo.
    echo Trying to build with more details...
    dotnet build PowerGuard\PowerGuard.csproj -c Release --verbosity normal
    pause
    exit /b 1
)
echo   ✓ Build completed successfully

:: Step 3: Publish application
echo.
echo [3/4] Publishing application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build --verbosity minimal
if %errorlevel% neq 0 (
    echo ERROR: Publish failed
    pause
    exit /b 1
)
echo   ✓ Publish completed

:: Step 4: Create installer package
echo.
echo [4/4] Creating installer package...
mkdir "Output\PowerGuard-Simple" >nul 2>&1

:: Copy application files
xcopy "PowerGuard\bin\Release\net8.0-windows\*" "Output\PowerGuard-Simple\" /E /I /H /Y /Q >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy files
    pause
    exit /b 1
)

:: Copy fonts if available
if exist "PowerGuard\Resources\Fonts\*.ttf" (
    if not exist "Output\PowerGuard-Simple\Resources\Fonts" mkdir "Output\PowerGuard-Simple\Resources\Fonts"
    copy "PowerGuard\Resources\Fonts\*.ttf" "Output\PowerGuard-Simple\Resources\Fonts\" >nul 2>&1
    echo   ✓ Fonts copied
)

:: Create simple installer
(
echo @echo off
echo echo ========================================
echo echo    PowerGuard Simple Installer
echo echo ========================================
echo echo.
echo echo Installing PowerGuard...
echo.
echo :: Check admin
echo net session ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo Please run as administrator
echo     pause
echo     exit /b 1
echo ^)
echo.
echo set "INSTALL_DIR=%%ProgramFiles%%\PowerGuard"
echo.
echo :: Stop running instances
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo.
echo :: Create directory and copy files
echo if not exist "%%INSTALL_DIR%%" mkdir "%%INSTALL_DIR%%"
echo xcopy "%%~dp0*" "%%INSTALL_DIR%%\" /E /I /H /Y /Q ^>nul
echo.
echo :: Create Start Menu shortcut
echo powershell -Command "^& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut^('%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk'^); $Shortcut.TargetPath = '%%INSTALL_DIR%%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%%INSTALL_DIR%%'; $Shortcut.Description = 'PowerGuard'; $Shortcut.Save^(^)}" ^>nul 2^>^&1
echo.
echo :: Register in Programs
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%%INSTALL_DIR%%\Uninstall.bat" /f ^>nul
echo.
echo :: Create uninstaller
echo ^(
echo echo @echo off
echo echo taskkill /f /im PowerGuard.exe ^^^>nul 2^^^>^^^&1
echo echo rmdir /s /q "%%INSTALL_DIR%%"
echo echo del "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^^^>nul 2^^^>^^^&1
echo echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^^^>nul 2^^^>^^^&1
echo echo echo Uninstalled
echo echo pause
echo ^) ^> "%%INSTALL_DIR%%\Uninstall.bat"
echo.
echo echo Installation completed!
echo echo.
echo set /p launch="Launch PowerGuard now? ^(y/n^): "
echo if /i "%%launch%%"=="y" start "" "%%INSTALL_DIR%%\PowerGuard.exe"
echo pause
) > "Output\PowerGuard-Simple\Install.bat"

:: Create README
(
echo PowerGuard Simple Installation
echo =============================
echo.
echo Installation:
echo 1. Right-click Install.bat and "Run as administrator"
echo 2. Follow the prompts
echo.
echo Manual Usage:
echo 1. Double-click PowerGuard.exe to run directly
echo.
echo Uninstallation:
echo 1. Go to C:\Program Files\PowerGuard\
echo 2. Run Uninstall.bat as administrator
) > "Output\PowerGuard-Simple\README.txt"

echo   ✓ Installer package created

:: Success
echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Simple PowerGuard installer created!
echo Location: Output\PowerGuard-Simple\
echo.
echo To install:
echo 1. Go to Output\PowerGuard-Simple\
echo 2. Right-click Install.bat and "Run as administrator"
echo.

:: Test the application
echo Testing the application...
echo.
set /p test="Test run PowerGuard now? (y/n): "
if /i "%test%"=="y" (
    echo Starting PowerGuard...
    start "" "Output\PowerGuard-Simple\PowerGuard.exe"
    echo.
    echo If PowerGuard starts successfully, the build is working!
    echo You can now use the installer in Output\PowerGuard-Simple\
)

echo.
pause
