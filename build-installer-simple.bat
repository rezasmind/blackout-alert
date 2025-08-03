@echo off
echo ========================================
echo    PowerGuard Simple Installer Build
echo ========================================
echo.

:: Step 1: Build PowerGuard Application
echo [1/3] Building PowerGuard Application...
dotnet build PowerGuard\PowerGuard.csproj -c Release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build application
    pause
    exit /b 1
)

:: Step 2: Publish Application
echo [2/3] Publishing Application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\
if %errorlevel% neq 0 (
    echo ERROR: Failed to publish application
    pause
    exit /b 1
)

:: Step 3: Build Installer using WiX project
echo [3/3] Building Installer...
if exist "PowerGuard.Installer" (
    dotnet build PowerGuard.Installer\PowerGuard.Installer.wixproj -c Release
    if %errorlevel% neq 0 (
        echo ERROR: Failed to build installer
        echo Make sure WiX Toolset v4 is installed
        pause
        exit /b 1
    )
    
    :: Copy installer to Output directory
    if not exist "Output" mkdir Output
    copy "PowerGuard.Installer\bin\Release\*.msi" "Output\" >nul 2>&1
    
    echo.
    echo ✓ Build completed successfully!
    echo ✓ Installer: Output\PowerGuardSetup.msi
) else (
    echo ERROR: PowerGuard.Installer directory not found
    pause
    exit /b 1
)

echo.
pause
