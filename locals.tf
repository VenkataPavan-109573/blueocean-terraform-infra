locals {
  name_prefix = lower("${var.project_name}-${var.environment}")

  source_path = "s3://${module.s3.landing_bucket_name}/${trim(var.source_prefix, "/")}"

  target_path = "s3://${module.s3.bronze_bucket_name}/${trim(var.target_prefix, "/")}"

  quarantine_path = (
    var.quarantine_prefix == ""
    ? "s3://${module.s3.quarantine_bucket_name}"
    : "s3://${module.s3.quarantine_bucket_name}/${trim(var.quarantine_prefix, "/")}"
  )

  common_tags = {
    Project     = var.project_name
    Environment = upper(var.environment)
    ManagedBy   = "Terraform"
    Region      = var.aws_region
  }

  athena_output_s3 = format(
    "s3://%s/%s/",
    module.s3.landing_bucket_name,
    trim(var.athena_output_prefix, "/")
  )
}