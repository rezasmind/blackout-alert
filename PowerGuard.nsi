; PowerGuard NSIS Installer Script
; This script creates a Windows installer for PowerGuard application

;--------------------------------
; Modern UI
!include "MUI2.nsh"
!include "FileFunc.nsh"

;--------------------------------
; General Settings
Name "محافظ برق - PowerGuard"
OutFile "Output\PowerGuardSetup.exe"
InstallDir "$PROGRAMFILES\PowerGuard"
InstallDirRegKey HKLM "Software\PowerGuard" "InstallPath"
RequestExecutionLevel admin

; Version Information
VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "PowerGuard"
VIAddVersionKey "ProductVersion" "1.0.0"
VIAddVersionKey "CompanyName" "PowerGuard Team"
VIAddVersionKey "FileDescription" "PowerGuard Installer"
VIAddVersionKey "FileVersion" "1.0.0.0"
VIAddVersionKey "LegalCopyright" "© 2025 PowerGuard Team"

;--------------------------------
; Interface Settings
!define MUI_ABORTWARNING
!define MUI_ICON "PowerGuard\Resources\powerguard.ico"
!define MUI_UNICON "PowerGuard\Resources\powerguard.ico"

; Welcome page text
!define MUI_WELCOMEPAGE_TITLE "خوش آمدید به نصب‌کننده محافظ برق"
!define MUI_WELCOMEPAGE_TEXT "این برنامه به شما کمک می‌کند تا از از دست رفتن داده‌ها در هنگام قطعی برق برنامه‌ریزی شده جلوگیری کنید.$\r$\n$\r$\nبرای ادامه روی 'بعدی' کلیک کنید."

; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\PowerGuard.exe"
!define MUI_FINISHPAGE_RUN_TEXT "اجرای محافظ برق"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\README.md"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "نمایش راهنما"

;--------------------------------
; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Languages
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Installer Sections

Section "PowerGuard Application" SecMain
    SectionIn RO ; Read-only section
    
    ; Set output path to the installation directory
    SetOutPath $INSTDIR
    
    ; Copy application files
    File "PowerGuard\bin\Release\net8.0-windows\PowerGuard.exe"
    File "PowerGuard\bin\Release\net8.0-windows\PowerGuard.dll"
    File "PowerGuard\bin\Release\net8.0-windows\PowerGuard.runtimeconfig.json"
    File "PowerGuard\bin\Release\net8.0-windows\PowerGuard.deps.json"
    
    ; Copy dependencies
    File "PowerGuard\bin\Release\net8.0-windows\*.dll"
    
    ; Copy documentation
    File "PowerGuard\README.md"
    
    ; Create application data directory
    CreateDirectory "$APPDATA\PowerGuard"
    
    ; Write registry keys
    WriteRegStr HKLM "Software\PowerGuard" "InstallPath" $INSTDIR
    WriteRegStr HKLM "Software\PowerGuard" "Version" "1.0.0"
    WriteRegStr HKLM "Software\PowerGuard" "DisplayName" "محافظ برق - PowerGuard"
    
    ; Write uninstall information
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "DisplayName" "محافظ برق - PowerGuard"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "DisplayVersion" "1.0.0"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "Publisher" "PowerGuard Team"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "InstallLocation" $INSTDIR
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "DisplayIcon" "$INSTDIR\PowerGuard.exe"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "NoRepair" 1
    
    ; Calculate and write estimated size
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "EstimatedSize" "$0"
    
    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
SectionEnd

Section "Start Menu Shortcuts" SecStartMenu
    CreateDirectory "$SMPROGRAMS\PowerGuard"
    CreateShortcut "$SMPROGRAMS\PowerGuard\محافظ برق.lnk" "$INSTDIR\PowerGuard.exe"
    CreateShortcut "$SMPROGRAMS\PowerGuard\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Desktop Shortcut" SecDesktop
    CreateShortcut "$DESKTOP\محافظ برق.lnk" "$INSTDIR\PowerGuard.exe"
SectionEnd

Section "Auto Start" SecAutoStart
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "PowerGuard" "$INSTDIR\PowerGuard.exe"
SectionEnd

;--------------------------------
; Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} "فایل‌های اصلی برنامه محافظ برق"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} "میانبرهای منوی شروع"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktop} "میانبر دسکتاپ"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecAutoStart} "اجرای خودکار با ویندوز"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller Section

Section "Uninstall"
    
    ; Stop running application
    ExecWait "taskkill /f /im PowerGuard.exe" $0
    
    ; Remove files
    Delete "$INSTDIR\PowerGuard.exe"
    Delete "$INSTDIR\PowerGuard.dll"
    Delete "$INSTDIR\PowerGuard.runtimeconfig.json"
    Delete "$INSTDIR\PowerGuard.deps.json"
    Delete "$INSTDIR\*.dll"
    Delete "$INSTDIR\README.md"
    Delete "$INSTDIR\Uninstall.exe"
    
    ; Remove directories
    RMDir "$INSTDIR"
    
    ; Remove shortcuts
    Delete "$SMPROGRAMS\PowerGuard\محافظ برق.lnk"
    Delete "$SMPROGRAMS\PowerGuard\Uninstall.lnk"
    RMDir "$SMPROGRAMS\PowerGuard"
    Delete "$DESKTOP\محافظ برق.lnk"
    
    ; Remove registry keys
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard"
    DeleteRegKey HKLM "Software\PowerGuard"
    DeleteRegValue HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "PowerGuard"
    
    ; Ask user if they want to remove application data
    MessageBox MB_YESNO "آیا می‌خواهید تنظیمات و داده‌های برنامه را نیز حذف کنید؟" IDNO skip_appdata
    RMDir /r "$APPDATA\PowerGuard"
    skip_appdata:
    
SectionEnd

;--------------------------------
; Functions

Function .onInit
    ; Check if already installed
    ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PowerGuard" "UninstallString"
    StrCmp $R0 "" done
    
    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "محافظ برق قبلاً نصب شده است. آیا می‌خواهید ابتدا آن را حذف کنید؟" IDOK uninst
    Abort
    
    uninst:
        ClearErrors
        ExecWait '$R0 _?=$INSTDIR'
        
        IfErrors no_remove_uninstaller done
        no_remove_uninstaller:
    
    done:
FunctionEnd
