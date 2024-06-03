output "result" {
  value = shell_script.default.output
}

output "lifecycle_commands" {
  value = {
    create = local.lifecycle_commands.create
    read   = local.lifecycle_commands.read
    update = local.lifecycle_commands.update
    delete = local.lifecycle_commands.delete
  }
}
