resource "unifi_network" "networks" {
  for_each = var.networks

  name                = title(each.value.name)
  purpose             = each.value.purpose
  subnet              = each.value.subnet
  domain_name         = each.value.domain_name
  dhcp_enabled        = each.value.dhcp.enabled
  dhcp_start          = coalesce(each.value.dhcp.start, cidrhost(each.value.subnet, 6))
  dhcp_stop           = coalesce(each.value.dhcp.stop, cidrhost(each.value.subnet, -2))
  dhcp_v6_enabled     = each.value.dhcp.v6_enabled
  dhcpd_boot_enabled  = each.value.dhcp.boot.enabled
  dhcpd_boot_filename = each.value.dhcp.boot.file_name
  dhcpd_boot_server   = each.value.dhcp.boot.server

  site          = var.site
  multicast_dns = each.value.multicast_dns

  vlan_id = each.value.vlan_id

  internet_access_enabled = each.value.internet_access

  wan_dhcp_v6_pd_size = each.value.wan.dhcp_v6_pd_size
  wan_dns             = each.value.wan.dns
  wan_egress_qos      = each.value.wan.egress_qos
  wan_gateway         = each.value.wan.gateway
  wan_gateway_v6      = each.value.wan.gateway_v6
  wan_ip              = each.value.wan.ip
  wan_ipv6            = each.value.wan.ipv6
  wan_netmask         = each.value.wan.netmask
  wan_networkgroup    = each.value.wan.networkgroup
  wan_prefixlen       = each.value.wan.prefixlen
  wan_type            = each.value.wan.type
  wan_type_v6         = each.value.wan.type_v6
  wan_username        = each.value.wan.username
  x_wan_password      = each.value.wan.password

  ipv6_interface_type        = each.value.ipv6.interface_type
  ipv6_pd_interface          = each.value.ipv6.pd_interface
  ipv6_pd_prefixid           = each.value.ipv6.pd_prefixid
  ipv6_pd_start              = each.value.ipv6.pd_start
  ipv6_pd_stop               = each.value.ipv6.pd_stop
  ipv6_ra_enable             = each.value.ipv6.ra_enable
  ipv6_ra_preferred_lifetime = each.value.ipv6.ra_preferred_lifetime
  ipv6_ra_priority           = each.value.ipv6.ra_priority
  ipv6_ra_valid_lifetime     = each.value.ipv6.ra_valid_lifetime
  ipv6_static_subnet         = each.value.ipv6.static_subnet

  lifecycle {
    ignore_changes = [ipv6_ra_valid_lifetime, ipv6_ra_enable, ipv6_pd_start, ipv6_pd_stop, ipv6_ra_preferred_lifetime, ipv6_ra_priority, dhcp_v6_start, dhcp_v6_stop]
  }
}

resource "unifi_user" "clients" {
  for_each = local.network_clients

  mac  = each.value.mac
  name = title(each.value.name)
  note = each.value.note

  fixed_ip   = each.value.ip
  network_id = unifi_network.networks[each.value.network_key].id

  site = var.site
}

resource "unifi_user_group" "default" {
  for_each = var.client_groups

  name = title(each.key)

  qos_rate_max_down = each.value.qos_rate_max_down # 10kbps
  qos_rate_max_up   = each.value.qos_rate_max_up   # 10kbps
}

resource "unifi_dynamic_dns" "dns" {
  count = var.dyndns.enabled ? 1 : 0

  service = var.dyndns.service

  host_name = var.dyndns.hostname

  server   = var.dyndns.server
  login    = var.dyndns.username
  password = var.dyndns.password
}

resource "unifi_setting_mgmt" "default" {
  count = var.settings.management != null ? 1 : 0

  auto_upgrade = var.settings.management.auto_upgrade
  ssh_enabled  = var.settings.management.ssh.enabled

  dynamic "ssh_key" {
    for_each = var.settings.management.ssh.keys

    content {
      name    = ssh_key.value.name
      type    = ssh_key.value.type
      key     = ssh_key.value.key
      comment = ssh_key.value.comment
    }
  }
}

resource "unifi_setting_radius" "default" {
  count = var.settings.radius != null ? 1 : 0

  enabled = var.settings.radius.enabled

  accounting_enabled = var.settings.radius.accounting.enabled
  accounting_port    = var.settings.radius.accounting.port

  auth_port               = var.settings.radius.auth_port
  interim_update_interval = var.settings.radius.interim_update_interval
  secret                  = var.settings.radius.secret
  tunneled_reply          = var.settings.radius.tunneled_reply
}

resource "unifi_setting_usg" "default" {
  count = var.settings.usg != null ? 1 : 0

  dhcp_relay_servers         = var.settings.usg.dhcp_relay_servers
  firewall_guest_default_log = var.settings.usg.firewall_guest_default_log
  firewall_lan_default_log   = var.settings.usg.firewall_lan_default_log
  firewall_wan_default_log   = var.settings.usg.firewall_wan_default_log
  multicast_dns_enabled      = var.settings.usg.multicast_dns_enabled
}
