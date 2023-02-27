output " Kinesis_Arn" {
    description = "kinesis data stream arn"
    value = aws_kinesis_stream.kinesisstream.arn
}
