terraform {
  required_version = ">= 1.4.2"
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    shell = {
      source = "icj217/shell"
    }
  }
}
