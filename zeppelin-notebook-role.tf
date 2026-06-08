resource "aws_iam_role" "zeppelin_notebook" {
  name               = "${local._deployment}-zeppelin-notebook"
  assume_role_policy = data.aws_iam_policy_document.zeppelin_notebook_assume_role.json
  depends_on = [

  ]
}

data "aws_iam_policy_document" "zeppelin_notebook_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["kinesisanalytics.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:kinesisanalytics:${local.region}:${local.account_id}:application/${local._deployment}"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "zeppelin_notebook" {
  role       = aws_iam_role.zeppelin_notebook.name
  policy_arn = aws_iam_policy.zeppelin_notebook.arn
}

resource "aws_iam_policy" "zeppelin_notebook" {
  name        = "${local._deployment}-zeppelin-notebook"
  description = "Policy for the Kinesis Flink Zeppelin Notebook ${local._deployment}"
  policy      = data.aws_iam_policy_document.zeppelin_notebook.json
}

data "aws_iam_policy_document" "zeppelin_notebook" {
  # checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  # checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"

  # statement {
  #   sid = "EverythingGlue"
  #   actions = [
  #     "glue:*"
  #   ]
  #   resources = [
  #     "*"
  #   ]
  # }

  statement {
    sid = "EverythingLakeFormation"
    actions = [
      "lakeformation:GrantPermissions",
      "lakeformation:GetDataAccess"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "ListCloudwatchLogGroups"
    actions = [
      "logs:DescribeLogGroups"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:*"
    ]
  }
  statement {
    sid = "ListCloudwatchLogStreams"
    actions = [
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesis-analytics/${local._deployment}:log-stream:*"
    ]
  }
  statement {
    sid = "PutCloudwatchLogs"
    actions = [
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/kinesis-analytics/${local._deployment}:log-stream:*"
    ]
  }
  statement {
    sid = "GlueReadDatabase"
    actions = [
      "glue:GetDatabase"
    ]
    resources = [
      aws_glue_catalog_database.zeppelin_database.arn,
      "arn:aws:glue:${local.region}:${local.account_id}:database/*",
      "arn:aws:glue:${local.region}:${local.account_id}:database/default",
      "arn:aws:glue:${local.region}:${local.account_id}:database/hive",
      "arn:aws:glue:${local.region}:${local.account_id}:catalog"
    ]
  }
  statement {
    sid = "GlueReadConnection"
    actions = [
      "glue:GetConnection"
    ]
    resources = [
      "arn:aws:glue:${local.region}:${local.account_id}:connection/*",
      "arn:aws:glue:${local.region}:${local.account_id}:catalog"
    ]
  }
  statement {
    sid = "GlueTable"
    actions = [
      "glue:GetTable",
      "glue:GetTables",
      "glue:CreateTable",
      "glue:DeleteTable",
      "glue:UpdateTable"
    ]
    resources = [
      "arn:aws:glue:${local.region}:${local.account_id}:table/${aws_glue_catalog_database.zeppelin_database.name}/*",
      "arn:aws:glue:${local.region}:${local.account_id}:database/${aws_glue_catalog_database.zeppelin_database.name}",
      "arn:aws:glue:${local.region}:${local.account_id}:table/hive/*",  # flink default, always needed
      "arn:aws:glue:${local.region}:${local.account_id}:database/hive", # flink default, always needed
      "arn:aws:glue:${local.region}:${local.account_id}:catalog"
    ]
  }
  statement {
    sid = "GlueGetDatabases"
    actions = [
      "glue:GetDatabases"
    ]
    resources = [
      "arn:aws:glue:${local.region}:${local.account_id}:catalog"
    ]
  }
  statement {
    sid = "GluePartitions"
    actions = [
      "glue:GetPartitions"
    ]
    resources = [
      "arn:aws:glue:${local.region}:${local.account_id}:catalog",
      "arn:aws:glue:${local.region}:${local.account_id}:database/${aws_glue_catalog_database.zeppelin_database.name}",
      # "arn:aws:glue:${local.region}:${local.account_id}:table/${local._deployment}/ingestion_stream"
      "arn:aws:glue:${local.region}:${local.account_id}:table/${local._deployment}/*"
    ]
  }
  statement {
    sid = "GlueUserDefinedFunctions"
    actions = [
      "glue:GetUserDefinedFunction"
    ]
    resources = [
      "arn:aws:glue:${local.region}:${local.account_id}:catalog",
      "arn:aws:glue:${local.region}:${local.account_id}:database/${aws_glue_catalog_database.zeppelin_database.name}",
      "arn:aws:glue:${local.region}:${local.account_id}:userDefinedFunction/*"
    ]
  }
  statement {
    sid = "ReadCustomArtifact"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}/*" # TODO: maybe restrict to .jars
    ]
  }
  statement {
    sid = "ListShards"
    actions = [
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      aws_kinesis_stream.ingestion_stream.arn,
      "${aws_kinesis_stream.ingestion_stream.arn}/*",                # TODO: check if necessary
      "arn:aws:kinesis:${local.region}:${local.account_id}:stream/*" # NAME UNKNOWN IN ADVANCE
    ]
  }
  statement {
    sid = "AllowAllFirehoseActions"
    actions = [
      "firehose:*"
    ]
    resources = [ # TODO: too permissive
      "*"
    ]
  }
}
