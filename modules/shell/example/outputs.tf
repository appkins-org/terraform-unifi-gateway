output "lifecycle_commands" {
  value = module.shell_script.lifecycle_commands["create"]
}

output "name" {
  value = lookup(coalesce(module.shell_script.result, {}), "name", "")
}

output "result" {
  value = module.shell_script.result
}
