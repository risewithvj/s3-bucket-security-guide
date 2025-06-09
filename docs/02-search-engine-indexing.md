# 02-search-engine-indexing

## How Public S3 Buckets Get Indexed by Search Engines

1. **Public Buckets Can Be Crawled by Bots**  
   When S3 buckets are publicly accessible, search engine crawlers like Googlebot or Bingbot can detect and scan them.

2. **Indexing of HTML/JSON/XML Files**  
   Publicly accessible files such as `.html`, `.json`, and `.xml` are especially likely to be indexed by search engines.

3. **Example Indexed URL**  
   Search engines like Google and Bing can index S3 URLs in formats such as: https://example.s3.ap-south-1.amazonaws.com/path/to/file or https://example.s3.amazonaws.com/path/to/file


**Note:** Once indexed, these URLs can show up in search results, potentially exposing sensitive content to the public.


