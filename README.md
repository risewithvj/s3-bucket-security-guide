# 🔐 AWS S3 Public Access Awareness & Protection Guide

This repository is for **educational and ethical purposes only**. It demonstrates how AWS S3 buckets can be accidentally exposed publicly, how those files may be indexed by search engines, and how attackers can use PowerShell to list/download files.

Most importantly, it also teaches how to **prevent** such exposure and secure your data.

---

**🔗 Authored & Researched by:** [Vijaya Kumar L](https://www.linkedin.com/in/vijayakumarl)
**GitHub:** [github.com/risewithvj](http://github.com/risewithvj)

---

## 📖 Contents

1. [How S3 Buckets Get Public Access](#1-how-s3-buckets-get-public-access)
2. [How Files Get Indexed by Search Engines](#2-how-files-get-indexed-by-search-engines)
3. [How to Prevent Search Engine Indexing](#3-how-to-prevent-search-engine-indexing)
4. [Finding Indexed Files of S3 Buckets](#4-finding-indexed-files-of-s3-buckets)
5. [Listing Public S3 Files using PowerShell](#5-listing-public-s3-files-using-powershell)
6. [Downloading Files in Bulk from Public S3](#6-downloading-files-in-bulk-from-public-s3)
7. [Protecting Indexed Buckets](#7-protecting-indexed-buckets)
8. [Blocking Direct Path Access](#8-blocking-direct-path-access)
9. [Disabling Full Public Access in S3](#9-disabling-full-public-access-in-s3)
10. [Allowing Public Access to Specific Files Only](#10-allowing-public-access-to-specific-files-only)

---

## 1. How S3 Buckets Get Public Access

* Manual public access enabled during upload
* Disabling "Block Public Access" settings
* Misconfigured IAM or bucket policies
* Using S3 static website hosting

## 2. How Files Get Indexed by Search Engines

* Search engine crawlers can access public S3 URLs
* Exposed file paths: [https://yourbucketname.s3.ap-south-1.amazonaws.com/](https://yourbucketname.s3.ap-south-1.amazonaws.com/)
* Indexed through links, robots not blocked

## 3. How to Prevent Search Engine Indexing

* Add `robots.txt` (if using S3 website hosting):

  ```
  User-agent: *
  Disallow: /
  ```
* Set up CloudFront with signed URLs
* Use proper bucket policy to limit access

## 4. Finding Indexed Files of S3 Buckets

* Use Google Dorking:

  ```
  site:s3.ap-south-1.amazonaws.com inurl:vsplbucket1
  ```
* Tools:

  * [https://censys.io](https://censys.io)
  * [https://hunter.io](https://hunter.io)
  * Google Alerts

## 5. Listing Public S3 Files using PowerShell

```powershell
<#
.SYNOPSIS
Lists all files from a public S3 bucket
.DESCRIPTION
Supports pagination and saves results to file
#>

$bucketUrl = "https://yourbucketname.s3.ap-south-1.amazonaws.com"
$outputFile = "s3_objects.txt"
$marker = ""

do {
    $url = "$bucketUrl/?marker=$marker"
    $response = Invoke-WebRequest -Uri $url
    $xml = [xml]$response.Content
    $xml.ListBucketResult.Contents | ForEach-Object {
        $_.Key | Out-File -Append -FilePath $outputFile
    }
    $marker = if ($xml.ListBucketResult.IsTruncated -eq "true") {
        $xml.ListBucketResult.Contents[-1].Key
    } else {
        $null
    }
} while ($marker)
```

## 6. Downloading Files in Bulk from Public S3

```powershell
$bucketUrl = "https://yourbucketname.s3.ap-south-1.amazonaws.com"
$paths = Get-Content -Path "s3_objects.txt"

foreach ($path in $paths) {
    $fileUrl = "$bucketUrl/$path"
    $outFile = "downloads\$($path -replace '/','_')"
    Invoke-WebRequest -Uri $fileUrl -OutFile $outFile
}
```

## 7. Protecting Indexed Buckets

* Submit URL removal in Google:

  * [https://search.google.com/search-console/remove-outdated-content](https://search.google.com/search-console/remove-outdated-content)
* Use CloudFront with restricted access
* Restrict bucket policy to specific referrers

## 8. Blocking Direct Path Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlockAllExceptCloudFront",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::yourbucketname/*",
      "Condition": {
        "StringNotEquals": {
          "aws:Referer": "https://yourdomain.com/"
        }
      }
    }
  ]
}
```

## 9. Disabling Full Public Access in S3

* Go to S3 Bucket → Permissions → Block Public Access
* Enable all:

  * Block public ACLs
  * Block public bucket policies
  * Ignore public ACLs
  * Restrict public bucket policies

## 10. Allowing Public Access to Specific Files Only

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificFiles",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
        "arn:aws:s3:::yourbucketname/public-folder/index.html",
        "arn:aws:s3:::yourbucketname/public-folder/image.png"
      ]
    }
  ]
}
```

---

## 📌 Disclaimer

This guide is intended only for educational and ethical usage. Do not misuse this knowledge to harm or exploit others.

---

## 📂 Contributing

Feel free to raise a pull request or report any outdated info.


# S3 Bucket Security Guide  
![Visitor Count](https://visitor-badge.laobi.icu/badge?page_id=risewithvj.s3-bucket-security-guide&color=purple&label=Visitors&style=for-the-badge)
