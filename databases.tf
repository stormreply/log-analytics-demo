data "external" "lakeformation_enabled" {
  program = ["bash", "-c", <<EOT
    if aws lakeformation get-data-lake-settings >/dev/null 2>&1; then
      echo '{"enabled": "true"}'
    else
      echo '{"enabled": "false"}'
    fi
  EOT
  ]
}

resource "aws_glue_catalog_database" "zeppelin_database" {
  name = var.deployment.name
}

resource "aws_lakeformation_permissions" "zeppelin_database" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["ALL"]

  database {
    name = aws_glue_catalog_database.zeppelin_database.name
  }
}


resource "aws_glue_catalog_database" "hive" {
  name = "hive"

  description = "Workaround for Flink HiveCatalog default DB"
}

resource "aws_lakeformation_permissions" "hive" {
  principal   = aws_iam_role.zeppelin_notebook.arn
  permissions = ["DESCRIBE"]
  database {
    name       = aws_glue_catalog_database.hive.name
    catalog_id = data.aws_caller_identity.current.account_id
  }
}




# locals {
#   lakeformation_enabled = data.external.lakeformation_enabled.result.enabled == "true"
# }

# resource "aws_lakeformation_permissions" "catalog_create_db" {
#   count       = local.lakeformation_enabled ? 1 : 0
#   principal   = "arn:aws:iam::${local.account_id}:role/slt-0-storm-library-for-terraform-deployment" # local.account_id
#   permissions = ["CREATE_DATABASE"]

#   catalog_resource = true
# }
