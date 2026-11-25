project_name   = "blue-ocean"
environment    = "dev"
aws_region     = "ca-central-1"
aws_account_id = "173532448996"

s3_bucket_names = {
  landing    = "blue-lake-landing-dev-173532448996"
  bronze     = "blue-lake-bronze-dev-173532448996"
  quarantine = "blue-lake-landing-quarantine-dev-173532448996"
  scripts    = "blue-ocean-glue-scripts-dev-173532448996"
}

s3_force_destroy = false

lambda_function_name = "bo-dl-dev-runlog-writer"

# Existing Lambda execution role.
# This will be replaced or confirmed after the IAM policies are provided.
lambda_execution_role_arn = "arn:aws:iam::173532448996:role/bo-dl-dev-runlog-writer-role-p0Brwah3w"

lambda_runtime                = "python3.12"
lambda_memory_size            = 256
lambda_timeout                = 120
lambda_ephemeral_storage_size = 512
lambda_architecture           = "x86_64"

lambda_log_retention_days             = 30
lambda_reserved_concurrent_executions = null

audit_database   = "ops"
audit_table      = "run_log"
athena_workgroup = "primary"

athena_output_prefix = "ops/run_log/"


glue_job_name  = "dev-datahub-landing-to-bronze"
glue_role_name = "AWSGlueServiceRole-blue-ocean-dev-landing-to-bronze"

glue_version             = "5.0"
glue_worker_type         = "G.1X"
glue_number_of_workers   = 2
glue_timeout             = 60
glue_max_retries         = 0
glue_max_concurrent_runs = 1
glue_enable_auto_scaling = false
glue_job_bookmark_option = "job-bookmark-disable"

# Keep null until the actual schedule is confirmed.
glue_schedule_expression = null

# This Lambda must already exist in ca-central-1.
audit_lambda_name = "bo-dl-dev-runlog-writer"

report_name     = "shared"
source_system   = "iex"
source_format   = "json"
target_format   = "parquet"
target_database = "bronze_workforce"

source_prefix     = "iex/agent-activity/input/"
target_prefix     = "iex/agent-activity/test_run_02/"
quarantine_prefix = ""

mandatory_field = "acdlogon_agtoid"
pipeline_name   = "iex-hourly"
dataset_name    = "agent-activity"
target_table    = "bronze_workforce.test_run_02"

kms_key_arns = []