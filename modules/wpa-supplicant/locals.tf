locals {

  data_dir    = "/data/wpa_supplicant"
  conf_dir    = "/etc/wpa_supplicant/conf"
  service_dir = "/etc/systemd/system/wpa_supplicant.service.d"

  override_conf = "${local.service_dir}/override.conf"

  onboot_dir = "/data/on_boot.d"

  files = [
    { # onboot -> /data/on_boot.d/0-att-bypass.sh
      destination = "${local.data_dir}/0-att-bypass.sh"
      content     = file("${path.module}/templates/0-att-bypass.sh")
    },
    { # onboot -> /etc/systemd/system/setup-att-bypass.service
      destination = "${local.data_dir}/setup-att-bypass.service"
      content     = file("${path.module}/templates/setup-att-bypass.service")
    },
    { # onboot -> /etc/systemd/system/wpa_supplicant.service.d/override.conf
      destination = "${local.data_dir}/override.conf"
      content     = templatefile("${path.module}/templates/override.conf", { wan_interface = var.wan_interface })
    },
    { # onboot -> /etc/wpa_supplicant/conf/wpa_supplicant.conf
      destination = "${local.data_dir}/wpa_supplicant.conf"
      content     = templatefile("${path.module}/templates/wpa_supplicant.conf", { mac_address = var.mac_address })
    }, # onboot -> /etc/wpa_supplicant/conf/{CA.pem,Client.pem,PrivateKey.pem}
    { destination = "${local.data_dir}/CA.pem", content = var.ca_cert },
    { destination = "${local.data_dir}/Client.pem", content = var.client_cert },
    { destination = "${local.data_dir}/PrivateKey.pem", content = var.private_key }
  ]

  destination_dirs = join(" ", [
    local.onboot_dir,
    local.conf_dir,
    local.service_dir,
    local.data_dir
  ])

  commands = [
    "for d in ${local.destination_dirs}; do if [ ! -d $d ]; then mkdir -p $d; fi",
    "for file in wpa_supplicant.conf CA.pem Client.pem PrivateKey.pem; do if [ ! -f ${local.conf_dir}/$file ]; then cp ${local.data_dir}/$file ${local.conf_dir}/$file; fi; done",
    "if [ ! -f ${local.override_conf} ]; then cp ${local.data_dir}/override.conf ${local.service_dir}/override.conf; fi",
    "if [ ! -f ${local.onboot_dir}/0-att-bypass.sh ]; then cp ${local.data_dir}/0-att-bypass.sh ${local.onboot_dir}/; fi",
    "if [ ! -f /etc/systemd/system/setup-att-bypass.service ]; then cp ${local.data_dir}/setup-att-bypass.service /etc/systemd/system/setup-att-bypass.service; fi",
    "systemctl daemon-reload",
    "systemctl enable setup-att-bypass.service",
    "systemctl start setup-att-bypass.service",
    "systemctl enable wpa_supplicant.service",
    "systemctl start wpa_supplicant.service"
  ]

  packages = {
    libreadline8  = {}
    wpasupplicant = {}
  }
}
