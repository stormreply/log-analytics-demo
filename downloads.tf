
locals {
  downloads = tomap({
    "flink-sql-connector-aws-kinesis-firehose" = "http://repo1.maven.org/maven2/org/apache/flink/flink-sql-connector-aws-kinesis-firehose/5.0.0-1.19/flink-sql-connector-aws-kinesis-firehose-5.0.0-1.19.jar",
    # "apache-fake-log-gen"                      = "http://github.com/kiritbasu/Fake-Apache-Log-Generator/blob/master/apache-fake-log-gen.py"
  })
}

resource "null_resource" "download" {
  for_each = local.downloads
  provisioner "local-exec" {
    command = <<-EOT
      curl -L -o ${each.value} ${each.key}
    EOT
    quiet   = false
  }
  triggers = {
    download_url = each.value
  }
}

resource "aws_s3_object" "artifact" {
  for_each = local.downloads
  bucket   = "${var.deployment.name}-upload"
  key      = each.value
  source   = each.value
  etag     = filemd5(each.value)

  depends_on = [null_resource.download]
}
