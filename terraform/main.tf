terraform {
    required_version = ">=1.5.0"
    required_providers {
        aws = {
            source = "hashicrop/aws"
            version = "~> 5.0"
        }
    }
}

provider aws {
    region = var.region
}


locals {
  name_prefix = "${var.project}-${var.environment}"
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}