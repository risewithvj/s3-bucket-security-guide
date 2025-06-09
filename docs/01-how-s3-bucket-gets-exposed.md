# 01-how-s3-bucket-gets-exposed

## Common Ways S3 Buckets Get Exposed

1. **Uploading files and ticking "Make Public"**  
   Users may inadvertently make files public during upload by selecting the "Make Public" option.

2. **Disabling "Block Public Access"**  
   Turning off "Block Public Access" settings allows broader access, which can expose data if not carefully managed.

3. **Misconfigured IAM Policies or ACLs**  
   Incorrect Identity and Access Management (IAM) policies or Access Control Lists (ACLs) can grant unintended access to users or the public.

4. **Use of AWS S3 Website Hosting**  
   Buckets configured for static website hosting can be accidentally exposed if proper access controls aren't applied.
