module "shell_script" {
  source = "../"

  ssh = {
    host        = "ui.appkins.io"
    port        = 2222
    username    = "root"
    private_key = file("~/.ssh/id_rsa")
  }

  files = [{
    destination = "/data/test/hello-world.conf"
    content     = "Hello, World!"
    permissions = "0644"
    owner       = "root"
    group       = "root"
  }]
}
