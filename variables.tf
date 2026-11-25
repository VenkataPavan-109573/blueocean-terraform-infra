variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "uat", "prod"], lower(var.environment))
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID where resources will be deployed"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS account ID must contain exactly 12 digits."
  }
}

variable "s3_bucket_names" {
  description = "Environment-specific names for Blue Ocean S3 buckets."

  type = object({
    landing    = string
    bronze     = string
    quarantine = string
    scripts    = string
  })
}

variable "s3_force_destroy" {
  description = "Whether Terraform may delete non-empty data buckets."
  type        = bool
  default     = false
}

variable "glue_job_name" {
  description = "Name of the landing-to-bronze Glue job."
  type        = string
}

variable "glue_role_name" {
  description = "Name of the Glue IAM execution role."
  type        = string
}

variable "glue_version" {
  description = "AWS Glue version."
  type        = string
  default     = "5.0"
}

variable "glue_worker_type" {
  description = "AWS Glue worker type."
  type        = string
  default     = "G.1X"
}

variable "glue_number_of_workers" {
  description = "Number of Glue workers."
  type        = number
  default     = 2
}

variable "glue_timeout" {
  description = "Glue timeout in minutes."
  type        = number
  default     = 60
}

variable "glue_max_retries" {
  description = "Glue job retry count."
  type        = number
  default     = 0
}

variable "glue_max_concurrent_runs" {
  description = "Maximum concurrent Glue job runs."
  type        = number
  default     = 1
}

variable "glue_enable_auto_scaling" {
  description = "Enable AWS Glue auto scaling."
  type        = bool
  default     = false
}

variable "glue_job_bookmark_option" {
  description = "Glue bookmark behavior."
  type        = string
  default     = "job-bookmark-disable"
}

variable "glue_schedule_expression" {
  description = "Optional Glue cron or rate schedule."
  type        = string
  default     = null
}

variable "report_name" {
  description = "Report name passed to the Glue job."
  type        = string
}

variable "source_system" {
  description = "Source system passed to the Glue job."
  type        = string
}

variable "source_format" {
  description = "Source file format."
  type        = string
}

variable "target_format" {
  description = "Target file format."
  type        = string
}

variable "target_database" {
  description = "Target database name."
  type        = string
}

variable "source_prefix" {
  description = "S3 prefix under the landing bucket."
  type        = string
}

variable "target_prefix" {
  description = "S3 prefix under the bronze bucket."
  type        = string
}

variable "quarantine_prefix" {
  description = "S3 prefix under the quarantine bucket."
  type        = string
  default     = ""
}

variable "mandatory_field" {
  description = "Required field validated by the Glue job."
  type        = string
  default     = "acdlogon_agtoid"
}

variable "pipeline_name" {
  description = "Audit pipeline name."
  type        = string
}

variable "dataset_name" {
  description = "Audit dataset name."
  type        = string
}

variable "target_table" {
  description = "Audit target table identifier."
  type        = string
}

variable "kms_key_arns" {
  description = "Optional KMS keys used by the data pipeline."
  type        = list(string)
  default     = []
}

variable "lambda_function_name" {
  description = "Name of the audit writer Lambda function."
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "ARN of the existing IAM execution role used by Lambda."
  type        = string
}

variable "lambda_runtime" {
  description = "Python runtime used by Lambda."
  type        = string
  default     = "python3.12"
}

variable "lambda_memory_size" {
  description = "Lambda memory allocation in MB."
  type        = number
  default     = 256
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 120
}

variable "lambda_ephemeral_storage_size" {
  description = "Lambda ephemeral storage in MB."
  type        = number
  default     = 512
}

variable "lambda_architecture" {
  description = "Lambda processor architecture."
  type        = string
  default     = "x86_64"
}

variable "lambda_log_retention_days" {
  description = "CloudWatch log retention period."
  type        = number
  default     = 30
}

variable "lambda_reserved_concurrent_executions" {
  description = "Optional reserved Lambda concurrency."
  type        = number
  default     = null
}

variable "audit_database" {
  description = "Athena database containing the audit table."
  type        = string
}

variable "audit_table" {
  description = "Athena Iceberg audit table."
  type        = string
}

variable "athena_workgroup" {
  description = "Athena workgroup used by the audit Lambda."
  type        = string
  default     = "primary"
}

variable "athena_output_prefix" {
  description = "Prefix in the configured S3 bucket used for Athena query results."
  type        = string
  default     = "ops/run_log/"
}