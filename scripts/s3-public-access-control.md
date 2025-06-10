# 🛡️ AWS S3 Security Best Practices

This guide provides a set of commonly used S3 bucket policies to secure your content while allowing controlled public access when necessary.

## 📚 Table of Contents

1. [Disable Public Listing (Block Directory Listing)](#1-disable-public-listing-block-directory-listing)
2. [Restrict Access to Specific Paths Only](#2-restrict-access-to-specific-paths-only)

---

## 1. 🔒 Disable Public Listing (Block Directory Listing)

Prevent users from viewing the list of files in your S3 bucket when accessing URLs like:

```
https://your-bucket.s3.amazonaws.com/
```

### ✅ Effect

* **Prevents**: Public users from listing the contents of the bucket.
* **Allows**: Direct file access (if explicitly permitted).

### 📄 Bucket Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::your-bucket-name"
    }
  ]
}
```

> 🔁 Replace `your-bucket-name` with your actual S3 bucket name.

---

## 2. 🚫 Restrict Access to Specific Paths Only

Allow access **only** to files in the `/shared-files/` directory of your S3 bucket. All other paths will return `403 Forbidden`.

### ✅ Effect

* ✅ **Allowed**: `s3:GetObject` on `shared-files/*`
* ❌ **Denied**: Access to anything outside `shared-files/`

### 📄 Bucket Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-bucket/shared-files/*"
    },
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::your-bucket/*",
      "Condition": {
        "StringNotLike": {
          "s3:prefix": ["shared-files/*"]
        }
      }
    }
  ]
}
```

> 🔁 Replace `your-bucket` with your actual S3 bucket name.

---

## 📌 Tips

* Always test policies in a non-production bucket before applying them widely.
* Use IAM roles for fine-grained access control where possible.
* Combine these policies with proper **S3 Block Public Access** settings in the AWS Console for maximum security.
