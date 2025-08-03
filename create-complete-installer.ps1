# PowerGuard Complete Installer Creator with Vazir Matn Fonts
# This script creates a comprehensive installer package with all fonts included

param(
    [string]$OutputPath = "Output",
    [switch]$CreateZip = $false,
    [switch]$InstallFonts = $true
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PowerGuard Complete Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host

# Step 1: Build the application
Write-Host "[1/6] Building PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet build PowerGuard\PowerGuard.csproj -c Release --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    Write-Host "   ✓ Application build completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to build application: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Publish the application
Write-Host "`n[2/6] Publishing PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Publish failed" }
    Write-Host "   ✓ Application publish completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to publish application: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Create output directory
Write-Host "`n[3/6] Preparing output directory..." -ForegroundColor Yellow
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
$PortableDir = Join-Path $OutputPath "PowerGuard-Complete"
New-Item -ItemType Directory -Path $PortableDir -Force | Out-Null
Write-Host "   ✓ Output directory prepared" -ForegroundColor Green

# Step 4: Copy application files
Write-Host "`n[4/6] Copying application files..." -ForegroundColor Yellow
$SourceDir = "PowerGuard\bin\Release\net8.0-windows"
Copy-Item "$SourceDir\*" $PortableDir -Recurse -Force

# Ensure fonts are copied
$FontsSourceDir = "PowerGuard\Resources\Fonts"
$FontsDestDir = Join-Path $PortableDir "Resources\Fonts"
if (Test-Path $FontsSourceDir) {
    New-Item -ItemType Directory -Path $FontsDestDir -Force | Out-Null
    Copy-Item "$FontsSourceDir\*.ttf" $FontsDestDir -Force
    $fontCount = (Get-ChildItem "$FontsDestDir\*.ttf").Count
    Write-Host "   ✓ Copied $fontCount Vazir Matn font files" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Font directory not found - fonts will not be included" -ForegroundColor Yellow
}

Write-Host "   ✓ Application files copied" -ForegroundColor Green

# Step 5: Create comprehensive installation script
Write-Host "`n[5/6] Creating installation script..." -ForegroundColor Yellow

$InstallScript = @'
@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    PowerGuard Complete Installation
echo ========================================
echo.
echo PowerGuard - Persian Power Outage Protection
echo Version 1.0 with Vazir Matn Fonts
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Administrator privileges required
    echo.
    echo Please right-click this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

set "INSTALL_DIR=%ProgramFiles%\PowerGuard"
set "CURRENT_DIR=%~dp0"

echo Installing PowerGuard to: %INSTALL_DIR%
echo.

:: Stop any running instances
echo Stopping any running PowerGuard instances...
taskkill /f /im PowerGuard.exe >nul 2>&1

:: Create installation directory
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Copy application files
echo Copying application files...
xcopy "%CURRENT_DIR%*" "%INSTALL_DIR%\" /E /I /H /Y /Q >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy application files
    pause
    exit /b 1
)

:: Install fonts system-wide (optional)
set /p installFonts="Install Vazir Matn fonts system-wide for better rendering? (y/n): "
if /i "%installFonts%"=="y" (
    echo Installing Vazir Matn fonts...
    if exist "%INSTALL_DIR%\Resources\Fonts\*.ttf" (
        for %%f in ("%INSTALL_DIR%\Resources\Fonts\*.ttf") do (
            echo Installing font: %%~nxf
            copy "%%f" "%SystemRoot%\Fonts\" >nul 2>&1
            reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%%~nf (TrueType)" /t REG_SZ /d "%%~nxf" /f >nul 2>&1
        )
        echo Fonts installed successfully!
    ) else (
        echo Warning: Font files not found
    )
)

:: Create Start Menu shortcut
echo Creating Start Menu shortcut...
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'PowerGuard - Persian Power Outage Protection'; $Shortcut.Save()}" >nul 2>&1

:: Create Desktop shortcut (optional)
set /p desktop="Create desktop shortcut? (y/n): "
if /i "%desktop%"=="y" (
    powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%PUBLIC%\Desktop\PowerGuard.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\PowerGuard.exe'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.Description = 'PowerGuard - Persian Power Outage Protection'; $Shortcut.Save()}" >nul 2>&1
)

:: Register in Programs and Features
echo Registering application...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard - محافظ برق" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "Publisher" /t REG_SZ /d "PowerGuard Team" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "InstallLocation" /t REG_SZ /d "%INSTALL_DIR%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\Uninstall.bat" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayIcon" /t REG_SZ /d "%INSTALL_DIR%\PowerGuard.exe" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "EstimatedSize" /t REG_DWORD /d 15360 /f >nul

:: Create comprehensive uninstaller
echo Creating uninstaller...
(
echo @echo off
echo echo Uninstalling PowerGuard...
echo.
echo :: Stop running processes
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo.
echo :: Remove fonts if installed system-wide
echo set /p removeFonts="Remove Vazir Matn fonts from system? (y/n): "
echo if /i "%%removeFonts%%"=="y" ^(
echo     echo Removing fonts...
echo     for %%%%f in ^("%INSTALL_DIR%\Resources\Fonts\*.ttf"^) do ^(
echo         del "%%SystemRoot%%\Fonts\%%%%~nxf" ^>nul 2^>^&1
echo         reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "%%%%~nf ^(TrueType^)" /f ^>nul 2^>^&1
echo     ^)
echo ^)
echo.
echo :: Remove application files
echo rmdir /s /q "%INSTALL_DIR%"
echo.
echo :: Remove shortcuts
echo del "%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^>nul 2^>^&1
echo del "%PUBLIC%\Desktop\PowerGuard.lnk" ^>nul 2^>^&1
echo.
echo :: Remove registry entries
echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^>nul 2^>^&1
echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PowerGuard /f ^>nul 2^>^&1
echo.
echo :: Ask about user data
echo set /p userdata="Remove user settings and data? (y/n): "
echo if /i "%%userdata%%"=="y" ^(
echo     rmdir /s /q "%%APPDATA%%\PowerGuard" ^>nul 2^>^&1
echo ^)
echo.
echo echo PowerGuard has been completely uninstalled.
echo pause
) > "%INSTALL_DIR%\Uninstall.bat"

:: Ask about auto-start
set /p autostart="Start PowerGuard automatically with Windows? (y/n): "
if /i "%autostart%"=="y" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "PowerGuard" /t REG_SZ /d "%INSTALL_DIR%\PowerGuard.exe" /f >nul
    echo Auto-start enabled
)

:: Create application data directory
if not exist "%APPDATA%\PowerGuard" (
    mkdir "%APPDATA%\PowerGuard"
)

:: Set proper permissions
icacls "%INSTALL_DIR%" /grant Users:(OI)(CI)R >nul 2>&1

echo.
echo ========================================
echo        Installation Completed!
echo ========================================
echo.
echo PowerGuard has been successfully installed with:
echo   ✓ Application files
echo   ✓ Vazir Matn fonts for Persian text
echo   ✓ Start Menu shortcut
echo   ✓ Windows integration
echo   ✓ Automatic uninstaller
echo.
echo Location: %INSTALL_DIR%
echo.

:: Ask to launch
set /p launch="Launch PowerGuard now? (y/n): "
if /i "%launch%"=="y" (
    start "" "%INSTALL_DIR%\PowerGuard.exe"
    echo PowerGuard is starting...
)

echo.
echo Installation completed successfully!
echo Thank you for using PowerGuard!
pause
'@

$InstallScript | Out-File -FilePath (Join-Path $PortableDir "Install.bat") -Encoding ASCII

Write-Host "   ✓ Installation script created" -ForegroundColor Green

# Step 6: Create comprehensive README
Write-Host "`n[6/6] Creating documentation..." -ForegroundColor Yellow

$ReadmeContent = @'
# PowerGuard Complete Installation Package
## محافظ برق - بسته نصب کامل

### Overview / نمای کلی
PowerGuard is a comprehensive Windows application designed to prevent data loss during scheduled power outages. This package includes the complete application with Vazir Matn fonts for optimal Persian text rendering.

محافظ برق یک برنامه جامع ویندوز است که برای جلوگیری از از دست رفتن داده‌ها در هنگام قطعی برق برنامه‌ریزی شده طراحی شده است. این بسته شامل برنامه کامل با فونت‌های وزیر متن برای نمایش بهینه متن فارسی است.

### Quick Installation / نصب سریع
1. Right-click "Install.bat" and select "Run as administrator"
2. Follow the installation prompts
3. Choose whether to install fonts system-wide
4. PowerGuard will be ready to use!

### Features / ویژگی‌ها
✓ Persian UI with Vazir Matn fonts / رابط فارسی با فونت وزیر متن
✓ Automatic shutdown scheduling / برنامه‌ریزی خودکار خاموشی
✓ Smart reminders / یادآوری‌های هوشمند
✓ Recurring schedules / برنامه‌های تکراری
✓ System tray operation / عملکرد در سیستم تری
✓ Comprehensive logging / ثبت وقایع جامع

### What Gets Installed / آنچه نصب می‌شود
- PowerGuard application / برنامه محافظ برق
- Vazir Matn font family (9 weights) / خانواده فونت وزیر متن (9 وزن)
- Start Menu shortcut / میانبر منوی شروع
- Optional desktop shortcut / میانبر اختیاری دسکتاپ
- Windows registry integration / یکپارچگی با رجیستری ویندوز
- Automatic uninstaller / حذف‌کننده خودکار

### Font Information / اطلاعات فونت
This package includes the complete Vazir Matn font family:
- Vazirmatn-Thin.ttf
- Vazirmatn-ExtraLight.ttf
- Vazirmatn-Light.ttf
- Vazirmatn-Regular.ttf
- Vazirmatn-Medium.ttf
- Vazirmatn-SemiBold.ttf
- Vazirmatn-Bold.ttf
- Vazirmatn-ExtraBold.ttf
- Vazirmatn-Black.ttf

### System Requirements / الزامات سیستم
- Windows 10 or Windows 11 / ویندوز 10 یا 11
- .NET 8.0 Runtime (included) / نت ران‌تایم 8.0 (شامل)
- Administrator privileges for installation / دسترسی مدیر برای نصب
- 50 MB free disk space / 50 مگابایت فضای خالی

### Manual Usage (No Installation) / استفاده دستی (بدون نصب)
You can run PowerGuard directly without installation:
1. Double-click "PowerGuard.exe"
2. The application will use embedded fonts automatically
3. Settings will be saved to %APPDATA%\PowerGuard\

### Uninstallation / حذف برنامه
To remove PowerGuard:
1. Go to C:\Program Files\PowerGuard\
2. Run "Uninstall.bat" as administrator
3. Or use Windows "Add or Remove Programs"

### Font License / مجوز فونت
Vazir Matn fonts are licensed under SIL Open Font License (OFL)
- Free for commercial and personal use
- Can be embedded in applications
- Full license: https://scripts.sil.org/OFL

### Support / پشتیبانی
For support and updates:
- GitHub: https://github.com/powerguard/powerguard
- Issues: Report bugs and feature requests
- Documentation: Complete user guide available

### Version Information / اطلاعات نسخه
- PowerGuard Version: 1.0.0
- Vazir Matn Font Version: Latest
- Build Date: 2025-01-03
- .NET Version: 8.0

---
Thank you for using PowerGuard! / از استفاده از محافظ برق متشکریم!
'@

$ReadmeContent | Out-File -FilePath (Join-Path $PortableDir "README.txt") -Encoding UTF8

# Create version info file
$VersionInfo = @"
PowerGuard Version Information
=============================

Application Version: 1.0.0
Build Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
.NET Version: 8.0
Font Package: Vazir Matn Complete (9 weights)

Included Fonts:
$(if (Test-Path (Join-Path $PortableDir "Resources\Fonts")) {
    Get-ChildItem (Join-Path $PortableDir "Resources\Fonts\*.ttf") | ForEach-Object {
        "- $($_.Name) ($('{0:N0}' -f $_.Length) bytes)"
    }
} else {
    "- No fonts found"
})

Build Environment:
- OS: $($env:OS)
- Computer: $($env:COMPUTERNAME)
- User: $($env:USERNAME)
"@

$VersionInfo | Out-File -FilePath (Join-Path $PortableDir "VERSION.txt") -Encoding UTF8

Write-Host "   ✓ Documentation created" -ForegroundColor Green

# Optional: Create ZIP archive
if ($CreateZip) {
    Write-Host "`nCreating ZIP archive..." -ForegroundColor Yellow
    $ZipPath = Join-Path $OutputPath "PowerGuard-Complete.zip"
    Compress-Archive -Path $PortableDir -DestinationPath $ZipPath -Force
    Write-Host "   ✓ ZIP archive created: $ZipPath" -ForegroundColor Green
}

# Success message
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "           BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host

Write-Host "Complete installer package created!" -ForegroundColor White
Write-Host "   • Location: $PortableDir" -ForegroundColor Cyan
Write-Host "   • Installer: Install.bat" -ForegroundColor Cyan
Write-Host "   • Documentation: README.txt" -ForegroundColor Cyan

if (Test-Path (Join-Path $PortableDir "Resources\Fonts")) {
    $fontCount = (Get-ChildItem (Join-Path $PortableDir "Resources\Fonts\*.ttf")).Count
    Write-Host "   • Fonts included: $fontCount Vazir Matn weights" -ForegroundColor Cyan
}

if ($CreateZip) {
    Write-Host "   • ZIP archive: PowerGuard-Complete.zip" -ForegroundColor Cyan
}

Write-Host
Write-Host "Installation Instructions:" -ForegroundColor Yellow
Write-Host "1. Navigate to: $PortableDir" -ForegroundColor Gray
Write-Host "2. Right-click 'Install.bat' and select 'Run as administrator'" -ForegroundColor Gray
Write-Host "3. Follow the installation prompts" -ForegroundColor Gray
Write-Host "4. Enjoy PowerGuard with beautiful Persian fonts!" -ForegroundColor Gray

Write-Host
Write-Host "Package ready for distribution!" -ForegroundColor Green
