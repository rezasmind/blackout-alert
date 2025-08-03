@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   PowerGuard NSIS Installer Build
echo ========================================
echo.

:: Check if NSIS is installed
where makensis >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: NSIS (Nullsoft Scriptable Install System) is not installed or not in PATH
    echo.
    echo Please install NSIS from: https://nsis.sourceforge.io/
    echo After installation, add NSIS to your PATH or run this script from NSIS directory
    echo.
    echo Alternative locations to check:
    echo   - C:\Program Files (x86)\NSIS\makensis.exe
    echo   - C:\Program Files\NSIS\makensis.exe
    echo.
    pause
    exit /b 1
)

:: Step 1: Clean and prepare
echo [1/4] Preparing build environment...
if exist "Output" rmdir /s /q "Output"
mkdir Output
echo   ✓ Output directory prepared

:: Step 2: Build PowerGuard Application
echo.
echo [2/4] Building PowerGuard Application...
dotnet build PowerGuard\PowerGuard.csproj -c Release
if %errorlevel% neq 0 (
    echo ERROR: Failed to build PowerGuard application
    pause
    exit /b 1
)
echo   ✓ Application build completed

:: Step 3: Publish PowerGuard Application
echo.
echo [3/4] Publishing PowerGuard Application...
dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\ --no-build
if %errorlevel% neq 0 (
    echo ERROR: Failed to publish PowerGuard application
    pause
    exit /b 1
)
echo   ✓ Application publish completed

:: Step 4: Create LICENSE.txt if it doesn't exist
if not exist "LICENSE.txt" (
    echo Creating LICENSE.txt...
    echo MIT License > LICENSE.txt
    echo. >> LICENSE.txt
    echo Copyright ^(c^) 2025 PowerGuard Team >> LICENSE.txt
    echo. >> LICENSE.txt
    echo Permission is hereby granted, free of charge, to any person obtaining a copy >> LICENSE.txt
    echo of this software and associated documentation files ^(the "Software"^), to deal >> LICENSE.txt
    echo in the Software without restriction, including without limitation the rights >> LICENSE.txt
    echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell >> LICENSE.txt
    echo copies of the Software, and to permit persons to whom the Software is >> LICENSE.txt
    echo furnished to do so, subject to the following conditions: >> LICENSE.txt
    echo. >> LICENSE.txt
    echo The above copyright notice and this permission notice shall be included in all >> LICENSE.txt
    echo copies or substantial portions of the Software. >> LICENSE.txt
    echo. >> LICENSE.txt
    echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR >> LICENSE.txt
    echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, >> LICENSE.txt
    echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE >> LICENSE.txt
    echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER >> LICENSE.txt
    echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, >> LICENSE.txt
    echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE >> LICENSE.txt
    echo SOFTWARE. >> LICENSE.txt
)

:: Step 5: Build NSIS Installer
echo.
echo [4/4] Building NSIS Installer...

:: Check if all required files exist
if not exist "PowerGuard\bin\Release\net8.0-windows\PowerGuard.exe" (
    echo ERROR: PowerGuard.exe not found in build output
    echo Expected location: PowerGuard\bin\Release\net8.0-windows\PowerGuard.exe
    pause
    exit /b 1
)

:: Build the installer
makensis PowerGuard.nsi
if %errorlevel% neq 0 (
    echo ERROR: Failed to build NSIS installer
    echo.
    echo Common issues:
    echo - Missing NSIS installation
    echo - Missing application files
    echo - Syntax errors in PowerGuard.nsi
    pause
    exit /b 1
)

echo   ✓ NSIS installer build completed

:: Success message
echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Output files:
echo   • Installer:           Output\PowerGuardSetup.exe
echo   • Application:         PowerGuard\bin\Release\net8.0-windows\
echo.
echo Installation Instructions:
echo 1. Double-click PowerGuardSetup.exe to install
echo 2. Follow the installation wizard
echo 3. PowerGuard will be available in Start Menu and Desktop
echo.
echo Installer Features:
echo   ✓ Persian language support
echo   ✓ Start Menu shortcuts
echo   ✓ Desktop shortcut (optional)
echo   ✓ Auto-start with Windows (optional)
echo   ✓ Proper uninstaller
echo   ✓ Registry integration
echo   ✓ Application data management
echo.

:: Optional: Test the installer
set /p test="Do you want to test the installer now? (y/n): "
if /i "%test%"=="y" (
    echo.
    echo Starting installer...
    start "" "Output\PowerGuardSetup.exe"
)

echo.
echo Build completed successfully!
pause
