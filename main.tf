resource "unifi_port_profile" "port_profiles" {
  for_each = { for profile in var.port_profiles : profile.name => profile }

  name                           = each.value.name
  autoneg                        = each.value.autoneg
  dot1x_ctrl                     = each.value.dot1x_ctrl
  dot1x_idle_timeout             = each.value.dot1x_idle_timeout
  egress_rate_limit_kbps         = each.value.egress_rate_limit_kbps
  egress_rate_limit_kbps_enabled = each.value.egress_rate_limit_kbps_enabled
  forward                        = each.value.forward
  full_duplex                    = each.value.full_duplex
  isolation                      = each.value.isolation
  lldpmed_enabled                = each.value.lldpmed_enabled
  lldpmed_notify_enabled         = each.value.lldpmed_notify_enabled
  native_networkconf_id          = each.value.native_networkconf_id
  op_mode                        = each.value.op_mode
  poe_mode                       = each.value.poe_mode
  port_security_enabled          = each.value.port_security_enabled
  port_security_mac_address      = each.value.port_security_mac_address
  priority_queue1_level          = each.value.priority_queue1_level
  priority_queue2_level          = each.value.priority_queue2_level
  priority_queue3_level          = each.value.priority_queue3_level
  priority_queue4_level          = each.value.priority_queue4_level
  speed                          = each.value.speed
  stormctrl_bcast_enabled        = each.value.stormctrl_bcast_enabled
  stormctrl_bcast_level          = each.value.stormctrl_bcast_level
  stormctrl_bcast_rate           = each.value.stormctrl_bcast_rate
  stormctrl_mcast_enabled        = each.value.stormctrl_mcast_enabled
  stormctrl_mcast_level          = each.value.stormctrl_mcast_level
  stormctrl_mcast_rate           = each.value.stormctrl_mcast_rate
  stormctrl_type                 = each.value.stormctrl_type
  stormctrl_ucast_enabled        = each.value.stormctrl_ucast_enabled
  stormctrl_ucast_level          = each.value.stormctrl_ucast_level
  stormctrl_ucast_rate           = each.value.stormctrl_ucast_rate
  stp_port_mode                  = each.value.stp_port_mode
  tagged_vlan_mgmt               = each.value.tagged_vlan_mgmt
  voice_networkconf_id           = each.value.voice_networkconf_id

  site = var.site
}

resource "unifi_device" "devices" {
  for_each = { for device in var.devices : device.name => device }

  name = each.value.name
  mac  = each.value.mac

  allow_adoption    = each.value.allow_adoption
  forget_on_destroy = each.value.forget_on_destroy

  dynamic "port_override" {
    for_each = var.devices[0].port_overrides

    content {
      number = coalesce(port_override.value.number, port_override.key)
      name   = coalesce(port_override.value.name, "Port ${port_override.key}")
      port_profile_id = coalesce(
        port_override.value.port_profile_id,
        try(contains(keys(local.port_profiles_lookup), port_override.port_profile) ? data.unifi_port_profile.port_profiles[port_override.port_profile].id : unifi_port_profile.port_profiles[port_override.port_profile].id, "")
      )
    }
  }

  site = var.site
}

resource "unifi_network" "networks" {
  for_each = var.networks

  name                = title(each.key)
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
  multicast_dns       = each.value.multicast_dns

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

  site = var.site

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

  site = var.site
}

resource "unifi_port_forward" "default" {
  for_each = { for port_forward in var.port_forwards : port_forward.name => port_forward }

  name                   = each.value.name
  dst_port               = each.value.dst_port
  fwd_ip                 = each.value.fwd_ip
  fwd_port               = each.value.fwd_port
  log                    = each.value.log
  port_forward_interface = each.value.port_forward_interface
  protocol               = each.value.protocol
  src_ip                 = each.value.src_ip
}

resource "unifi_dynamic_dns" "dns" {
  count = var.dyndns.enabled ? 1 : 0

  service = var.dyndns.service

  host_name = var.dyndns.hostname

  server   = var.dyndns.server
  login    = var.dyndns.username
  password = var.dyndns.password

  site = var.site
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

  site = var.site
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

  site = var.site
}

resource "unifi_setting_usg" "default" {
  count = var.settings.usg != null ? 1 : 0

  dhcp_relay_servers         = var.settings.usg.dhcp_relay_servers
  firewall_guest_default_log = var.settings.usg.firewall_guest_default_log
  firewall_lan_default_log   = var.settings.usg.firewall_lan_default_log
  firewall_wan_default_log   = var.settings.usg.firewall_wan_default_log
  multicast_dns_enabled      = var.settings.usg.multicast_dns_enabled

  site = var.site
}
