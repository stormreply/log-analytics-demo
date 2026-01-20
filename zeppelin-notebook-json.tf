resource "local_file" "zeppelin_notebook_json" {
  filename = "${path.module}/${local.zeppelin_notebook}"
  content = templatefile(
    "${path.module}/led.zeppelin", { ingestion_stream = local.ingestion_stream }
  )
}
