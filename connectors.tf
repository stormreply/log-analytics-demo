locals {
  connector_url = {
    flink-sql-connector-aws-kinesis-firehose = "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-aws-kinesis-firehose/1.15.4/flink-sql-connector-aws-kinesis-firehose-1.15.4.jar"
    flink-sql-connector-kinesis              = "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kinesis/1.15.4/flink-sql-connector-kinesis-1.15.4.jar"
  }
  connector = {
    for k, v in local.connector_url :
    k => {
      url = v
      jar = regex("^.+/([^/]+)$", v)[0]
    }
  }
}

resource "null_resource" "connector_download" {
  for_each = local.connector
  provisioner "local-exec" {
    command = "curl -L -o ${each.value.jar} ${each.value.url}"
    quiet   = false
  }
  triggers = {
    "${each.key}" = each.value.url
  }
}

resource "aws_s3_object" "connector_jar" {
  for_each = local.connector
  bucket   = aws_s3_bucket.bucket.bucket
  key      = each.value.jar
  provider = aws.no_tags
  source   = each.value.jar
  # etag = filemd5(local.connector_jar)
  depends_on = [
    null_resource.connector_download
  ]
}
