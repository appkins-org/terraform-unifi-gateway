output "network_ids" {
  description = "Map of network keys to network IDs"
  value       = { for k in keys(var.networks) : k => unifi_network.networks[k].id }
}
