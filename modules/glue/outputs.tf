output "job_name" {
  description = "Name of the AWS Glue job."
  value       = aws_glue_job.landing_to_bronze.name
}

output "job_arn" {
  description = "ARN of the AWS Glue job."
  value       = aws_glue_job.landing_to_bronze.arn
}

output "script_s3_uri" {
  description = "S3 URI of the uploaded Glue script."
  value       = "s3://${var.scripts_bucket_name}/${aws_s3_object.script.key}"
}

output "schedule_trigger_name" {
  description = "Name of the optional Glue schedule trigger."
  value       = var.schedule_expression == null ? null : aws_glue_trigger.schedule[0].name
}