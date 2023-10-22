terraform {
  required_providers {
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.41.0"
    }
  }
}

provider "unifi" {
  username       = var.username
  password       = var.password
  api_url        = "https://10.0.0.1"
  allow_insecure = true
}
