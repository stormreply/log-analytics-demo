resource "awscc_kinesisanalyticsv2_application" "zeppelin_notebook" {
  application_name       = var.deployment.name
  application_mode       = "INTERACTIVE"
  runtime_environment    = "ZEPPELIN-FLINK-3_0"
  service_execution_role = aws_iam_role.zeppelin_notebook.arn
  application_configuration = {
    flink_application_configuration = {
      checkpoint_configuration = {
        configuration_type = "DEFAULT"
      }
      monitoring_configuration = {
        configuration_type = "CUSTOM"
        log_level          = "INFO"
      }
      parallelism_configuration = {
        configuration_type  = "CUSTOM"
        parallelism         = 4
        parallelism_per_kpu = 2
      }
    }
    zeppelin_application_configuration = {
      catalog_configuration = {
        glue_data_catalog_configuration = {
          database_arn = aws_glue_catalog_database.glue_database.arn
        }
      }
      custom_artifacts_configuration = [
        {
          artifact_type = "DEPENDENCY_JAR"
          s3_content_location = {
            bucket_arn = aws_s3_bucket.bucket.arn
            file_key   = local.connector["flink-sql-connector-kinesis"].jar
          }
        },
        {
          artifact_type = "DEPENDENCY_JAR"
          s3_content_location = {
            bucket_arn = aws_s3_bucket.bucket.arn
            file_key   = local.connector["flink-sql-connector-aws-kinesis-firehose"].jar
          }
        }
      ]
      monitoring_configuration = {
        log_level = "INFO"
      }
    }
  }
  depends_on = [
    aws_iam_policy.zeppelin_notebook,
    aws_iam_role.zeppelin_notebook,
    aws_iam_role_policy_attachment.zeppelin_notebook,
    aws_lakeformation_permissions.zeppelin_db,
    aws_glue_catalog_database.glue_database,
    aws_s3_object.connector_jar
  ]
}
