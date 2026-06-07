terraform {

  required_version = ">= 1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0"
    }
  }
}
