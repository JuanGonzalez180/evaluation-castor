# Outputs
output "bucket_name" {
  value = aws_s3_bucket.images_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.images_bucket.arn
}

output "s3_access_policy_arn" {
  value = aws_iam_policy.s3_access_policy.arn
}