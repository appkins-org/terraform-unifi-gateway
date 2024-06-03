output "package_info" {
  value = {
    version = module.package.installed_version
    md5sum = module.package.md5sum
    summary = module.package.summary
  }

}
