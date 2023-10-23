locals {
  config   = yamldecode(file("${path.root}/config.yaml"))
  networks = { for k, v in local.config.networks : k => merge({ clients = [] }, v, { domain_name = "appkins.io" }) }
}

module "unifi" {
  source = "../"

  networks = local.networks
}
