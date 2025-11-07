resource "aws_glue_catalog_database" "zeppelin_database" {
  name = local._name_tag
  # depends_on = [ TODO: implement aws_lakeformation_data_lake_settings
  #   aws_lakeformation_permissions.catalog_create_db
  # ]
}

# Flink needs this
resource "aws_glue_catalog_database" "hive_database" {
  description = "Workaround for Flink HiveCatalog default DB"
  name        = "hive"
  # depends_on = [ TODO: implement aws_lakeformation_data_lake_settings
  #   aws_lakeformation_permissions.catalog_create_db
  # ]
}
