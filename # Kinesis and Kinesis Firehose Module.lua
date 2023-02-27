# Kinesis and Kinesis Firehose Module

variable "stream_name" {
  description = "Name of the Kinesis data stream"
}

variable "firehose_name" {
  description = "Name of the Kinesis Data Firehose delivery stream"
}

variable "s3_bucket" {
  description = "Name of the S3 bucket to store the Kinesis Data Firehose data"
}

resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.stream_name
  shard_count      = 1
  retention_period = 24
}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_firehose" {
  name        = var.firehose_name
  destination = "s3"

  s3_configuration {
    bucket_arn      = "arn:aws:s3:::${var.s3_bucket}"
    role_arn        = aws_iam_role.firehose_role.arn
    prefix          = "kinesis-data/"
    buffer_size     = 5
    buffer_interval = 300
  }

  depends_on = [
    aws_iam_role_policy.firehose_policy,
    aws_iam_role_policy_attachment.firehose_attachment
  ]
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = jsonencode({
    Version
