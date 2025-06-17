resource "aws_s3_bucket" "helpdeskhub_app" {
  bucket = "helpdeskhub-app-bucket"
}

resource "aws_s3_bucket_public_access_block" "helpdeskhub_app_access" {
  bucket = aws_s3_bucket.helpdeskhub_app.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "helpdeskhub_app_website" {
  bucket = aws_s3_bucket.helpdeskhub_app.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "helpdeskhub_app_policy" {
  bucket = aws_s3_bucket.helpdeskhub_app.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.helpdeskhub_app.arn}/*"
      }
    ]
  })
}
