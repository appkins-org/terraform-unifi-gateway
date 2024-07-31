variable "name" {
  type        = string
  description = "The name of the package to install."
}

variable "package_version" {
  type        = string
  description = "The version of the package to install."
}

variable "url" {
  type        = string
  description = "The URL of the deb package to install."
  default     = ""
  nullable    = false
}

variable "ssh" {
  type = object({
    host        = string
    port        = number
    username    = string
    private_key = string
  })
  description = "The SSH connection details."
  nullable    = false
}
