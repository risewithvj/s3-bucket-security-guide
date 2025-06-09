<#
.SYNOPSIS
Fetches all file paths from a public S3 bucket and saves to a text file
.DESCRIPTION
This script lists all objects in a public S3 bucket, handling pagination for buckets with more than 1000 files
#>

# Configuration
$bucketName = "vsplbucket1"
$region = "ap-south-1"
$outputFile = "S3_All_Paths.txt"
$baseUrl = "https://$bucketName.s3.$region.amazonaws.com/"

# Initialize
$allObjects = @()
$marker = $null
$batchCount = 0
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Create output file with header
"# S3 Bucket Path Listing - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath $outputFile -Encoding UTF8
"# Bucket: $bucketName" | Out-File -FilePath $outputFile -Encoding UTF8 -Append
"" | Out-File -FilePath $outputFile -Encoding UTF8 -Append

function Get-S3Batch {
    param($marker)
    $url = $baseUrl + $(if ($marker) { "?marker=$([Uri]::EscapeDataString($marker))" })
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

Write-Host "Starting full bucket path listing..." -ForegroundColor Cyan

do {
    $batchCount++
    $objects = Get-S3Batch -marker $marker

    if ($objects -and $objects.Count -gt 0) {
        $objects | Out-File -FilePath $outputFile -Encoding UTF8 -Append
        $allObjects += $objects
        $marker = $objects[-1]

        # Progress reporting
        $rate = [math]::Round($allObjects.Count / $stopwatch.Elapsed.TotalSeconds)
        Write-Progress -Activity "Fetching Paths" -Status "$rate objects/sec | Total: $($allObjects.Count)" -PercentComplete (($batchCount % 100))
        
        Write-Host "Batch $batchCount: Added $($objects.Count) paths (Total: $($allObjects.Count))"
        
        # Slight delay to avoid throttling
        Start-Sleep -Milliseconds 200
    }
    else {
        Write-Host "No more objects found" -ForegroundColor Green
        break
    }
} while ($true)

$stopwatch.Stop()
Write-Host "`nCompleted in $($stopwatch.Elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan
Write-Host "Total paths fetched: $($allObjects.Count)" -ForegroundColor Cyan
Write-Host "Saved to: $outputFile" -ForegroundColor Cyan
Write-Host "Last marker: $marker" -ForegroundColor Cyan