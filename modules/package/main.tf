module "shell" {
  source = "../shell"

  environment = {
    PACKAGE_NAME    = var.name
    PACKAGE_VERSION = var.package_version
    PACKAGE_URL     = var.url
  }

  create = file("${path.module}/scripts/create.sh")
  read   = file("${path.module}/scripts/read.sh")
  update = file("${path.module}/scripts/update.sh")
  delete = file("${path.module}/scripts/delete.sh")

  host     = var.ssh.host
  port     = var.ssh.port
  username = var.ssh.username
}
