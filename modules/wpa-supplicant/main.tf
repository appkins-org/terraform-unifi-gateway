module "package" {
  for_each = local.packages

  source = "../package"

  name            = each.key
  package_version = "latest"

  ssh = var.ssh
}

module "config" {
  source = "../config"

  files = local.files

  // commands_after_file_changes = [
  //   "if [ ! -f /etc/wpa_supplicant/wpa_supplicant.conf ]; then cp ",
  // ]

  commands = local.commands

  commands_after_file_changes = true

  ssh = var.ssh

  depends_on = [module.package]
}

# module "shell" {
#   source = "../shell"
#
#   create = file("${path.module}/scripts/create.sh")
#   read   = file("${path.module}/scripts/read.sh")
#   update = file("${path.module}/scripts/update.sh")
#   delete = file("${path.module}/scripts/delete.sh")
#
#   host     = var.ssh.host
#   port     = var.ssh.port
#   username = var.ssh.username
# }
