# 07-protect-indexed-buckets

## How to Protect Indexed S3 Buckets

- **Request Google Deindexing**  
  Use Google’s Remove Outdated Content tool to take down indexed URLs that should no longer be public.

- **Use robots.txt (for website buckets)**  
  If you are hosting a static website on S3, create a `robots.txt` file to instruct search engines not to crawl your bucket.

- **Enable CloudFront Signed URLs**  
  Distribute content securely using AWS CloudFront signed URLs to restrict unauthorized access.

- **Use AWS WAF with S3 or CloudFront**  
  Apply AWS Web Application Firewall (WAF) rules to control and filter requests to your S3 buckets or CloudFront distributions.
