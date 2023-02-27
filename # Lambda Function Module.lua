# Lambda Function Module

variable "function_name" {
  description = "Name of the Lambda function"
}

variable "s3_bucket" {
  description = "Name of the S3 bucket to store the Lambda function code"
}

resource "aws_lambda_function" "function" {
  filename      = "lambda_function.zip"
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Add any additional policies needed for this role here
}

data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "lambda_code"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_permission" "allow_kinesis" {
  statement_id  = "AllowExecutionFromKinesis"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.arn
  principal     = "kinesis.amazonaws.com"
  source_arn    = aws_kinesis_stream.kinesis_stream.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.function.arn
}
