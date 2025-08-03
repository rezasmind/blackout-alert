@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   PowerGuard Final Installer Creator
echo ========================================
echo.

:: Step 1: Build the application
echo [1/5] Building PowerGuard Application...
dotnet build PowerGuard\PowerGuard.csproj -c Release >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Failed to build application
    pause
    exit /b 1
)
echo   ✓ Application build completed

:: Step 2: Publish the application
echo.
echo [2/5] Publishing PowerGuard Application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Failed to publish application
    pause
    exit /b 1
)
echo   ✓ Application publish completed

:: Step 3: Create output directory
echo.
echo [3/5] Creating installer package...
if exist "Output\PowerGuard-Final" rmdir /s /q "Output\PowerGuard-Final"
mkdir "Output\PowerGuard-Final" >nul 2>&1

:: Copy application files
xcopy "PowerGuard\bin\Release\net8.0-windows\*" "Output\PowerGuard-Final\" /E /I /H /Y /Q >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy application files
    pause
    exit /b 1
)

:: Copy fonts if they exist
if exist "PowerGuard\Resources\Fonts\*.ttf" (
    if not exist "Output\PowerGuard-Final\Resources\Fonts" mkdir "Output\PowerGuard-Final\Resources\Fonts"
    copy "PowerGuard\Resources\Fonts\*.ttf" "Output\PowerGuard-Final\Resources\Fonts\" >nul 2>&1
    echo   ✓ Vazir Matn fonts included
) else (
    echo   ⚠ No fonts found - application will use fallback fonts
)

echo   ✓ Package files copied

:: Step 4: Create professional installation script
echo.
echo [4/5] Creating installation script...
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo echo ========================================
echo echo    PowerGuard Professional Installer
echo echo ========================================
echo echo.
echo echo PowerGuard - محافظ برق
echo echo Persian Power Outage Protection with Vazir Matn Fonts
echo echo Version 1.0.0
echo echo.
echo.
echo :: Check for admin privileges
echo net session ^>nul 2^>^&1
echo if %%errorlevel%% neq 0 ^(
echo     echo ERROR: Administrator privileges required
echo     echo.
echo     echo Please right-click this file and select "Run as administrator"
echo     echo.
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
echo :: Stop any running instances
echo echo Stopping any running PowerGuard instances...
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo.
echo :: Create installation directory
echo if not exist "%%INSTALL_DIR%%" ^(
echo     mkdir "%%INSTALL_DIR%%"
echo ^)
echo.
echo :: Copy application files
echo echo Copying application files...
echo xcopy "%%CURRENT_DIR%%*" "%%INSTALL_DIR%%\" /E /I /H /Y /Q ^>nul
echo if %%errorlevel%% neq 0 ^(
echo     echo ERROR: Failed to copy application files
echo     pause
echo     exit /b 1
echo ^)
echo.
echo :: Install fonts system-wide ^(optional^)
echo set /p installFonts="Install Vazir Matn fonts system-wide for better rendering? ^(y/n^): "
echo if /i "%%installFonts%%"=="y" ^(
echo     echo Installing Vazir Matn fonts...
echo     if exist "%%INSTALL_DIR%%\Resources\Fonts\*.ttf" ^(
echo         for %%%%f in ^("%%INSTALL_DIR%%\Resources\Fonts\*.ttf"^) do ^(
echo             echo Installing font: %%%%~nxf
echo             copy "%%%%f" "%%SystemRoot%%\Fonts\" ^>nul 2^>^&1
echo             reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%%%%~nf ^(TrueType^)" /t REG_SZ /d "%%%%~nxf" /f ^>nul 2^>^&1
echo         ^)
echo         echo Fonts installed successfully!
echo     ^) else ^(
echo         echo Warning: Font files not found
echo     ^)
echo ^)
echo.
echo :: Create Start Menu shortcut
echo echo Creating Start Menu shortcut...
echo powershell -Command "^& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut^('%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk'^); $Shortcut.TargetPath = '%%INSTALL_DIR%%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%%INSTALL_DIR%%'; $Shortcut.Description = 'PowerGuard - Persian Power Outage Protection'; $Shortcut.Save^(^)}" ^>nul 2^>^&1
echo.
echo :: Create Desktop shortcut ^(optional^)
echo set /p desktop="Create desktop shortcut? ^(y/n^): "
echo if /i "%%desktop%%"=="y" ^(
echo     powershell -Command "^& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut^('%%PUBLIC%%\Desktop\PowerGuard.lnk'^); $Shortcut.TargetPath = '%%INSTALL_DIR%%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%%INSTALL_DIR%%'; $Shortcut.Description = 'PowerGuard - Persian Power Outage Protection'; $Shortcut.Save^(^)}" ^>nul 2^>^&1
echo ^)
echo.
echo :: Register in Programs and Features
echo echo Registering application...
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard - محافظ برق" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "Publisher" /t REG_SZ /d "PowerGuard Team" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "InstallLocation" /t REG_SZ /d "%%INSTALL_DIR%%" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%%INSTALL_DIR%%\Uninstall.bat" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayIcon" /t REG_SZ /d "%%INSTALL_DIR%%\PowerGuard.exe" /f ^>nul
echo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "EstimatedSize" /t REG_DWORD /d 15360 /f ^>nul
echo.
echo :: Create uninstaller
echo echo Creating uninstaller...
echo ^(
echo echo @echo off
echo echo echo Uninstalling PowerGuard...
echo echo.
echo echo :: Stop running processes
echo echo taskkill /f /im PowerGuard.exe ^^^>nul 2^^^>^^^&1
echo echo.
echo echo :: Remove fonts if installed system-wide
echo echo set /p removeFonts="Remove Vazir Matn fonts from system? ^^^(y/n^^^): "
echo echo if /i "%%%%removeFonts%%%%"=="y" ^^^(
echo echo     echo Removing fonts...
echo echo     for %%%%%%f in ^^^("%%INSTALL_DIR%%\Resources\Fonts\*.ttf"^^^) do ^^^(
echo echo         del "%%%%SystemRoot%%%%\Fonts\%%%%%%~nxf" ^^^>nul 2^^^>^^^&1
echo echo         reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%%%%%%~nf ^^^(TrueType^^^)" /f ^^^>nul 2^^^>^^^&1
echo echo     ^^^)
echo echo ^^^)
echo echo.
echo echo :: Remove application files
echo echo rmdir /s /q "%%INSTALL_DIR%%"
echo echo.
echo echo :: Remove shortcuts
echo echo del "%%ProgramData%%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^^^>nul 2^^^>^^^&1
echo echo del "%%PUBLIC%%\Desktop\PowerGuard.lnk" ^^^>nul 2^^^>^^^&1
echo echo.
echo echo :: Remove registry entries
echo echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^^^>nul 2^^^>^^^&1
echo echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PowerGuard /f ^^^>nul 2^^^>^^^&1
echo echo.
echo echo :: Ask about user data
echo echo set /p userdata="Remove user settings and data? ^^^(y/n^^^): "
echo echo if /i "%%%%userdata%%%%"=="y" ^^^(
echo echo     rmdir /s /q "%%%%APPDATA%%%%\PowerGuard" ^^^>nul 2^^^>^^^&1
echo echo ^^^)
echo echo.
echo echo echo PowerGuard has been completely uninstalled.
echo echo pause
echo ^) ^> "%%INSTALL_DIR%%\Uninstall.bat"
echo.
echo :: Ask about auto-start
echo set /p autostart="Start PowerGuard automatically with Windows? ^(y/n^): "
echo if /i "%%autostart%%"=="y" ^(
echo     reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "PowerGuard" /t REG_SZ /d "%%INSTALL_DIR%%\PowerGuard.exe" /f ^>nul
echo     echo Auto-start enabled
echo ^)
echo.
echo :: Create application data directory
echo if not exist "%%APPDATA%%\PowerGuard" ^(
echo     mkdir "%%APPDATA%%\PowerGuard"
echo ^)
echo.
echo :: Set proper permissions
echo icacls "%%INSTALL_DIR%%" /grant Users:^(OI^)^(CI^)R ^>nul 2^>^&1
echo.
echo echo.
echo echo ========================================
echo echo        Installation Completed!
echo echo ========================================
echo echo.
echo echo PowerGuard has been successfully installed with:
echo echo   ✓ Application files
echo echo   ✓ Vazir Matn fonts for Persian text
echo echo   ✓ Start Menu shortcut
echo echo   ✓ Windows integration
echo echo   ✓ Automatic uninstaller
echo echo.
echo echo Location: %%INSTALL_DIR%%
echo echo.
echo.
echo :: Ask to launch
echo set /p launch="Launch PowerGuard now? ^(y/n^): "
echo if /i "%%launch%%"=="y" ^(
echo     start "" "%%INSTALL_DIR%%\PowerGuard.exe"
echo     echo PowerGuard is starting...
echo ^)
echo.
echo echo.
echo echo Installation completed successfully!
echo echo Thank you for using PowerGuard!
echo pause
) > "Output\PowerGuard-Final\Install.bat"

echo   ✓ Installation script created

:: Step 5: Create documentation
echo.
echo [5/5] Creating documentation...

:: Create comprehensive README
(
echo # PowerGuard Complete Installation Package
echo ## محافظ برق - بسته نصب کامل
echo.
echo ### Quick Installation / نصب سریع
echo 1. Right-click "Install.bat" and select "Run as administrator"
echo 2. Follow the installation prompts
echo 3. Choose whether to install fonts system-wide
echo 4. PowerGuard will be ready to use!
echo.
echo ### Features / ویژگی‌ها
echo ✓ Persian UI with Vazir Matn fonts / رابط فارسی با فونت وزیر متن
echo ✓ Automatic shutdown scheduling / برنامه‌ریزی خودکار خاموشی
echo ✓ Smart reminders / یادآوری‌های هوشمند
echo ✓ Recurring schedules / برنامه‌های تکراری
echo ✓ System tray operation / عملکرد در سیستم تری
echo ✓ Comprehensive logging / ثبت وقایع جامع
echo.
echo ### System Requirements / الزامات سیستم
echo - Windows 10 or Windows 11 / ویندوز 10 یا 11
echo - .NET 8.0 Runtime ^(included^) / نت ران‌تایم 8.0 ^(شامل^)
echo - Administrator privileges for installation / دسترسی مدیر برای نصب
echo - 50 MB free disk space / 50 مگابایت فضای خالی
echo.
echo ### Manual Usage ^(No Installation^) / استفاده دستی ^(بدون نصب^)
echo You can run PowerGuard directly without installation:
echo 1. Double-click "PowerGuard.exe"
echo 2. The application will use embedded fonts automatically
echo 3. Settings will be saved to %%APPDATA%%\PowerGuard\
echo.
echo ### Uninstallation / حذف برنامه
echo To remove PowerGuard:
echo 1. Go to C:\Program Files\PowerGuard\
echo 2. Run "Uninstall.bat" as administrator
echo 3. Or use Windows "Add or Remove Programs"
echo.
echo ### Support / پشتیبانی
echo For support and updates:
echo - GitHub: https://github.com/powerguard/powerguard
echo - Issues: Report bugs and feature requests
echo.
echo ---
echo Thank you for using PowerGuard! / از استفاده از محافظ برق متشکریم!
) > "Output\PowerGuard-Final\README.txt"

echo   ✓ Documentation created

:: Success message
echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Complete PowerGuard installer package created!
echo.
echo Package contents:
echo   • Location: Output\PowerGuard-Final\
echo   • Installer: Install.bat
echo   • Application: PowerGuard.exe
echo   • Fonts: Vazir Matn family ^(if available^)
echo   • Documentation: README.txt
echo.
echo Installation Instructions:
echo 1. Navigate to: Output\PowerGuard-Final\
echo 2. Right-click 'Install.bat' and select 'Run as administrator'
echo 3. Follow the installation prompts
echo 4. Enjoy PowerGuard with beautiful Persian fonts!
echo.

:: Optional: Open output directory
set /p opendir="Open installer directory? (y/n): "
if /i "%opendir%"=="y" (
    start "" "Output\PowerGuard-Final"
)

echo.
echo Installer package ready for distribution!
pause
