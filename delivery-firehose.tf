data "aws_iam_policy_document" "delivery_firehose" {
  statement {
    sid = "AllowKinesisRead"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      aws_kinesis_stream.ingestion_stream.arn
    ]
  }
  statement {
    sid = "AllowS3"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.bucket.arn,
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  statement {
    sid = "AllowPutLogEvents"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.delivery_firehose.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "delivery_firehose" {
  name        = "${var.deployment.name}-delivery-firehose"
  description = "Policy for the Kinesis Firehose delivery-firehose"
  policy      = data.aws_iam_policy_document.delivery_firehose.json
}

data "aws_iam_policy_document" "delivery_firehose_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "delivery_firehose" {
  name               = "${var.deployment.name}-delivery-firehose"
  assume_role_policy = data.aws_iam_policy_document.delivery_firehose_assume_role.json
}

resource "aws_iam_role_policy_attachment" "delivery_firehose" {
  role       = aws_iam_role.delivery_firehose.name
  policy_arn = aws_iam_policy.delivery_firehose.arn
}

resource "aws_cloudwatch_log_group" "delivery_firehose" {
  name = "/aws/kinesisfirehose/${var.deployment.name}-delivery-firehose"
}

resource "aws_cloudwatch_log_stream" "delivery_firehose" {
  name           = var.deployment.name
  log_group_name = aws_cloudwatch_log_group.delivery_firehose.name
}

resource "aws_kinesis_firehose_delivery_stream" "delivery_firehose" {
  name        = "${var.deployment.name}-delivery-firehose"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.ingestion_stream.arn
    role_arn           = aws_iam_role.delivery_firehose.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.delivery_firehose.arn
    bucket_arn = aws_s3_bucket.bucket.arn
  }
}
