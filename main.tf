module "network" {
  source = "./modules/network"

  for_each = var.networks

  name = title(each.key)

  site            = each.value.site
  purpose         = each.value.purpose
  subnet          = each.value.subnet
  domain_name     = each.value.domain_name
  multicast_dns   = each.value.multicast_dns
  internet_access = each.value.internet_access
  vlan_id         = each.value.vlan_id
  dhcp            = each.value.dhcp

  client_groups = each.value.client_groups
  clients       = each.value.clients

  wan  = each.value.wan
  ipv6 = each.value.ipv6

}

resource "unifi_dynamic_dns" "dns" {
  count = var.dyndns.enabled ? 1 : 0

  service = var.dyndns.service

  host_name = var.dyndns.hostname

  server   = var.dyndns.server
  login    = var.dyndns.username
  password = var.dyndns.password
}
