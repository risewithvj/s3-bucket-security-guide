<#
.SYNOPSIS
Resumes fetching paths from where a previous run stopped
.DESCRIPTION
Continues listing objects starting after a specific marker path
#>

# Configuration
$bucketName = "yourbucketname"
$region = "ap-south-1"
$outputFile = "S3_Resumed_Paths.txt"
$startMarker = "files/2023/risewithvj/learnmore.pdf"  # Replace with your last marker
$baseUrl = "https://$bucketName.s3.$region.amazonaws.com/"

# Initialize
$allObjects = @()
$marker = $startMarker
$batchCount = 0
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Create output file with resume header
"# RESUMED LISTING FROM MARKER: $startMarker" | Out-File -FilePath $outputFile -Encoding UTF8
"# $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
"" | Out-File -FilePath $outputFile -Encoding UTF8 -Append

function Get-S3Batch {
    param($marker)
    $url = $baseUrl + "?marker=$([Uri]::EscapeDataString($marker))"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
        $xml = [xml]$response.Content
        return $xml.ListBucketResult.Contents.Key
    }
    catch {
        Write-Host "Error: $_" -ForegroundColor Red
        return $null
    }
}

Write-Host "Resuming from marker: $startMarker" -ForegroundColor Cyan

do {
    $batchCount++
    $objects = Get-S3Batch -marker $marker

    if ($objects -and $objects.Count -gt 0) {
        $objects | Out-File -FilePath $outputFile -Encoding UTF8 -Append
        $allObjects += $objects
        $marker = $objects[-1]

        # Progress reporting
        $rate = [math]::Round($allObjects.Count / $stopwatch.Elapsed.TotalSeconds)
        Write-Progress -Activity "Resuming Fetch" -Status "$rate objects/sec | Total: $($allObjects.Count)" -PercentComplete (($batchCount % 100))
        
        Write-Host "Batch $batchCount: Added $($objects.Count) paths (Total: $($allObjects.Count))"
        
        # Slight delay
        Start-Sleep -Milliseconds 200
    }
    else {
        Write-Host "No more objects found" -ForegroundColor Green
        break
    }
} while ($true)

$stopwatch.Stop()
Write-Host "`nResume completed in $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan
Write-Host "New paths fetched: $($allObjects.Count)" -ForegroundColor Cyan
Write-Host "Saved to: $outputFile" -ForegroundColor Cyan
Write-Host "Last marker: $marker" -ForegroundColor Cyan