module "package" {
  source = "../package"

  url = local.package_url

  ssh = var.ssh

  package_version = "1.0.1"

  name = "udm-boot-2x"


}
