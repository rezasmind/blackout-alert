# PowerGuard Font Downloader
# This script downloads Vazir Matn fonts for better Persian text rendering

param(
    [string]$FontsPath = "PowerGuard\Resources\Fonts"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PowerGuard Font Downloader" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host

# Create fonts directory if it doesn't exist
if (-not (Test-Path $FontsPath)) {
    New-Item -ItemType Directory -Path $FontsPath -Force | Out-Null
    Write-Host "Created fonts directory: $FontsPath" -ForegroundColor Green
}

# Font URLs from Vazir Matn repository
$fonts = @{
    "Vazirmatn-Regular.ttf" = "https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Regular.ttf"
    "Vazirmatn-Medium.ttf" = "https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Medium.ttf"
    "Vazirmatn-Bold.ttf" = "https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Bold.ttf"
    "Vazirmatn-Light.ttf" = "https://github.com/rastikerdar/vazirmatn/raw/master/dist/Vazirmatn-Light.ttf"
}

$downloadedCount = 0
$totalCount = $fonts.Count

Write-Host "Downloading Vazir Matn fonts..." -ForegroundColor Yellow
Write-Host

foreach ($font in $fonts.GetEnumerator()) {
    $fileName = $font.Key
    $url = $font.Value
    $filePath = Join-Path $FontsPath $fileName
    
    Write-Host "[$($downloadedCount + 1)/$totalCount] Downloading $fileName..." -ForegroundColor Cyan
    
    try {
        # Check if file already exists
        if (Test-Path $filePath) {
            $fileSize = (Get-Item $filePath).Length
            if ($fileSize -gt 1000) {  # If file is larger than 1KB, assume it's valid
                Write-Host "   ✓ $fileName already exists ($('{0:N0}' -f $fileSize) bytes)" -ForegroundColor Green
                $downloadedCount++
                continue
            }
        }
        
        # Download the font
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "PowerGuard Font Downloader")
        $webClient.DownloadFile($url, $filePath)
        
        # Verify download
        if (Test-Path $filePath) {
            $fileSize = (Get-Item $filePath).Length
            if ($fileSize -gt 1000) {
                Write-Host "   ✓ Downloaded successfully ($('{0:N0}' -f $fileSize) bytes)" -ForegroundColor Green
                $downloadedCount++
            } else {
                Write-Host "   ✗ Download failed - file too small" -ForegroundColor Red
                Remove-Item $filePath -ErrorAction SilentlyContinue
            }
        } else {
            Write-Host "   ✗ Download failed - file not created" -ForegroundColor Red
        }
        
        $webClient.Dispose()
    }
    catch {
        Write-Host "   ✗ Download failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500  # Be nice to the server
}

Write-Host
Write-Host "========================================" -ForegroundColor Green
Write-Host "           DOWNLOAD COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host

if ($downloadedCount -eq $totalCount) {
    Write-Host "✓ All fonts downloaded successfully!" -ForegroundColor Green
    Write-Host "✓ Fonts location: $FontsPath" -ForegroundColor Green
    Write-Host
    Write-Host "The following fonts are now available:" -ForegroundColor White
    
    Get-ChildItem $FontsPath -Filter "*.ttf" | ForEach-Object {
        $size = '{0:N0}' -f $_.Length
        Write-Host "   • $($_.Name) ($size bytes)" -ForegroundColor Cyan
    }
    
    Write-Host
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Build the PowerGuard application" -ForegroundColor Gray
    Write-Host "2. The fonts will be automatically embedded and used" -ForegroundColor Gray
    Write-Host "3. Persian text will render with improved typography" -ForegroundColor Gray
    
} elseif ($downloadedCount -gt 0) {
    Write-Host "⚠ Partial success: $downloadedCount/$totalCount fonts downloaded" -ForegroundColor Yellow
    Write-Host "The application will work with available fonts and fall back to Tahoma for missing ones." -ForegroundColor Gray
} else {
    Write-Host "✗ No fonts were downloaded successfully" -ForegroundColor Red
    Write-Host "The application will fall back to Tahoma font for Persian text." -ForegroundColor Gray
    Write-Host
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "• Check your internet connection" -ForegroundColor Gray
    Write-Host "• Verify that GitHub is accessible" -ForegroundColor Gray
    Write-Host "• Try running as administrator" -ForegroundColor Gray
    Write-Host "• Manual download: https://github.com/rastikerdar/vazirmatn/releases" -ForegroundColor Gray
}

Write-Host
Write-Host "Font download process completed!" -ForegroundColor Green
