locals {
  network_clients = merge([
    for k, v in var.networks : {
      for client in v.clients : "${k}-${client.name}" => merge(v, {
        network_key = k
      })
    }
  ]...)

  port_profiles_lookup = merge([
    for device in var.devices : {
      for port_override in device.port_overrides : port_override.port_profile => true if !contains(var.port_profiles[*].name, port_override.port_profile)
    }
  ]...)
}
