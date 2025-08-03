@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    PowerGuard Installer Build Script
echo ========================================
echo.

:: Check if WiX is installed
where wix >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: WiX Toolset v4 is not installed or not in PATH
    echo Please install WiX Toolset v4 from: https://wixtoolset.org/
    echo.
    echo Alternative: Install via dotnet tool:
    echo   dotnet tool install --global wix
    pause
    exit /b 1
)

:: Step 1: Clean previous builds
echo [1/5] Cleaning previous builds...
if exist "PowerGuard\bin" rmdir /s /q "PowerGuard\bin"
if exist "PowerGuard\obj" rmdir /s /q "PowerGuard\obj"
if exist "PowerGuard.Installer\bin" rmdir /s /q "PowerGuard.Installer\bin"
if exist "PowerGuard.Installer\obj" rmdir /s /q "PowerGuard.Installer\obj"
if exist "Output" rmdir /s /q "Output"
mkdir Output
echo   ✓ Cleanup completed

:: Step 2: Build PowerGuard Application
echo.
echo [2/5] Building PowerGuard Application...
dotnet build PowerGuard\PowerGuard.csproj -c Release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build PowerGuard application
    pause
    exit /b 1
)
echo   ✓ Application build completed

:: Step 3: Publish PowerGuard Application (Framework-dependent)
echo.
echo [3/5] Publishing PowerGuard Application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build
if %errorlevel% neq 0 (
    echo ERROR: Failed to publish PowerGuard application
    pause
    exit /b 1
)
echo   ✓ Application publish completed

:: Step 4: Create Self-Contained Version (Optional)
echo.
echo [4/5] Creating self-contained version...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -o Output\Standalone\
if %errorlevel% neq 0 (
    echo WARNING: Failed to create self-contained version
) else (
    echo   ✓ Self-contained version created in Output\Standalone\
)

:: Step 5: Build WiX Installer
echo.
echo [5/5] Building WiX Installer...

:: Check if all required files exist
if not exist "PowerGuard\bin\Release\net8.0-windows\PowerGuard.exe" (
    echo ERROR: PowerGuard.exe not found in build output
    pause
    exit /b 1
)

:: Build the installer
wix build PowerGuard.Installer\Product.wxs PowerGuard.Installer\Components.wxs PowerGuard.Installer\UI.wxs -o Output\PowerGuardSetup.msi -ext WixToolset.UI.wixext
if %errorlevel% neq 0 (
    echo ERROR: Failed to build installer
    echo.
    echo Common issues:
    echo - Missing WiX Toolset v4
    echo - Missing resource files in PowerGuard.Installer\Resources\
    echo - Build output files not found
    pause
    exit /b 1
)

echo   ✓ Installer build completed

:: Success message
echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Output files:
echo   • Installer:           Output\PowerGuardSetup.msi
echo   • Standalone App:      Output\Standalone\PowerGuard.exe
echo   • Framework App:       PowerGuard\bin\Release\net8.0-windows\
echo.
echo Installation Instructions:
echo 1. Double-click PowerGuardSetup.msi to install
echo 2. Follow the installation wizard
echo 3. PowerGuard will be available in Start Menu and Desktop
echo.

:: Optional: Test the installer
set /p test="Do you want to test the installer now? (y/n): "
if /i "%test%"=="y" (
    echo.
    echo Starting installer...
    start "" "Output\PowerGuardSetup.msi"
)

echo.
echo Build completed successfully!
pause
