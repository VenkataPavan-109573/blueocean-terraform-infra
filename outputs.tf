output "deployment_information" {
  description = "Terraform deployment target information."

  value = {
    project        = var.project_name
    environment    = var.environment
    aws_account_id = data.aws_caller_identity.current.account_id
    aws_region     = data.aws_region.current.name
  }
}

output "s3_bucket_names" {
  description = "S3 buckets created for the landing-to-bronze pipeline."
  value       = module.s3.bucket_names
}

output "glue_job_name" {
  description = "Created Glue job name."
  value       = module.glue.job_name
}

output "glue_job_arn" {
  description = "Created Glue job ARN."
  value       = module.glue.job_arn
}

output "glue_script_s3_uri" {
  description = "S3 location of the uploaded Glue script."
  value       = module.glue.script_s3_uri
}

output "glue_role_arn" {
  description = "IAM role used by the Glue job."
  value       = module.iam.glue_role_arn
}

output "glue_source_path" {
  description = "Source S3 path passed to the Glue job."
  value       = local.source_path
}

output "glue_target_path" {
  description = "Target S3 path passed to the Glue job."
  value       = local.target_path
}

output "glue_quarantine_path" {
  description = "Quarantine S3 path passed to the Glue job."
  value       = local.quarantine_path
}

output "audit_lambda_name" {
  description = "Name of the audit writer Lambda function."
  value       = module.lambda.function_name
}

output "audit_lambda_arn" {
  description = "ARN of the audit writer Lambda function."
  value       = module.lambda.function_arn
}

output "audit_lambda_log_group" {
  description = "CloudWatch log group used by the audit writer Lambda."
  value       = module.lambda.log_group_name
}

output "athena_audit_database" {
  description = "Athena database used for audit records."
  value       = var.audit_database
}

output "athena_audit_table" {
  description = "Athena Iceberg table used for audit records."
  value       = var.audit_table
}

output "athena_query_output_s3" {
  description = "S3 location used for Athena query results."
  value       = local.athena_output_s3
}