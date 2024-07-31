variable "mac_address" {
  type        = string
  description = "The MAC address of the ONT Device."
  nullable    = false
}

variable "wan_interface" {
  type        = string
  description = "The WAN interface."
  nullable    = false
}

variable "ca_cert" {
  description = "The CA certificate."
  type        = string
  nullable    = false
}

variable "client_cert" {
  description = "The Client certificate."
  type        = string
  nullable    = false
}

variable "private_key" {
  description = "Private key."
  type        = string
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
