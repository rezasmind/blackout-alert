# Copy Vazir Matn fonts from ttf folder to PowerGuard Resources/Fonts

Write-Host "Copying Vazir Matn fonts..." -ForegroundColor Cyan

# Ensure destination directory exists
$destDir = "PowerGuard\Resources\Fonts"
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Write-Host "Created directory: $destDir" -ForegroundColor Green
}

# Copy all TTF files
$sourceDir = "ttf"
if (Test-Path $sourceDir) {
    $fontFiles = Get-ChildItem "$sourceDir\*.ttf"
    
    foreach ($font in $fontFiles) {
        $destPath = Join-Path $destDir $font.Name
        Copy-Item $font.FullName $destPath -Force
        Write-Host "Copied: $($font.Name)" -ForegroundColor Green
    }
    
    Write-Host "`nSuccessfully copied $($fontFiles.Count) font files!" -ForegroundColor Green
} else {
    Write-Host "Error: ttf directory not found!" -ForegroundColor Red
    exit 1
}

# List copied fonts
Write-Host "`nCopied fonts:" -ForegroundColor Yellow
Get-ChildItem "$destDir\*.ttf" | ForEach-Object {
    $size = [math]::Round($_.Length / 1KB, 1)
    Write-Host "  $($_.Name) ($size KB)" -ForegroundColor Cyan
}
