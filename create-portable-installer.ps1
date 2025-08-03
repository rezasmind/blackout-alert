# PowerGuard Portable Installer Creator
# This script creates a self-extracting installer using PowerShell and built-in Windows tools

param(
    [string]$OutputPath = "Output",
    [switch]$CreateZip = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PowerGuard Portable Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host

# Step 1: Build the application
Write-Host "[1/5] Building PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet build PowerGuard\PowerGuard.csproj -c Release --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    Write-Host "   ✓ Application build completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to build application: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Publish the application
Write-Host "`n[2/5] Publishing PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Publish failed" }
    Write-Host "   ✓ Application publish completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to publish application: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Create output directory
Write-Host "`n[3/5] Preparing output directory..." -ForegroundColor Yellow
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
Write-Host "   ✓ Output directory prepared" -ForegroundColor Green

# Step 4: Create portable package
Write-Host "`n[4/5] Creating portable package..." -ForegroundColor Yellow
$PortableDir = Join-Path $OutputPath "PowerGuard-Portable"
New-Item -ItemType Directory -Path $PortableDir -Force | Out-Null

# Copy application files
$SourceDir = "PowerGuard\bin\Release\net8.0-windows"
Copy-Item "$SourceDir\*" $PortableDir -Recurse -Force

# Create installation script
$InstallScript = @'
@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    PowerGuard Installation Script
echo ========================================
echo.

:: Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This installer requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b 1
)

:: Set installation directory
set "INSTALL_DIR=%ProgramFiles%\PowerGuard"
set "CURRENT_DIR=%~dp0"

echo Installing PowerGuard to: %INSTALL_DIR%
echo.

:: Create installation directory
if not exist "%INSTALL_DIR%" (
    mkdir "%INSTALL_DIR%"
)

:: Copy files
echo Copying application files...
xcopy "%CURRENT_DIR%*" "%INSTALL_DIR%\" /E /I /H /Y >nul
if %errorlevel% neq 0 (
    echo Error: Failed to copy files
    pause
    exit /b 1
)

:: Create Start Menu shortcut
echo Creating Start Menu shortcut...
powershell -Command "^& {`$WshShell = New-Object -comObject WScript.Shell; `$Shortcut = `$WshShell.CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk'); `$Shortcut.TargetPath = '%INSTALL_DIR%\PowerGuard.exe'; `$Shortcut.WorkingDirectory = '%INSTALL_DIR%'; `$Shortcut.Description = 'PowerGuard - Prevent data loss during power outages'; `$Shortcut.Save()}"

:: Create Desktop shortcut (optional)
set /p desktop="Create desktop shortcut? (y/n): "
if /i "%desktop%"=="y" (
    powershell -Command "^& {`$WshShell = New-Object -comObject WScript.Shell; `$Shortcut = `$WshShell.CreateShortcut('%PUBLIC%\Desktop\PowerGuard.lnk'); `$Shortcut.TargetPath = '%INSTALL_DIR%\PowerGuard.exe'; `$Shortcut.WorkingDirectory = '%INSTALL_DIR%'; `$Shortcut.Description = 'PowerGuard - Prevent data loss during power outages'; `$Shortcut.Save()}"
)

:: Register in Windows Programs
echo Registering application...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "محافظ برق - PowerGuard" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "Publisher" /t REG_SZ /d "PowerGuard Team" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "InstallLocation" /t REG_SZ /d "%INSTALL_DIR%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\Uninstall.bat" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayIcon" /t REG_SZ /d "%INSTALL_DIR%\PowerGuard.exe" /f >nul

:: Create uninstaller
echo Creating uninstaller...
(
echo @echo off
echo echo Uninstalling PowerGuard...
echo.
echo :: Stop running processes
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo.
echo :: Remove files
echo rmdir /s /q "%INSTALL_DIR%"
echo.
echo :: Remove shortcuts
echo del "%ProgramData%\Microsoft\Windows\Start Menu\Programs\محافظ برق.lnk" ^>nul 2^>^&1
echo del "%PUBLIC%\Desktop\محافظ برق.lnk" ^>nul 2^>^&1
echo.
echo :: Remove registry entries
echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^>nul 2^>^&1
echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PowerGuard /f ^>nul 2^>^&1
echo.
echo :: Ask about user data
echo set /p userdata="Remove user settings and data? (y/n): "
echo if /i "%%userdata%%"=="y" (
echo     rmdir /s /q "%%APPDATA%%\PowerGuard" ^>nul 2^>^&1
echo ^)
echo.
echo echo PowerGuard has been uninstalled.
echo pause
) > "%INSTALL_DIR%\Uninstall.bat"

:: Ask about auto-start
set /p autostart="Start PowerGuard automatically with Windows? (y/n): "
if /i "%autostart%"=="y" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "PowerGuard" /t REG_SZ /d "%INSTALL_DIR%\PowerGuard.exe" /f >nul
)

:: Create application data directory
if not exist "%APPDATA%\PowerGuard" (
    mkdir "%APPDATA%\PowerGuard"
)

echo.
echo ========================================
echo        Installation Completed!
echo ========================================
echo.
echo PowerGuard has been installed to: %INSTALL_DIR%
echo.
echo You can now:
echo   • Find PowerGuard in Start Menu
echo   • Run PowerGuard from Desktop (if shortcut created)
echo   • Uninstall using: %INSTALL_DIR%\Uninstall.bat
echo.

:: Ask to launch
set /p launch="Launch PowerGuard now? (y/n): "
if /i "%launch%"=="y" (
    start "" "%INSTALL_DIR%\PowerGuard.exe"
)

echo.
echo Installation script completed.
pause
'@

$InstallScript | Out-File -FilePath (Join-Path $PortableDir "Install.bat") -Encoding ASCII

# Create README for portable version
$ReadmeContent = @'
# PowerGuard Portable Installation

This is a portable installation package for PowerGuard.

## Installation Instructions

1. **Run as Administrator**: Right-click on `Install.bat` and select "Run as administrator"
2. **Follow the prompts**: The installer will guide you through the installation process
3. **Choose options**: Select whether to create desktop shortcut and enable auto-start

## What gets installed

- PowerGuard application files in `C:\Program Files\PowerGuard\`
- Start Menu shortcut: "محافظ برق"
- Optional desktop shortcut
- Windows registry entries for proper integration
- Uninstaller: `C:\Program Files\PowerGuard\Uninstall.bat`

## Manual Installation (Alternative)

If you prefer to run PowerGuard without installation:

1. Extract all files to a folder of your choice
2. Run `PowerGuard.exe` directly
3. The application will create its settings in `%APPDATA%\PowerGuard\`

## Uninstallation

To uninstall PowerGuard:
1. Go to `C:\Program Files\PowerGuard\`
2. Run `Uninstall.bat` as administrator
3. Choose whether to remove user data and settings

## System Requirements

- Windows 10 or Windows 11
- .NET 8.0 Runtime (included in this package)
- Administrator privileges for installation

## Support

For support and updates, visit: https://github.com/powerguard/powerguard
'@

$ReadmeContent | Out-File -FilePath (Join-Path $PortableDir "README.txt") -Encoding UTF8

Write-Host "   ✓ Portable package created" -ForegroundColor Green

# Step 5: Create ZIP archive if requested
if ($CreateZip) {
    Write-Host "`n[5/5] Creating ZIP archive..." -ForegroundColor Yellow
    $ZipPath = Join-Path $OutputPath "PowerGuard-Portable.zip"
    Compress-Archive -Path $PortableDir -DestinationPath $ZipPath -Force
    Write-Host "   ✓ ZIP archive created: $ZipPath" -ForegroundColor Green
} else {
    Write-Host "`n[5/5] Skipping ZIP creation..." -ForegroundColor Yellow
    Write-Host "   ℹ Use -CreateZip switch to create ZIP archive" -ForegroundColor Cyan
}

# Success message
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "           BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host
Write-Host "Output files:" -ForegroundColor White
Write-Host "   • Portable Package:    $PortableDir" -ForegroundColor Cyan
if ($CreateZip) {
    Write-Host "   • ZIP Archive:         $ZipPath" -ForegroundColor Cyan
}
Write-Host
Write-Host "Installation Instructions:" -ForegroundColor White
Write-Host "1. Navigate to: $PortableDir" -ForegroundColor Gray
Write-Host "2. Right-click 'Install.bat' and select 'Run as administrator'" -ForegroundColor Gray
Write-Host "3. Follow the installation prompts" -ForegroundColor Gray
Write-Host
Write-Host "Manual Usage (No Installation):" -ForegroundColor White
Write-Host "1. Navigate to: $PortableDir" -ForegroundColor Gray
Write-Host "2. Run 'PowerGuard.exe' directly" -ForegroundColor Gray
Write-Host

# Optional: Open output directory
$openDir = Read-Host "Open output directory? (y/n)"
if ($openDir -eq 'y' -or $openDir -eq 'Y') {
    Start-Process explorer.exe -ArgumentList $OutputPath
}

Write-Host "Build completed successfully!" -ForegroundColor Green
