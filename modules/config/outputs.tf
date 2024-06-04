output "result" {
  value = try(jsondecode(ssh_resource.default.result), {})
}
