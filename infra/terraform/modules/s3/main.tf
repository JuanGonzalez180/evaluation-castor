resource "aws_s3_bucket" "images_bucket" {
  bucket = "${var.bucket_name}-${var.environment}"
  
  tags = {
    Name        = "${var.bucket_name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_cors_configuration" "images_bucket_cors" {
  bucket = aws_s3_bucket.images_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"] #TODO: Change in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "images_bucket_ownership" {
  bucket = aws_s3_bucket.images_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "images_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.images_bucket_ownership]
  
  bucket = aws_s3_bucket.images_bucket.id
  acl    = "private"
}

# IAM policy for lambda
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy-${var.environment}"
  description = "Policy for accessing S3 bucket for image storage"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.images_bucket.arn}/*"
      },
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.images_bucket.arn
      },
    ]
  })
}
