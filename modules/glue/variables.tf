variable "job_name" {
  description = "Name of the AWS Glue ETL job."
  type        = string
}

variable "description" {
  description = "Description of the AWS Glue ETL job."
  type        = string
  default     = "Landing-to-bronze ETL job"
}

variable "glue_role_arn" {
  description = "IAM execution role ARN used by the Glue job."
  type        = string
}

variable "scripts_bucket_name" {
  description = "S3 bucket used for Glue scripts."
  type        = string
}

variable "script_s3_key" {
  description = "S3 object key used to store the Glue PySpark script."
  type        = string
  default     = "glue-scripts/landing_to_bronze.py"
}

variable "glue_version" {
  description = "AWS Glue runtime version."
  type        = string
  default     = "5.0"
}

variable "worker_type" {
  description = "AWS Glue worker type."
  type        = string
  default     = "G.1X"
}

variable "number_of_workers" {
  description = "Number of Glue workers."
  type        = number
  default     = 2

  validation {
    condition     = var.number_of_workers >= 2
    error_message = "number_of_workers must be at least 2 for a Glue Spark ETL job."
  }
}

variable "timeout" {
  description = "Glue job timeout in minutes."
  type        = number
  default     = 60
}

variable "max_retries" {
  description = "Number of times Glue retries a failed job."
  type        = number
  default     = 0
}

variable "max_concurrent_runs" {
  description = "Maximum concurrent executions of the Glue job."
  type        = number
  default     = 1
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the Glue job and Lambda client."
  type        = string
}

variable "report_name" {
  description = "Report name provided to the Glue job."
  type        = string
}

variable "source_system" {
  description = "Source system provided to the Glue job."
  type        = string
}

variable "source_format" {
  description = "Input data format."
  type        = string
}

variable "target_format" {
  description = "Output data format."
  type        = string
}

variable "target_database" {
  description = "Target database name provided to the Glue job."
  type        = string
}

variable "source_path" {
  description = "Full S3 source path read by the Glue job."
  type        = string
}

variable "target_path" {
  description = "Full S3 target path written by the Glue job."
  type        = string
}

variable "quarantine_path" {
  description = "Base S3 path for quarantined records."
  type        = string
}

variable "audit_lambda_name" {
  description = "Name of the audit Lambda invoked by the Glue job."
  type        = string
}

variable "mandatory_field" {
  description = "Mandatory source field validated by the Glue job."
  type        = string
  default     = "acdlogon_agtoid"
}

variable "pipeline_name" {
  description = "Pipeline name included in audit records."
  type        = string
  default     = "iex-hourly"
}

variable "dataset_name" {
  description = "Dataset name included in audit records."
  type        = string
  default     = "agent-activity"
}

variable "target_table" {
  description = "Target table name included in audit records."
  type        = string
}

variable "schedule_expression" {
  description = "Optional Glue cron or rate expression. Null means no schedule is created."
  type        = string
  default     = null
}

variable "job_bookmark_option" {
  description = "Glue job bookmark setting."
  type        = string
  default     = "job-bookmark-disable"

  validation {
    condition = contains(
      [
        "job-bookmark-enable",
        "job-bookmark-disable",
        "job-bookmark-pause"
      ],
      var.job_bookmark_option
    )

    error_message = "Invalid Glue job bookmark option."
  }
}

variable "enable_auto_scaling" {
  description = "Whether Glue auto scaling should be enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to Glue resources."
  type        = map(string)
  default     = {}
}