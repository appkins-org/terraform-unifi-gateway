module "udm_boot" {
  source = "../"

  wan_interface = "eth10"
  mac_address   = "88:96:4E:E3:A1:71"

  ca_cert     = file("~/Downloads/EAP-TLS_8021x_001E46-R91NH8MB302415/CA_001E46-R91NH8MB302415.pem")
  client_cert = file("~/Downloads/EAP-TLS_8021x_001E46-R91NH8MB302415/Client_001E46-R91NH8MB302415.pem")
  private_key = file("~/Downloads/EAP-TLS_8021x_001E46-R91NH8MB302415/PrivateKey_PKCS1_001E46-R91NH8MB302415.pem")

  ssh = {
    host        = "ui.appkins.io"
    port        = 2222
    username    = "root"
    private_key = file("~/.ssh/id_rsa")
  }
}
