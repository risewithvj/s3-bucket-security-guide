$bucketUrl = "https://bucketname.s3.ap-south-1.amazonaws.com" or use this "https://bucketname.s3.ap-south-1.amazonaws.com"

$paths = Get-Content -Path "s3_objects.txt"

foreach ($path in $paths) {
    $fileUrl = "$bucketUrl/$path"
    $outFile = "downloads\$($path -replace '/','_')"
    Invoke-WebRequest -Uri $fileUrl -OutFile $outFile
}
