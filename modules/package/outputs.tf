output "installed_version" {
  value = lookup(coalesce(module.shell.result, {}), "version", "")
}

output "md5sum" {
  value = lookup(coalesce(module.shell.result, {}), "md5sum", "")
}

output "summary" {
  value = lookup(coalesce(module.shell.result, {}), "summary", "")
}
