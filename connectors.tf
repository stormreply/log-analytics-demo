locals {
  connector_url = {
    flink-sql-connector-aws-kinesis-firehose = "http://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-aws-kinesis-firehose/5.0.0-1.19/flink-sql-connector-aws-kinesis-firehose-5.0.0-1.19.jar"
    flink-sql-connector-kinesis              = "http://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-kinesis/5.0.0-1.19/flink-sql-connector-kinesis-5.0.0-1.19.jar"
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
    each.key = each.value.url
  }
}

resource "aws_s3_object" "connector_jar" {
  for_each = local.connector
  bucket   = aws_s3_bucket.bucket.bucket
  key      = each.value.jar
  source   = each.value.jar
  # etag = filemd5(local.connector_jar)
  depends_on = [
    null_resource.connector_download
  ]
}
