# main.tf

provider "aws" {
  region = "ap-south-1"
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

# This new resource replaces the deprecated "website" block
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

  # This is the crucial fix: It tells Terraform to wait for the public access block
  # to be configured before trying to apply this policy.
  depends_on = [aws_s3_bucket_public_access_block.website_bucket_pab]
}

# This output is updated to use the new website configuration resource
output "website_url" {
  value = aws_s3_bucket_website_configuration.website_config.website_endpoint
}

