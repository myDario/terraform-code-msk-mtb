resource "aws_kinesis_stream" "my_stream" {
  name             = "my-kinesis-stream"
  shard_count      = 1
  retention_period = 7

}

resource "aws_kinesis_firehose_delivery_stream" "my_delivery_stream" {
  name        = "my-kinesis-firehose-delivery-stream"
  destination = "s3"
  s3_configuration {
    role_arn      = aws_iam_role.my_role.arn
    bucket_arn    = aws_s3_bucket.my_bucket.arn
    prefix        = "my-prefix/"
    buffer_size   = 5
    buffer_int    = 300
    compression   = "GZIP"
    error_output_prefix = "error-output/"
    kms_key_arn = aws_kms_key.my_kms_key.arn
  }
}

resource "aws_kinesis_firehose_delivery_stream_kinesis_source_configuration" "my_delivery_stream_kinesis_source_configuration" {
  delivery_stream_arn = aws_kinesis_firehose_delivery_stream.my_delivery_stream.arn
  kinesis_stream_arn  = aws_kinesis_stream.my_stream.arn
  role_arn            = aws_iam_role.my_role.arn
}


