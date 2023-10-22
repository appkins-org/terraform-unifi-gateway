resource "unifi_network" "network" {
  name            = title(var.name)
  purpose         = var.purpose
  subnet          = var.subnet
  domain_name     = var.domain_name
  dhcp_enabled    = var.dhcp.enabled
  dhcp_start      = coalesce(var.dhcp.start, cidrhost(var.subnet, 6))
  dhcp_stop       = coalesce(var.dhcp.stop, cidrhost(var.subnet, -2))
  dhcp_v6_enabled = var.dhcp.v6_enabled
  site            = var.site
  multicast_dns   = var.multicast_dns

  vlan_id = var.vlan_id

  internet_access_enabled = var.internet_access

  wan_dhcp_v6_pd_size = var.wan.dhcp_v6_pd_size
  wan_dns             = var.wan.dns
  wan_egress_qos      = var.wan.egress_qos
  wan_gateway         = var.wan.gateway
  wan_gateway_v6      = var.wan.gateway_v6
  wan_ip              = var.wan.ip
  wan_ipv6            = var.wan.ipv6
  wan_netmask         = var.wan.netmask
  wan_networkgroup    = var.wan.networkgroup
  wan_prefixlen       = var.wan.prefixlen
  wan_type            = var.wan.type
  wan_type_v6         = var.wan.type_v6
  wan_username        = var.wan.username
  x_wan_password      = var.wan.password

  ipv6_interface_type        = var.ipv6.interface_type
  ipv6_pd_interface          = var.ipv6.pd_interface
  ipv6_pd_prefixid           = var.ipv6.pd_prefixid
  ipv6_pd_start              = var.ipv6.pd_start
  ipv6_pd_stop               = var.ipv6.pd_stop
  ipv6_ra_enable             = var.ipv6.ra_enable
  ipv6_ra_preferred_lifetime = var.ipv6.ra_preferred_lifetime
  ipv6_ra_priority           = var.ipv6.ra_priority
  ipv6_ra_valid_lifetime     = var.ipv6.ra_valid_lifetime
  ipv6_static_subnet         = var.ipv6.static_subnet

  lifecycle {
    ignore_changes = [ipv6_ra_valid_lifetime, ipv6_ra_enable, ipv6_pd_start, ipv6_pd_stop, ipv6_ra_preferred_lifetime, ipv6_ra_priority, dhcp_v6_start, dhcp_v6_stop]
  }
}

resource "unifi_user_group" "client_groups" {
  for_each = var.client_groups

  name = title(each.key)

  qos_rate_max_down = each.value.qos_rate_max_down # 10kbps
  qos_rate_max_up   = each.value.qos_rate_max_up   # 10kbps
}

resource "unifi_user" "clients" {
  for_each = { for client in var.clients : client.name => client }

  mac  = each.value.mac
  name = title(each.value.name)
  note = each.value.note

  fixed_ip   = each.value.ip
  network_id = unifi_network.network.id

  site = var.site
}
