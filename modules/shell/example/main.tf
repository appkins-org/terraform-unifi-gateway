module "shell_script" {
  source = "../"

  host = "ui.appkins.io"
  port = 2222
  username = "root"

  environment = {
    NAME        = "HELLO-WORLD"
    DESCRIPTION = "description"
  }

  read = file("${path.module}/scripts/read.sh")

  create = file("${path.module}/scripts/read.sh")

  update = file("${path.module}/scripts/read.sh")

  delete = file("${path.module}/scripts/read.sh")
}
