resource "aws_s3_bucket" "bucket" {
  bucket        = var.deployment.name
  force_destroy = true
}
