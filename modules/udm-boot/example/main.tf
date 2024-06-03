module "udm_boot"  {
  source = "../"
  ssh = {
    host = "ui.appkins.io"
    port = 2222
    username = "root"
  }
}
