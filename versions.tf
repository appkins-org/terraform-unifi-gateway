terraform {
  required_providers {
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = ">= 0.41.0"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.7.0"
    }

    shell = {
      source = "icj217/shell"
    }
  }
}
