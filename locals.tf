data "aws_caller_identity" "current" {}
# data "aws_iam_role" "caller" {
#   name = local.caller_iam_role
# }
data "aws_region" "current" {}

# TODO: may be used in the future in order to examine whether slt-0
# deployment-role should be added to database creators role in Lake
# Formation by code
#
# data "external" "lakeformation_enabled" {
#   program = ["bash", "-c", <<EOT
#     if aws lakeformation get-data-lake-settings >/dev/null 2>&1; then
#       echo '{"enabled": "true"}'
#     else
#       echo '{"enabled": "false"}'
#     fi
#   EOT
#   ]
# }

locals {
  # lakeformation_enabled = data.external.lakeformation_enabled.result.enabled == "true"
  account_id = data.aws_caller_identity.current.account_id
  # caller_iam_role     = regex("^arn:aws:sts::\\d+:assumed-role/([^/]+)/.*", data.aws_caller_identity.current.arn)[0]
  # caller_iam_role_arn = data.aws_iam_role.caller.arn
  ingestion_stream  = "${local._deployment}-ingestion-stream"
  region            = data.aws_region.current.region
  zeppelin_notebook = "${local._deployment}.zeppelin"
}
