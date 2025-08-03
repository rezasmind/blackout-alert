# PowerGuard Simple Installer Creator
# This script creates a portable installer package

param(
    [string]$OutputPath = "Output"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PowerGuard Simple Installer" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host

# Step 1: Build the application
Write-Host "[1/4] Building PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet build PowerGuard\PowerGuard.csproj -c Release --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Build failed" }
    Write-Host "   ✓ Application build completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to build application: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Publish the application
Write-Host "`n[2/4] Publishing PowerGuard Application..." -ForegroundColor Yellow
try {
    & dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build --verbosity quiet
    if ($LASTEXITCODE -ne 0) { throw "Publish failed" }
    Write-Host "   ✓ Application publish completed" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Failed to publish application: $_" -ForegroundColor Red
    exit 1
}

# Step 3: Create output directory
Write-Host "`n[3/4] Preparing output directory..." -ForegroundColor Yellow
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
Write-Host "   ✓ Output directory prepared" -ForegroundColor Green

# Step 4: Create portable package
Write-Host "`n[4/4] Creating portable package..." -ForegroundColor Yellow
$PortableDir = Join-Path $OutputPath "PowerGuard-Portable"
New-Item -ItemType Directory -Path $PortableDir -Force | Out-Null

# Copy application files
$SourceDir = "PowerGuard\bin\Release\net8.0-windows"
Copy-Item "$SourceDir\*" $PortableDir -Recurse -Force

# Create simple installation batch file
$InstallBat = @'
@echo off
echo ========================================
echo    PowerGuard Installation
echo ========================================
echo.

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This installer requires administrator privileges.
    echo Please run as administrator.
    pause
    exit /b 1
)

set "INSTALL_DIR=%ProgramFiles%\PowerGuard"
set "CURRENT_DIR=%~dp0"

echo Installing PowerGuard to: %INSTALL_DIR%
echo.

:: Create directory and copy files
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
xcopy "%CURRENT_DIR%*" "%INSTALL_DIR%\" /E /I /H /Y >nul

:: Create Start Menu shortcut
echo Creating shortcuts...
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\shortcut.vbs"
echo sLinkFile = "%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" >> "%TEMP%\shortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\shortcut.vbs"
echo oLink.TargetPath = "%INSTALL_DIR%\PowerGuard.exe" >> "%TEMP%\shortcut.vbs"
echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%TEMP%\shortcut.vbs"
echo oLink.Description = "PowerGuard - Prevent data loss during power outages" >> "%TEMP%\shortcut.vbs"
echo oLink.Save >> "%TEMP%\shortcut.vbs"
cscript "%TEMP%\shortcut.vbs" >nul
del "%TEMP%\shortcut.vbs"

:: Ask for desktop shortcut
set /p desktop="Create desktop shortcut? (y/n): "
if /i "%desktop%"=="y" (
    echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\shortcut.vbs"
    echo sLinkFile = "%PUBLIC%\Desktop\PowerGuard.lnk" >> "%TEMP%\shortcut.vbs"
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\shortcut.vbs"
    echo oLink.TargetPath = "%INSTALL_DIR%\PowerGuard.exe" >> "%TEMP%\shortcut.vbs"
    echo oLink.WorkingDirectory = "%INSTALL_DIR%" >> "%TEMP%\shortcut.vbs"
    echo oLink.Description = "PowerGuard - Prevent data loss during power outages" >> "%TEMP%\shortcut.vbs"
    echo oLink.Save >> "%TEMP%\shortcut.vbs"
    cscript "%TEMP%\shortcut.vbs" >nul
    del "%TEMP%\shortcut.vbs"
)

:: Register in Programs and Features
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayName" /t REG_SZ /d "PowerGuard" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "DisplayVersion" /t REG_SZ /d "1.0.0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "Publisher" /t REG_SZ /d "PowerGuard Team" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "InstallLocation" /t REG_SZ /d "%INSTALL_DIR%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /v "UninstallString" /t REG_SZ /d "%INSTALL_DIR%\Uninstall.bat" /f >nul

:: Create uninstaller
(
echo @echo off
echo echo Uninstalling PowerGuard...
echo taskkill /f /im PowerGuard.exe ^>nul 2^>^&1
echo rmdir /s /q "%INSTALL_DIR%"
echo del "%ProgramData%\Microsoft\Windows\Start Menu\Programs\PowerGuard.lnk" ^>nul 2^>^&1
echo del "%PUBLIC%\Desktop\PowerGuard.lnk" ^>nul 2^>^&1
echo reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" /f ^>nul 2^>^&1
echo reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v PowerGuard /f ^>nul 2^>^&1
echo echo PowerGuard has been uninstalled.
echo pause
) > "%INSTALL_DIR%\Uninstall.bat"

:: Ask about auto-start
set /p autostart="Start PowerGuard automatically with Windows? (y/n): "
if /i "%autostart%"=="y" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "PowerGuard" /t REG_SZ /d "%INSTALL_DIR%\PowerGuard.exe" /f >nul
)

:: Create app data directory
if not exist "%APPDATA%\PowerGuard" mkdir "%APPDATA%\PowerGuard"

echo.
echo Installation completed successfully!
echo PowerGuard is now installed and ready to use.
echo.

:: Ask to launch
set /p launch="Launch PowerGuard now? (y/n): "
if /i "%launch%"=="y" (
    start "" "%INSTALL_DIR%\PowerGuard.exe"
)

pause
'@

$InstallBat | Out-File -FilePath (Join-Path $PortableDir "Install.bat") -Encoding ASCII

# Create README
$ReadmeContent = @'
# PowerGuard Portable Installation Package

## Quick Installation

1. Right-click on "Install.bat" and select "Run as administrator"
2. Follow the prompts to complete installation
3. PowerGuard will be available in Start Menu

## Manual Usage (No Installation Required)

You can also run PowerGuard directly without installation:
1. Double-click "PowerGuard.exe" to run the application
2. The application will create its settings in %APPDATA%\PowerGuard\

## What Gets Installed

- Application files in C:\Program Files\PowerGuard\
- Start Menu shortcut
- Optional desktop shortcut
- Optional Windows startup entry
- Uninstaller (C:\Program Files\PowerGuard\Uninstall.bat)

## System Requirements

- Windows 10 or Windows 11
- .NET 8.0 Runtime (included)
- Administrator privileges for installation

## Uninstallation

To remove PowerGuard:
1. Go to C:\Program Files\PowerGuard\
2. Run "Uninstall.bat" as administrator

Or use Windows "Add or Remove Programs" feature.

## Support

For support and updates: https://github.com/powerguard/powerguard
'@

$ReadmeContent | Out-File -FilePath (Join-Path $PortableDir "README.txt") -Encoding UTF8

Write-Host "   ✓ Portable package created" -ForegroundColor Green

# Success message
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "           BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host
Write-Host "Output files:" -ForegroundColor White
Write-Host "   • Portable Package:    $PortableDir" -ForegroundColor Cyan
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

Write-Host "Build completed successfully!" -ForegroundColor Green
