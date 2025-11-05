# main.tf

provider "aws" {
  region = "ap-south-1" # <-- Changed from us-east-1
}

resource "aws_s3_bucket" "website_bucket" {
  # Use a globally unique name
  bucket = "my-unique-cicd-project-bucket-12345" 
}

resource "aws_s3_bucket_public_access_block" "website_bucket_pab" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website_bucket_pab]
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.website_bucket.id
}
