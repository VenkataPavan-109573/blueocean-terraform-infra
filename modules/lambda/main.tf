data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/source/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name = "/aws/lambda/${var.function_name}"
    }
  )
}

resource "aws_lambda_function" "audit_writer" {
  function_name = var.function_name
  description   = var.description

  role    = var.execution_role_arn
  handler = var.handler
  runtime = var.runtime

  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256

  memory_size = var.memory_size
  timeout     = var.timeout
  publish     = var.publish

  architectures = [
    var.architecture
  ]

  reserved_concurrent_executions = var.reserved_concurrent_executions

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  environment {
    variables = {
      AUDIT_DATABASE   = var.audit_database
      AUDIT_TABLE      = var.audit_table
      ATHENA_WORKGROUP = var.athena_workgroup
      ATHENA_OUTPUT_S3 = var.athena_output_s3
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.function_name
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
}