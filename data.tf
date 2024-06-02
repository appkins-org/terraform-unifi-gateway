data "unifi_port_profile" "port_profiles" {
  for_each = local.port_profiles_lookup

  name = each.key
  site = var.site
}
