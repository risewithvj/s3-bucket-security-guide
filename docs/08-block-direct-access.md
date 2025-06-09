# 08-block-direct-access

## Apply Bucket Policies to Block Direct Access

Use the following bucket policy to deny all `s3:GetObject` requests except those coming through your CloudFront distribution (or specific referer):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlockAllExceptCloudFront",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bucketname/*",
      "Condition": {
        "StringNotEquals": {
          "aws:Referer": "https://yourdomain.com/"
        }
      }
    }
  ]
}

// Change the marked "bucketname" and your domain url