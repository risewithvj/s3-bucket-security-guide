# 10-allow-specific-files

## Bucket Policy Example

The following bucket policy allows public access **only** to specific files, while keeping other folders private:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicAccessToSpecificFiles",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
        "arn:aws:s3:::bucketname/public-folder/index.html",
        "arn:aws:s3:::bucketname/public-folder/image.png"
      ]
    }
  ]
}

// Change the marked "bucketname"