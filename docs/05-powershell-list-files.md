<# 
.SYNOPSIS
List ALL objects from a public S3 bucket
.DESCRIPTION
Handles pagination and outputs to file
#>

$bucketUrl = "https://bucketname.s3.ap-south-1.amazonaws.com" or use this "https://bucketname.s3.amazonaws.com"

$outputFile = "s3_objects.txt"
$marker = ""

do {
    $url = "$bucketUrl/?marker=$marker"
    $response = Invoke-WebRequest -Uri $url
    $xml = [xml]$response.Content
    $xml.ListBucketResult.Contents | ForEach-Object {
        $_.Key | Out-File -Append -FilePath $outputFile
    }
    $marker = $xml.ListBucketResult.IsTruncated -eq "true" ? $xml.ListBucketResult.Contents[-1].Key : $null
} while ($marker)
