variable "name" {
  type        = string
  description = "Name of the unifi network"
}

variable "site" {
  type        = string
  description = "Site of the unifi network"
  default     = "default"
  nullable    = false
}

variable "purpose" {
  type        = string
  description = "Purpose of the unifi network"
  default     = "corporate"
  nullable    = false

  validation {
    condition     = can(regex("^(corporate|guest|iot|wan)$", var.purpose))
    error_message = "Purpose must be one of corporate, guest, iot, wan"
  }
}

variable "subnet" {
  type        = string
  description = "Subnet of the unifi network"

  validation {
    condition     = can(regex("^(10|172|192)\\.[0-9]{1,3}\\.[0-9]{1,3}\\.(0|16|31|32|168)\\/(8|16|24)$", var.subnet))
    error_message = "Subnet must be a valid IPv4 subnet"
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name of the unifi network"
}

variable "multicast_dns" {
  type        = bool
  description = "Multicast DNS of the unifi network"
  default     = true
  nullable    = false
}

variable "internet_access" {
  type        = bool
  description = "Specifies whether this network should be allowed to access the internet or not."
  default     = true
  nullable    = false
}

variable "vlan_id" {
  type        = string
  default     = 0
  nullable    = false
  description = "VLAN ID of the unifi network"
}

variable "dhcp" {
  type = object({
    enabled    = optional(bool, true)
    start      = optional(string)
    stop       = optional(string)
    v6_enabled = optional(bool, false)
    boot = optional(object({
      enabled   = optional(bool, false)
      file_name = optional(string, "pxelinux.0")
      server    = optional(string)
    }))
  })
  description = "DHCP settings of the unifi network"
  default     = {}
  nullable    = false
}

variable "wan" {
  type = object({
    dhcp_v6_pd_size = optional(number)           # Specifies the IPv6 prefix size to request from ISP. Must be between 48 and 64.
    dns             = optional(list(string), []) # DNS servers IPs of the WAN.
    egress_qos      = optional(number)           # Specifies the WAN egress quality of service. Defaults to 0.
    gateway         = optional(string)           # The IPv4 gateway of the WAN.
    gateway_v6      = optional(string)           # The IPv6 gateway of the WAN.
    ip              = optional(string)           # The IPv4 address of the WAN.
    ipv6            = optional(string)           # The IPv6 address of the WAN.
    netmask         = optional(string)           # The IPv4 netmask of the WAN.
    networkgroup    = optional(string)           # Specifies the WAN network group. Must be one of either WAN, WAN2 or WAN_LTE_FAILOVER.
    prefixlen       = optional(number)           # The IPv6 prefix length of the WAN. Must be between 1 and 128.
    type            = optional(string)           # Specifies the IPV4 WAN connection type. Must be one of either disabled, static, dhcp, or pppoe.
    type_v6         = optional(string)           # Specifies the IPV6 WAN connection type. Must be one of either disabled, static, or dhcpv6.
    username        = optional(string)           # Specifies the IPV4 WAN username.
    password        = optional(string)           # Specifies the IPV4 WAN password.
  })
  description = "WAN settings of the unifi network"
  default     = {}
  nullable    = false
}

variable "ipv6" {
  type = object({
    interface_type        = optional(string, "none") # Specifies which type of IPv6 connection to use. Must be one of either static, pd, or none. Defaults to none.
    pd_interface          = optional(string)         # Specifies which WAN interface to use for IPv6 PD. Must be one of either wan or wan2.
    pd_prefixid           = optional(string)         # Specifies the IPv6 Prefix ID.
    pd_start              = optional(string)         # Start address of the DHCPv6 range. Used if ipv6_interface_type is set to pd.
    pd_stop               = optional(string)         # End address of the DHCPv6 range. Used if ipv6_interface_type is set to pd.
    ra_enable             = optional(bool, false)    # Specifies whether to enable router advertisements or not.
    ra_preferred_lifetime = optional(number, 14400)  # Lifetime in which the address can be used. Address becomes deprecated afterwards. Must be lower than or equal to ipv6_ra_valid_lifetime Defaults to 14400.
    ra_priority           = optional(string)         # IPv6 router advertisement priority. Must be one of either high, medium, or low
    ra_valid_lifetime     = optional(number, 86400)  # Total lifetime in which the address can be used. Must be equal to or greater than ipv6_ra_preferred_lifetime. Defaults to 86400.
    static_subnet         = optional(string)         # Specifies the static IPv6 subnet when ipv6_interface_type is 'static'.
  })
  description = "IPv6 configuration."
  default     = {}
  nullable    = false

  validation {
    condition     = can(regex("^(static|pd|none)$", var.ipv6.interface_type))
    error_message = "IPv6 interface type must be one of static, pd, none"
  }

  validation {
    condition     = var.ipv6.pd_interface == null || can(regex("^(wan|wan2)$", var.ipv6.pd_interface))
    error_message = "IPv6 PD interface must be one of wan, wan2"
  }
}

variable "client_groups" {
  type = map(object({
    site              = optional(string, "default")
    qos_rate_max_down = optional(number, -1)
    qos_rate_max_up   = optional(number, -1)
  }))
  description = "Client groups of the unifi network"
  default     = {}
  nullable    = false
}

variable "clients" {
  type = list(object({
    name             = string
    mac              = string
    ip               = optional(string)
    note             = optional(string)
    allow_existing   = optional(bool, true)
    local_dns_record = optional(string)
  }))
  description = "Clients of the unifi network"
  default     = []
  nullable    = false
}
