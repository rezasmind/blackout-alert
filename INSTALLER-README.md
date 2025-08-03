# PowerGuard Installer Guide

This guide explains how to create installers for the PowerGuard application using different installer technologies.

## Available Installer Options

### 1. NSIS Installer (Recommended)
**File**: `PowerGuard.nsi`  
**Output**: `PowerGuardSetup.exe`  
**Build Script**: `build-nsis-installer.bat`

**Advantages**:
- ✅ Easy to use and configure
- ✅ Small installer size
- ✅ Persian language support
- ✅ Modern UI with custom branding
- ✅ Comprehensive uninstaller
- ✅ No additional dependencies

### 2. WiX Installer (Advanced)
**Files**: `PowerGuard.Installer\*.wxs`  
**Output**: `PowerGuardSetup.msi`  
**Build Script**: `build-installer.bat`

**Advantages**:
- ✅ Professional MSI format
- ✅ Enterprise deployment support
- ✅ Windows Installer features
- ✅ Group Policy deployment
- ❌ More complex setup

## Prerequisites

### For NSIS Installer
1. **NSIS (Nullsoft Scriptable Install System)**
   - Download from: https://nsis.sourceforge.io/
   - Install and add to PATH
   - Version 3.0+ recommended

### For WiX Installer
1. **WiX Toolset v4**
   - Install via: `dotnet tool install --global wix`
   - Or download from: https://wixtoolset.org/

## Building the Installer

### Option 1: NSIS Installer (Easiest)

```batch
# Run the build script
build-nsis-installer.bat
```

**Manual Steps**:
1. Build PowerGuard application:
   ```batch
   dotnet build PowerGuard\PowerGuard.csproj -c Release
   dotnet publish PowerGuard\PowerGuard.csproj -c Release -o PowerGuard\bin\Release\net8.0-windows\
   ```

2. Build installer:
   ```batch
   makensis PowerGuard.nsi
   ```

### Option 2: WiX Installer (Advanced)

```batch
# Run the build script
build-installer.bat
```

**Manual Steps**:
1. Build PowerGuard application (same as above)
2. Build installer:
   ```batch
   wix build PowerGuard.Installer\Product.wxs PowerGuard.Installer\Components.wxs PowerGuard.Installer\UI.wxs -o Output\PowerGuardSetup.msi
   ```

## Installer Features

### Installation Features
- ✅ **Application Files**: Installs PowerGuard.exe and all dependencies
- ✅ **Start Menu Shortcuts**: Creates "محافظ برق" in Start Menu
- ✅ **Desktop Shortcut**: Optional desktop shortcut
- ✅ **Auto-Start**: Optional Windows startup registration
- ✅ **Registry Integration**: Proper Windows integration
- ✅ **Application Data**: Creates %APPDATA%\PowerGuard directory

### Uninstallation Features
- ✅ **Complete Removal**: Removes all installed files
- ✅ **Registry Cleanup**: Removes all registry entries
- ✅ **Shortcut Cleanup**: Removes all shortcuts
- ✅ **Process Termination**: Stops running PowerGuard instances
- ✅ **User Data**: Optional removal of user settings

### Persian Language Support
- ✅ **UI Text**: All installer text in Persian
- ✅ **RTL Layout**: Right-to-left text layout
- ✅ **Persian Shortcuts**: Shortcuts named in Persian
- ✅ **Error Messages**: Persian error messages

## Customization

### NSIS Customization
Edit `PowerGuard.nsi` to customize:
- **Installer Text**: Modify `MUI_WELCOMEPAGE_TEXT` and other text constants
- **Icons**: Change `MUI_ICON` and `MUI_UNICON` paths
- **Sections**: Add/remove installation components
- **Registry Keys**: Modify registry entries

### WiX Customization
Edit WiX files to customize:
- **Product.wxs**: Main product information and features
- **Components.wxs**: File components and registry entries
- **UI.wxs**: User interface and custom actions

## Troubleshooting

### Common Issues

#### NSIS Build Errors
```
Error: Can't open script file
```
**Solution**: Ensure `PowerGuard.nsi` exists and NSIS is properly installed

```
Error: File not found: PowerGuard\bin\Release\net8.0-windows\PowerGuard.exe
```
**Solution**: Build the PowerGuard application first

#### WiX Build Errors
```
Error: WiX Toolset not found
```
**Solution**: Install WiX Toolset v4 and ensure it's in PATH

```
Error: Missing resource files
```
**Solution**: Create required image files in `PowerGuard.Installer\Resources\`

### Build Environment Issues

#### .NET SDK Not Found
```batch
dotnet build
# 'dotnet' is not recognized as an internal or external command
```
**Solution**: Install .NET 8.0 SDK from https://dotnet.microsoft.com/

#### Permission Errors
```
Access denied
```
**Solution**: Run command prompt as Administrator

## Testing the Installer

### Installation Testing
1. **Clean Environment**: Test on a clean Windows VM
2. **Install Process**: Run installer and verify all components
3. **Application Launch**: Ensure PowerGuard starts correctly
4. **Shortcuts**: Verify all shortcuts work
5. **Auto-Start**: Check Windows startup registration

### Uninstallation Testing
1. **Complete Removal**: Verify all files are removed
2. **Registry Cleanup**: Check registry entries are cleaned
3. **User Data**: Test optional user data removal
4. **No Leftovers**: Ensure no orphaned files or registry entries

## Distribution

### Installer Signing (Recommended)
For production distribution, sign the installer:

```batch
# Using signtool (requires code signing certificate)
signtool sign /f certificate.pfx /p password /t http://timestamp.digicert.com Output\PowerGuardSetup.exe
```

### Antivirus Considerations
- Submit installer to antivirus vendors for whitelisting
- Use reputable code signing certificate
- Test with major antivirus solutions

## File Structure

```
Project Root/
├── PowerGuard/                     # Main application
├── PowerGuard.Installer/           # WiX installer files
│   ├── Product.wxs
│   ├── Components.wxs
│   ├── UI.wxs
│   └── Resources/
├── PowerGuard.nsi                  # NSIS installer script
├── build-installer.bat             # WiX build script
├── build-nsis-installer.bat        # NSIS build script
├── LICENSE.txt                     # License file
└── Output/                         # Build output
    ├── PowerGuardSetup.exe         # NSIS installer
    └── PowerGuardSetup.msi         # WiX installer
```

## Support

For installer-related issues:
1. Check this README for common solutions
2. Verify prerequisites are installed
3. Test on a clean Windows environment
4. Check installer logs for detailed error information

---

**Note**: The NSIS installer is recommended for most users due to its simplicity and comprehensive Persian language support.
