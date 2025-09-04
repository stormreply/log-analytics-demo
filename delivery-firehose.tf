data "aws_iam_policy_document" "delivery_firehose" {
  statement {
    sid = "AllowEC2"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface"
    ]
    resources = ["*"]
  }
  statement {
    sid = "AllowS3"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.module_bucket.arn}",
      "${aws_s3_bucket.module_bucket.arn}/*",
      "*" # TODO: delete after test
    ]
  }
  # statement {
  #   sid = "AllowAllOnOpenSearchDomain"
  #   actions = [
  #     "es:*"
  #   ]
  #   resources = [   # TODO: reactivate
  #     aws_opensearch_domain.log_analytics_demo.arn
  #   ]
  # }
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
  destination = "extended_s3" # "opensearch"
  extended_s3_configuration {
    role_arn            = aws_iam_role.delivery_firehose.arn
    bucket_arn          = aws_s3_bucket.module_bucket.arn
    prefix              = "data/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"
  }
  # opensearch_configuration {
  #   s3_configuration {
  #     role_arn            = aws_iam_role.delivery_firehose.arn
  #     bucket_arn          = aws_s3_bucket.module_bucket.arn
  #     error_output_prefix = "opensearch/errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"
  #   }
  #   domain_arn            = aws_opensearch_domain.log_analytics_demo.arn
  #   role_arn              = aws_iam_role.delivery_firehose.arn
  #   index_name            = "request_data"
  #   index_rotation_period = "NoRotation"
  #   retry_duration        = 300
  #   s3_backup_mode        = "FailedDocumentsOnly"
  #   cloudwatch_logging_options {
  #     enabled         = "true"
  #     log_group_name  = aws_cloudwatch_log_group.delivery_firehose.name
  #     log_stream_name = aws_cloudwatch_log_stream.delivery_firehose.name
  #   }
  # }
}
