resource "aws_lakeformation_permissions" "zeppelin_database" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["ALL"]

  database {
    name = aws_glue_catalog_database.zeppelin_database.name
  }
}

resource "aws_lakeformation_permissions" "hive_database" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["DESCRIBE"]
  database {
    name       = aws_glue_catalog_database.hive_database.name
    catalog_id = data.aws_caller_identity.current.account_id
  }
}

# resource "aws_lakeformation_permissions" "ingestion_stream_table" {
#   principal   = "arn:aws:iam::541792499640:role/slt-8-log-analytics-demo-berndherding-zeppelin-notebook"
#   permissions = ["SELECT", "DESCRIBE"]

#   table {
#     database_name = "slt-8-log-analytics-demo-berndherding"
#     name          = "ingestion_stream"
#   }
# }

# resource "aws_lakeformation_permissions" "catalog_create_db" {
#   count       = local.lakeformation_enabled ? 1 : 0
#   principal   = "arn:aws:iam::${local.account_id}:role/slt-0-storm-library-for-terraform-deployment" # local.account_id
#   permissions = ["CREATE_DATABASE"]

#   catalog_resource = true
# }
