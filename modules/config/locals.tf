locals {
  pre_commands = var.create_parents ? [
    for file in var.files : "mkdir -p $(dirname ${file.destination})"
  ] : []
}
