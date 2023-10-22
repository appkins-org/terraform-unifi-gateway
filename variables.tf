variable "networks" {
  type = map(object({
    purpose         = optional(string, "corporate")
    subnet          = string
    domain_name     = optional(string)
    multicast_dns   = optional(bool, true)
    internet_access = optional(bool, true)
    vlan_id         = optional(number)
    dhcp = optional(object({
      enabled    = optional(bool, true)
      start      = optional(string)
      stop       = optional(string)
      v6_enabled = optional(bool, false)
      boot = optional(object({
        enabled   = optional(bool, false)
        file_name = optional(string, "pxelinux.0")
        server    = optional(string)
      }))
    }))
    clients = optional(list(object({
      name = string
      mac  = string
      ip   = optional(string)
    })), [])

  }))
  description = "Network configurations."
}

variable "dyndns" {
  type = object({
    enabled  = optional(bool, false)
    hostname = optional(string)
    service  = optional(string)
    username = optional(string)
    password = optional(string)
    server   = optional(string)
  })
  description = "Dynamic DNS configuration"
  default     = {}
  nullable    = false
}
