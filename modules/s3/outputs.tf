output "bucket_names" {
  description = "Map containing the created S3 bucket names."

  value = {
    for key, bucket in aws_s3_bucket.this :
    key => bucket.bucket
  }
}

output "bucket_arns" {
  description = "Map containing the created S3 bucket ARNs."

  value = {
    for key, bucket in aws_s3_bucket.this :
    key => bucket.arn
  }
}

output "landing_bucket_name" {
  description = "Landing S3 bucket name."
  value       = aws_s3_bucket.this["landing"].bucket
}

output "landing_bucket_arn" {
  description = "Landing S3 bucket ARN."
  value       = aws_s3_bucket.this["landing"].arn
}

output "bronze_bucket_name" {
  description = "Bronze S3 bucket name."
  value       = aws_s3_bucket.this["bronze"].bucket
}

output "bronze_bucket_arn" {
  description = "Bronze S3 bucket ARN."
  value       = aws_s3_bucket.this["bronze"].arn
}

output "quarantine_bucket_name" {
  description = "Quarantine S3 bucket name."
  value       = aws_s3_bucket.this["quarantine"].bucket
}

output "quarantine_bucket_arn" {
  description = "Quarantine S3 bucket ARN."
  value       = aws_s3_bucket.this["quarantine"].arn
}

output "scripts_bucket_name" {
  description = "Glue scripts S3 bucket name."
  value       = aws_s3_bucket.this["scripts"].bucket
}

output "scripts_bucket_arn" {
  description = "Glue scripts S3 bucket ARN."
  value       = aws_s3_bucket.this["scripts"].arn
}