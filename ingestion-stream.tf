resource "aws_kinesis_stream" "ingestion_stream" {
  # checkov:skip=CKV_AWS_43: "Ensure Kinesis Stream is securely encrypted"
  # checkov:skip=CKV_AWS_185: "Ensure Kinesis Stream is encrypted by KMS using a customer managed Key (CMK)"
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
