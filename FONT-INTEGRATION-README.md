# Vazir Matn Font Integration for PowerGuard

This document explains how Vazir Matn font has been integrated into PowerGuard for better Persian text rendering.

## Overview

PowerGuard now includes support for the Vazir Matn font family, which provides excellent Persian/Farsi text rendering with proper character spacing, ligatures, and readability.

## What's Been Added

### 1. FontManager Service
- **Location**: `PowerGuard\Services\FontManager.cs`
- **Purpose**: Handles loading and applying Vazir Matn fonts
- **Features**:
  - Loads fonts from embedded resources or external files
  - Provides fallback to Tahoma if Vazir Matn is unavailable
  - Applies fonts to forms and controls automatically
  - Supports different font weights (Regular, Medium, Bold, Light)

### 2. Font Files Integration
- **Location**: `PowerGuard\Resources\Fonts\`
- **Files**: 
  - `Vazirmatn-Regular.ttf` - Main font for regular text
  - `Vazirmatn-Medium.ttf` - Medium weight variant
  - `Vazirmatn-Bold.ttf` - Bold text (buttons, headers)
  - `Vazirmatn-Light.ttf` - Light weight (optional)

### 3. Automatic Font Application
All forms now automatically apply Vazir Matn fonts:
- **MainForm**: Main application interface
- **WelcomeForm**: First-run welcome screen
- **SettingsForm**: Configuration interface
- **ShutdownWarningForm**: Shutdown warning dialog

### 4. Project Configuration
- Fonts are embedded as resources in the executable
- Fonts are also copied to output directory for file-based loading
- Conditional inclusion (only if font files exist)

## How to Get the Fonts

### Option 1: Automatic Download (Recommended)
```batch
# Run the font downloader
download-fonts.bat
```

### Option 2: Manual Download
1. Go to: https://github.com/rastikerdar/vazirmatn/releases
2. Download the latest release
3. Extract the TTF files from the `dist` folder
4. Copy them to `PowerGuard\Resources\Fonts\`

### Option 3: Direct Download Links
- [Vazirmatn-Regular.ttf](https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Regular.ttf)
- [Vazirmatn-Medium.ttf](https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Medium.ttf)
- [Vazirmatn-Bold.ttf](https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Bold.ttf)
- [Vazirmatn-Light.ttf](https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Light.ttf)

## Building with Fonts

### With Fonts Available
```batch
# Download fonts first
download-fonts.bat

# Build the application
dotnet build PowerGuard\PowerGuard.csproj -c Release
```

### Without Fonts (Fallback)
If fonts are not available, the application will:
- Use Tahoma as fallback font
- Still render Persian text correctly
- Log font loading status
- Continue to work normally

## Font Loading Process

1. **Application Startup**: FontManager initializes automatically
2. **Font Discovery**: Searches for fonts in:
   - `Resources\Fonts\` directory (file-based)
   - Embedded resources (resource-based)
3. **Font Loading**: Loads available Vazir Matn fonts into memory
4. **Form Initialization**: Each form applies Vazir Matn fonts on creation
5. **Fallback**: Uses Tahoma if Vazir Matn is unavailable

## Technical Details

### Font Loading Methods
- **File-based**: Loads from `Resources\Fonts\*.ttf` files
- **Resource-based**: Loads from embedded resources
- **Memory-based**: Fonts loaded into PrivateFontCollection

### Font Application
- **Automatic**: Applied to all forms via `FontManager.ApplyVazirMatnFontToForm()`
- **Recursive**: Applied to all child controls
- **Configurable**: Different sizes and styles supported

### Performance
- Fonts loaded once at startup
- Cached in memory for reuse
- Minimal performance impact
- Graceful fallback if loading fails

## Customization

### Using Different Font Sizes
```csharp
// Get custom font size
var customFont = FontManager.GetVazirMatnFont(12F, FontStyle.Bold);
control.Font = customFont;
```

### Applying to New Controls
```csharp
// Apply to a single control
FontManager.ApplyVazirMatnFont(myControl, 10F, FontStyle.Regular);

// Apply to entire form
FontManager.ApplyVazirMatnFontToForm(myForm);
```

### Checking Font Availability
```csharp
if (FontManager.IsVazirMatnAvailable())
{
    // Vazir Matn fonts are loaded
}
else
{
    // Using fallback fonts
}
```

## Troubleshooting

### Fonts Not Loading
1. **Check font files exist**: Verify files in `PowerGuard\Resources\Fonts\`
2. **Check file permissions**: Ensure files are readable
3. **Check logs**: Look for font loading messages in application logs
4. **Rebuild project**: Clean and rebuild to embed resources

### Text Still Using Tahoma
1. **Verify font loading**: Check `FontManager.IsVazirMatnAvailable()`
2. **Check form initialization**: Ensure `ApplyVazirMatnFontToForm()` is called
3. **Check control creation**: New controls may need manual font application

### Build Errors
1. **Missing font files**: Build will succeed but fonts won't be embedded
2. **Resource conflicts**: Check for duplicate resource names
3. **Path issues**: Verify font file paths in project file

## License Information

**Vazir Matn Font License**: SIL Open Font License (OFL)
- ✅ Free for commercial use
- ✅ Can be embedded in applications
- ✅ Can be distributed with software
- ❌ Cannot be sold separately
- ❌ Must retain license information

## Benefits of Vazir Matn

### Typography Improvements
- **Better character spacing**: Optimized for Persian text
- **Proper ligatures**: Correct character connections
- **Improved readability**: Designed specifically for Persian/Farsi
- **Modern appearance**: Clean, professional look

### Technical Benefits
- **Unicode support**: Full Persian character set
- **Cross-platform**: Works on all Windows versions
- **Lightweight**: Small file sizes
- **Well-maintained**: Active development and updates

## File Structure After Integration

```
PowerGuard/
├── Services/
│   └── FontManager.cs              # Font management service
├── Resources/
│   └── Fonts/
│       ├── README.md               # Font installation guide
│       ├── Vazirmatn-Regular.ttf   # Main font file
│       ├── Vazirmatn-Medium.ttf    # Medium weight
│       ├── Vazirmatn-Bold.ttf      # Bold weight
│       └── Vazirmatn-Light.ttf     # Light weight
├── Forms/                          # All forms use Vazir Matn
├── PowerGuard.csproj              # Updated with font resources
├── download-fonts.bat             # Font downloader script
└── download-fonts.ps1             # PowerShell font downloader
```

## Summary

The Vazir Matn font integration provides:
- ✅ **Better Persian text rendering**
- ✅ **Professional appearance**
- ✅ **Automatic font application**
- ✅ **Graceful fallback support**
- ✅ **Easy font management**
- ✅ **No breaking changes**

The application will work with or without the fonts, but Persian text will look significantly better with Vazir Matn installed.
