resource "aws_glue_catalog_database" "zeppelin_database" {
  name = var.deployment.name
}

# Flink needs this
resource "aws_glue_catalog_database" "hive" {
  description = "Workaround for Flink HiveCatalog default DB"
  name        = "hive"
}
