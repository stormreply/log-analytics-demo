resource "aws_s3_bucket" "bucket" {
  bucket        = local._deployment
  force_destroy = true
}
