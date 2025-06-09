# 03-prevent-search-engine-indexing

## How to Prevent Search Engine Indexing of S3 Buckets

- **Set proper permissions in bucket policies**  
  Ensure your S3 bucket policies restrict public access appropriately.

- **Use a robots.txt (if using S3 static hosting):**  
  Create a `robots.txt` file to instruct search engine bots not to index your site:

  ```txt
  User-agent: *
  Disallow: /

- **Use AWS CloudFront with signed URLs**
    Distribute content via CloudFront using signed URLs to restrict unauthorized access and prevent public indexing.
    
**Note:**Feel free to save this as `03-prevent-search-engine-indexing.md`. Let me know if you want me to prepare a downloadable version!
