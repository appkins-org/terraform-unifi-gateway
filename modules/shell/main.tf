resource "shell_script" "default" {
  lifecycle_commands {
    create = local.lifecycle_commands.create
    read   = local.lifecycle_commands.read
    update = local.lifecycle_commands.update
    delete = local.lifecycle_commands.delete
  }

  environment = local.environment

  interpreter = local.interpreter
}
