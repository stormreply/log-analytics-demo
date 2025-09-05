locals {
  connector_url = "http://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-aws-kinesis-firehose/5.0.0-1.19/flink-sql-connector-aws-kinesis-firehose-5.0.0-1.19.jar"
  connector_jar = regex("^.+/([^/]+)$", local.connector_url)[0]
}

resource "null_resource" "connector_download" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -L -o ${local.connector_url} ${local.connector_jar}
    EOT
    quiet   = false
  }
  triggers = {
    download_url = local.connector_url
  }
}

resource "aws_s3_object" "connector_jar" {
  bucket = "${var.deployment.name}-upload"
  key    = local.connector_jar
  source = local.connector_jar
  etag   = filemd5(local.connector_jar)

  depends_on = [null_resource.connector_download]
}
