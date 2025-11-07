resource "aws_s3_bucket" "bucket" {
  bucket        = local._name_tag
  force_destroy = true
}
