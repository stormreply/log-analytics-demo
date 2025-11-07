provider "aws" {
  default_tags {
    tags = local._default_tags
  }
}

provider "aws" {
  alias = "no_tags"
}
