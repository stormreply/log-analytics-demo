resource "aws_lakeformation_permissions" "catalog_create_db" {
  principal   = local.caller_iam_role_arn
  permissions = ["CREATE_DATABASE"]

  catalog_resource = true
}

resource "aws_lakeformation_permissions" "zeppelin_database" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["ALL"]

  database {
    name = aws_glue_catalog_database.zeppelin_database.name
  }
}

resource "aws_lakeformation_permissions" "hive_database" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["ALL"]
  database {
    name       = aws_glue_catalog_database.hive_database.name
    catalog_id = data.aws_caller_identity.current.account_id
  }
}
