variable "function_name" {
  description = "Name of the Lambda audit-log writer function."
  type        = string
}

variable "description" {
  description = "Description of the Lambda function."
  type        = string
  default     = "Writes Blue Ocean pipeline audit records to an Athena Iceberg table."
}

variable "execution_role_arn" {
  description = "ARN of the existing IAM role used by the Lambda function."
  type        = string
}

variable "runtime" {
  description = "Python runtime used by the Lambda function."
  type        = string
  default     = "python3.12"
}

variable "handler" {
  description = "Lambda function handler."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "memory_size" {
  description = "Memory allocated to the Lambda function in MB."
  type        = number
  default     = 256

  validation {
    condition = (
      var.memory_size >= 128 &&
      var.memory_size <= 10240
    )

    error_message = "Lambda memory must be between 128 MB and 10240 MB."
  }
}

variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 120

  validation {
    condition = (
      var.timeout >= 1 &&
      var.timeout <= 900
    )

    error_message = "Lambda timeout must be between 1 and 900 seconds."
  }
}

variable "ephemeral_storage_size" {
  description = "Lambda ephemeral storage in MB."
  type        = number
  default     = 512

  validation {
    condition = (
      var.ephemeral_storage_size >= 512 &&
      var.ephemeral_storage_size <= 10240
    )

    error_message = "Lambda ephemeral storage must be between 512 MB and 10240 MB."
  }
}

variable "architecture" {
  description = "Lambda processor architecture."
  type        = string
  default     = "x86_64"

  validation {
    condition = contains(
      ["x86_64", "arm64"],
      var.architecture
    )

    error_message = "Architecture must be x86_64 or arm64."
  }
}

variable "audit_database" {
  description = "Athena/Glue Data Catalog database containing the audit table."
  type        = string
}

variable "audit_table" {
  description = "Athena Iceberg audit table name."
  type        = string
}

variable "athena_workgroup" {
  description = "Athena workgroup used by the Lambda function."
  type        = string
}

variable "athena_output_s3" {
  description = "S3 location used for Athena query results."
  type        = string

  validation {
    condition = (
      var.athena_output_s3 == "" ||
      startswith(var.athena_output_s3, "s3://")
    )

    error_message = "athena_output_s3 must be empty or start with s3://."
  }
}

variable "log_retention_days" {
  description = "Number of days Lambda CloudWatch logs are retained."
  type        = number
  default     = 30
}

variable "reserved_concurrent_executions" {
  description = "Optional reserved concurrency. Null leaves concurrency unreserved."
  type        = number
  default     = null
}

variable "publish" {
  description = "Whether Terraform publishes a numbered Lambda version."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to Lambda resources."
  type        = map(string)
  default     = {}
}