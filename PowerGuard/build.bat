@echo off
echo Building PowerGuard...
dotnet build PowerGuard.csproj -c Release

echo.
echo Creating standalone executable...
dotnet publish PowerGuard.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -o bin\Release\Standalone

echo.
echo Build complete! 
echo Executable location: bin\Release\Standalone\PowerGuard.exe
pause
