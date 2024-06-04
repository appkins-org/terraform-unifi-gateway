resource "ssh_resource" "default" {
  # The default behaviour is to run file blocks and commands at create time
  # You can also specify 'destroy' to run the commands at destroy time
  when = "create"


  # Try to complete in at most 15 minutes and wait 5 seconds between retries
  timeout     = "15m"
  retry_delay = "5s"

  pre_commands = local.pre_commands

  dynamic "file" {
    for_each = var.files
    content {
      destination = file.value.destination
      content     = file.value.content
      source      = file.value.source
      permissions = file.value.permissions
      owner       = file.value.owner
      group       = file.value.group
    }
  }

  // commands = [
  //   "/tmp/hello.sh"
  // ]

  host        = var.ssh.host
  user        = var.ssh.username
  port        = var.ssh.port
  private_key = var.ssh.private_key
}
