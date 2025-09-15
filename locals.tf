data "aws_availability_zones" "available" { state = "available" }
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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

locals {
  # lakeformation_enabled = data.external.lakeformation_enabled.result.enabled == "true"
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.region
}
