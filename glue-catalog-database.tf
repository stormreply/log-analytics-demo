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

# locals {
#   lakeformation_enabled = data.external.lakeformation_enabled.result.enabled == "true"
# }

# resource "aws_lakeformation_permissions" "catalog_create_db" {
#   count       = local.lakeformation_enabled ? 1 : 0
#   principal   = "arn:aws:iam::${local.account_id}:role/slt-0-storm-library-for-terraform-deployment" # local.account_id
#   permissions = ["CREATE_DATABASE"]

#   catalog_resource = true
# }

resource "aws_glue_catalog_database" "glue_database" {
  name = var.deployment.name

  # depends_on = [aws_lakeformation_permissions.catalog_create_db]
}
