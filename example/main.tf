locals {
  networks = { for k, v in yamldecode(file("${path.root}/networks.yaml")) : k => merge({ clients = [] }, v, { domain_name = "appkins.io" }) }
}

module "unifi" {
  source = "../"

  networks = local.networks
}
