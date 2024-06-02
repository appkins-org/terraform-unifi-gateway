locals {
  network_clients = merge([
    for k, v in var.networks : {
      for client in v.clients : "${k}-${client.name}" => merge(v, {
        network_key = k
      })
    }
  ]...)
}
