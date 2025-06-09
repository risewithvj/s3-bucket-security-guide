# Usage Guide

## 1. Fetch All Paths

```powershell
.\scripts\Get-S3AllPaths.ps1 -BucketName "yourbucket" -Region "us-east-1"
```

## 2. Resume Interrupted Fetch

```powershell
.\scripts\Resume-S3Paths.ps1 -StartMarker "path/to/last/file.txt"
```

## 3. Bulk Download Files

```powershell
.\scripts\Get-S3Files.ps1 -InputFile "paths.txt" -DownloadFolder "downloads"
```

## Common Parameters

| Parameter        | Description                          | Default Value       |
|------------------|--------------------------------------|---------------------|
| -BucketName      | Name of your S3 bucket               | "yourbuckername"       |
| -Region          | AWS region for the bucket            | "ap-south-1"        |
| -OutputFile      | Path to save the file listings       | "S3_All_Paths.txt"  |