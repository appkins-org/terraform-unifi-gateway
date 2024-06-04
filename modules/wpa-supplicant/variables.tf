variable "ssh" {
  type = object({
    host     = string
    port     = number
    username = string
  })
  description = "The SSH connection details."
  nullable    = false
}
