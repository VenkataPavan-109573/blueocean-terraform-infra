module "s3" {
  source = "./modules/s3"

  bucket_names      = var.s3_bucket_names
  force_destroy     = var.s3_force_destroy
  enable_versioning = true

  tags = local.common_tags
}

module "lambda" {
  source = "./modules/lambda"

  function_name = var.lambda_function_name
  description   = "Writes Blue Ocean pipeline audit records to the Athena Iceberg audit table."

  execution_role_arn = var.lambda_execution_role_arn

  runtime                = var.lambda_runtime
  handler                = "lambda_function.lambda_handler"
  architecture           = var.lambda_architecture
  memory_size            = var.lambda_memory_size
  timeout                = var.lambda_timeout
  ephemeral_storage_size = var.lambda_ephemeral_storage_size

  audit_database   = var.audit_database
  audit_table      = var.audit_table
  athena_workgroup = var.athena_workgroup
  athena_output_s3 = local.athena_output_s3

  log_retention_days             = var.lambda_log_retention_days
  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  publish = false

  tags = local.common_tags

  depends_on = [
    module.s3
  ]
}

module "glue" {
  source = "./modules/glue"

  job_name      = var.glue_job_name
  description   = "Blue Ocean landing-to-bronze ETL job"
  glue_role_arn = module.iam.glue_role_arn

  scripts_bucket_name = module.s3.scripts_bucket_name
  script_s3_key       = "glue-scripts/landing_to_bronze.py"

  glue_version        = var.glue_version
  worker_type         = var.glue_worker_type
  number_of_workers   = var.glue_number_of_workers
  timeout             = var.glue_timeout
  max_retries         = var.glue_max_retries
  max_concurrent_runs = var.glue_max_concurrent_runs

  environment = var.environment
  aws_region  = var.aws_region

  report_name     = var.report_name
  source_system   = var.source_system
  source_format   = var.source_format
  target_format   = var.target_format
  target_database = var.target_database

  source_path     = local.source_path
  target_path     = local.target_path
  quarantine_path = local.quarantine_path

  audit_lambda_name = module.lambda.function_name
  mandatory_field   = var.mandatory_field
  pipeline_name     = var.pipeline_name
  dataset_name      = var.dataset_name
  target_table      = var.target_table

  schedule_expression = var.glue_schedule_expression
  job_bookmark_option = var.glue_job_bookmark_option
  enable_auto_scaling = var.glue_enable_auto_scaling

  tags = local.common_tags

  depends_on = [
    module.s3,
    module.iam,
    module.lambda
  ]
}