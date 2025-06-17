output "website_url" {
  description = "URL of the React app hosted on S3"
  value       = aws_s3_bucket_website_configuration.helpdeskhub_app_website.website_endpoint
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.helpdeskhub_app_distribution.domain_name
}
