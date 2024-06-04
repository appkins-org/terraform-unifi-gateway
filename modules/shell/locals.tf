locals {

  export_vars = flatten([for k in keys(var.environment) : [
    format("%s=$LC_%s", k, k),
    format("unset LC_%s", k),
    format("export %s", k)
  ]])

  # export_vars = join("; ", formatlist("export %s=$LC_%s", keys(var.environment), keys(var.environment)))

  lifecycle_command_list = { for k, v in {
    create = var.create
    read   = var.read
    update = var.update
    delete = var.delete
    } : k => (v != "" && v != null) ? split("\n", v) : []
  }

  lifecycle_commands = {
    for k, commands in local.lifecycle_command_list : k => length(commands) > 0 ? join(
      "\n",
      flatten(
        [for command in commands : index(commands, command) == 0 ? concat(
          ["#!/bin/bash"],
          local.export_vars,
          [command]
          ) : [command]
    ])) : null
  }

  environment = zipmap(formatlist("LC_%s", keys(var.environment)), values(var.environment))

  host = format("%s@%s", var.username, var.host)

  interpreter = [
    "/usr/bin/ssh",
    "-p",
    var.port,
    local.host
  ]
}
