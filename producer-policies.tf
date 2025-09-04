locals {
  producer_policies = [
    data.aws_iam_policy.amazon_kinesis_firehose_full_access.arn,
    data.aws_iam_policy.amazon_kinesis_full_access.arn,
    data.aws_iam_policy.amazon_ssm_managed_instance_core.arn,
    data.aws_iam_policy.cloudwatch_full_access.arn,
  ]
}

data "aws_iam_policy" "amazon_kinesis_firehose_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess"
}

data "aws_iam_policy" "amazon_kinesis_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

data "aws_iam_policy" "amazon_ssm_managed_instance_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloudwatch_full_access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
