resource "aws_kinesis_stream" "my_stream" {
  name             = "my-kinesis-stream"
  shard_count      = 1
  retention_period = 24
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-firehose-bucket"
  acl    = "aws_s3_bucket_acl"
}
resource "aws_kinesis_firehose_delivery_stream" "my_delivery_stream" {
  name               = "my-delivery-stream"
  destination        = "s3"
  s3_bucket_arn      = aws_s3_bucket.my_bucket.arn
  s3_buffer_interval = 300
  s3_buffer_size     = 5
  depends_on         = [aws_kinesis_stream.my_stream]
}
