To include this in your GitHub repository in a clean and professional way, you should write it in **Markdown (.md)** format. Here's a recommended version you can copy directly into a `.md` file, such as `disable-public-listing.md`:

---

## 🔒 Disable Public Listing (Block Directory Listing) in Amazon S3

To prevent users from seeing file listings when accessing your S3 bucket via URLs like:

```
https://your-bucket.s3.amazonaws.com/
```

Apply the following **bucket policy**. This policy **denies public `ListBucket` access**, effectively blocking directory listing. However, direct file access (if allowed) will still work.

### 📄 Bucket Policy (JSON)

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

### ✅ Effect

* **Prevents**: Public users from listing the contents of the bucket.
* **Allows**: Access to individual files (only if explicitly permitted by other bucket or object policies).

> **Note:** Replace `your-bucket-name` with the actual name of your S3 bucket.

---

Let me know if you want to include example file access policies or make this part of a full S3 security guide.
