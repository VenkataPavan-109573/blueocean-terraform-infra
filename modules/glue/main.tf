resource "aws_s3_object" "script" {
  bucket = var.scripts_bucket_name
  key    = var.script_s3_key

  source = "${path.module}/scripts/landing_to_bronze.py"
  etag   = filemd5("${path.module}/scripts/landing_to_bronze.py")

  server_side_encryption = "AES256"

  tags = var.tags
}

resource "aws_glue_job" "landing_to_bronze" {
  name        = var.job_name
  description = var.description
  role_arn    = var.glue_role_arn

  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  timeout           = var.timeout
  max_retries       = var.max_retries
  execution_class   = "STANDARD"

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "s3://${var.scripts_bucket_name}/${aws_s3_object.script.key}"
  }

  execution_property {
    max_concurrent_runs = var.max_concurrent_runs
  }

  default_arguments = {
    "--job-language"                     = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--enable-observability-metrics"     = "true"
    "--job-bookmark-option"              = var.job_bookmark_option
    "--enable-auto-scaling"              = tostring(var.enable_auto_scaling)

    "--environment"       = var.environment
    "--aws_region"        = var.aws_region
    "--report_name"       = var.report_name
    "--source_system"     = var.source_system
    "--source_format"     = var.source_format
    "--target_format"     = var.target_format
    "--target_database"   = var.target_database
    "--source_path"       = var.source_path
    "--target_path"       = var.target_path
    "--quarantine_path"   = var.quarantine_path
    "--audit_lambda_name" = var.audit_lambda_name
    "--mandatory_field"   = var.mandatory_field
    "--pipeline_name"     = var.pipeline_name
    "--dataset_name"      = var.dataset_name
    "--target_table"      = var.target_table
  }

  tags = var.tags

  depends_on = [
    aws_s3_object.script
  ]
}

resource "aws_glue_trigger" "schedule" {
  count = var.schedule_expression == null ? 0 : 1

  name              = "${var.job_name}-schedule"
  description       = "Scheduled trigger for ${var.job_name}"
  type              = "SCHEDULED"
  schedule          = var.schedule_expression
  start_on_creation = true
  enabled           = true

  actions {
    job_name = aws_glue_job.landing_to_bronze.name
  }

  tags = var.tags
}