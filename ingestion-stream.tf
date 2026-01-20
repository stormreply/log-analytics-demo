resource "aws_kinesis_stream" "ingestion_stream" {
  name             = local.ingestion_stream
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}
