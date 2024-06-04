output "package_info" {
  value = { for k in keys(local.packages) : k => {
    version = module.package[k].installed_version
    md5sum  = module.package[k].md5sum
    summary = module.package[k].summary
  } }

}
