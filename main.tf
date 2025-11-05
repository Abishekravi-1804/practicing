

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "my-unique-cicd-project-12345" # Use a globally unique name

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_pab" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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
}

output "website_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
