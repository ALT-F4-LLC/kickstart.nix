resource "null_resource" "this" {}
resource "random_id" "this" {
  byte_length = 16
}

output "random" {
  value = random_id.this.b64_std
}

terraform {
  required_providers {

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}
