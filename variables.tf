variable "networks" {
  type = map(object({
    purpose         = optional(string, "corporate")
    subnet          = string
    site            = optional(string, "default")
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
    client_groups = optional(map(object({
      site              = optional(string, "default")
      qos_rate_max_down = optional(number, -1)
      qos_rate_max_up   = optional(number, -1)
    })), {})
    clients = optional(list(object({
      name = string
      mac  = string
      ip   = optional(string)
    })), [])
    wan = optional(object({
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
    }), {})
    ipv6 = optional(object({
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
    }))
  }))
  description = "Network configurations."
  default     = {}
  nullable    = false
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
