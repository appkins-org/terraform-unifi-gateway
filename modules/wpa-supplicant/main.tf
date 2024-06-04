module "package" {
  for_each = local.packages

  source = "../package"

  name            = each.key
  package_version = "latest"

  ssh = var.ssh
}
