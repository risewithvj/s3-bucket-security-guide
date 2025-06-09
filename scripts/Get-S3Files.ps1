<#
.SYNOPSIS
Downloads all files from paths listed in a text file
.DESCRIPTION
Reads paths from a text file and downloads each file from the public S3 bucket
#>

# Configuration
$bucketName = "yourbucketname"
$region = "ap-south-1"
$baseUrl = "https://$bucketName.s3.$region.amazonaws.com/"
$inputFile = "S3_All_Paths.txt"  # Your path file
$downloadFolder = "S3_Downloads"
$parallelDownloads = 5  # Number of simultaneous downloads

# Initialize
$paths = Get-Content $inputFile | Where-Object { $_ -notmatch '^#' -and $_ -ne '' }
$totalFiles = $paths.Count
$completed = 0
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Create download folder if not exists
if (-not (Test-Path $downloadFolder)) {
    New-Item -ItemType Directory -Path $downloadFolder | Out-Null
}

function Download-File {
    param($filePath)
    $localPath = Join-Path $downloadFolder $filePath
    $localDir = [System.IO.Path]::GetDirectoryName($localPath)
    
    # Create directory structure if needed
    if (-not (Test-Path $localDir)) {
        New-Item -ItemType Directory -Path $localDir -Force | Out-Null
    }
    
    $url = $baseUrl + [Uri]::EscapeDataString($filePath)
    try {
        Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing -ErrorAction Stop
        return $true
    }
    catch {
        Write-Host "Failed to download $filePath : $_" -ForegroundColor Red
        return $false
    }
}

Write-Host "Starting download of $totalFiles files..." -ForegroundColor Cyan

# Process files in parallel
$paths | ForEach-Object -Parallel {
    $result = Download-File $_
    $completed = [System.Threading.Interlocked]::Increment([ref]$using:completed)
    
    $progress = [math]::Round(($completed / $using:totalFiles) * 100)
    $rate = [math]::Round($completed / $using:stopwatch.Elapsed.TotalSeconds)
    
    Write-Progress -Activity "Downloading Files" -Status "$progress% Complete ($completed/$using:totalFiles)" `
                  -CurrentOperation "$rate files/sec" -PercentComplete $progress
    
    if ($result) {
        Write-Host "Downloaded: $_" -ForegroundColor Green
    }
} -ThrottleLimit $parallelDownloads

$stopwatch.Stop()
Write-Host "`nDownload completed in $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan
Write-Host "Files downloaded: $completed/$totalFiles" -ForegroundColor Cyan
Write-Host "Saved to: $downloadFolder" -ForegroundColor Cyan