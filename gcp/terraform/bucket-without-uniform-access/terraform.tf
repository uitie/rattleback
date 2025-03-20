# Provider config
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.13.0"
    }
  }

  required_version = ">= 1.1.0"
}
