variable "site" {
  type        = string
  description = "The site name."
  default     = "default"
  nullable    = false
}

variable "port_profiles" {
  type = list(object({
    name                           = optional(string)       # The name of the port profile.
    autoneg                        = optional(bool)         # Enable link auto negotiation for the port profile. When set to true this overrides speed. Defaults to true.
    dot1x_ctrl                     = optional(string)       # The type of 802.1X control to use. Can be auto, force_authorized, force_unauthorized, mac_based or multi_host. Defaults to force_authorized.
    dot1x_idle_timeout             = optional(number)       # The timeout, in seconds, to use when using the MAC Based 802.1X control. Can be between 0 and 65535 Defaults to 300.
    egress_rate_limit_kbps         = optional(number)       # The egress rate limit, in kpbs, for the port profile. Can be between 64 and 9999999.
    egress_rate_limit_kbps_enabled = optional(bool)         # Enable egress rate limiting for the port profile. Defaults to false.
    forward                        = optional(string)       # The type forwarding to use for the port profile. Can be all, native, customize or disabled. Defaults to native.
    full_duplex                    = optional(bool)         # Enable full duplex for the port profile. Defaults to false.
    isolation                      = optional(bool)         # Enable port isolation for the port profile. Defaults to false.
    lldpmed_enabled                = optional(bool)         # Enable LLDP-MED for the port profile. Defaults to true.
    lldpmed_notify_enabled         = optional(bool)         # Enable LLDP-MED topology change notifications for the port profile.
    native_networkconf_id          = optional(string)       # The ID of network to use as the main network on the port profile.
    op_mode                        = optional(string)       # The operation mode for the port profile. Can only be switch Defaults to switch.
    poe_mode                       = optional(string)       # The POE mode for the port profile. Can be one of auto, passv24, passthrough or off.
    port_security_enabled          = optional(bool)         # Enable port security for the port profile. Defaults to false.
    port_security_mac_address      = optional(list(string)) # The MAC addresses associated with the port security for the port profile.
    priority_queue1_level          = optional(number)       # The priority queue 1 level for the port profile. Can be between 0 and 100.
    priority_queue2_level          = optional(number)       # The priority queue 2 level for the port profile. Can be between 0 and 100.
    priority_queue3_level          = optional(number)       # The priority queue 3 level for the port profile. Can be between 0 and 100.
    priority_queue4_level          = optional(number)       # The priority queue 4 level for the port profile. Can be between 0 and 100.
    speed                          = optional(number)       # The link speed to set for the port profile. Can be one of 10, 100, 1000, 2500, 5000, 10000, 20000, 25000, 40000, 50000 or 100000
    stormctrl_bcast_enabled        = optional(bool)         # Enable broadcast Storm Control for the port profile. Defaults to false.
    stormctrl_bcast_level          = optional(number)       # The broadcast Storm Control level for the port profile. Can be between 0 and 100.
    stormctrl_bcast_rate           = optional(number)       # The broadcast Storm Control rate for the port profile. Can be between 0 and 14880000.
    stormctrl_mcast_enabled        = optional(bool)         # Enable multicast Storm Control for the port profile. Defaults to false.
    stormctrl_mcast_level          = optional(number)       # The multicast Storm Control level for the port profile. Can be between 0 and 100.
    stormctrl_mcast_rate           = optional(number)       # The multicast Storm Control rate for the port profile. Can be between 0 and 14880000.
    stormctrl_type                 = optional(string)       # The type of Storm Control to use for the port profile. Can be one of level or rate.
    stormctrl_ucast_enabled        = optional(bool)         # Enable unknown unicast Storm Control for the port profile. Defaults to false.
    stormctrl_ucast_level          = optional(number)       # The unknown unicast Storm Control level for the port profile. Can be between 0 and 100.
    stormctrl_ucast_rate           = optional(number)       # The unknown unicast Storm Control rate for the port profile. Can be between 0 and 14880000.
    stp_port_mode                  = optional(bool)         # Enable spanning tree protocol on the port profile. Defaults to true.
    tagged_vlan_mgmt               = optional(string)       # The IDs of networks to tag traffic with for the port profile.
    voice_networkconf_id           = optional(string)       # The ID of network to use as the voice network on the port profile.
  }))
  description = "Port profiles to add to the network."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for profile in var.port_profiles : profile.name != "Disabled"])
    error_message = "Disabled is a reserved profile name."
  }
}

variable "devices" {
  type = list(object({
    name              = string
    mac               = optional(string)
    forget_on_destroy = optional(bool, true)
    allow_adoption    = optional(bool, true)
    port_overrides = optional(list(object({
      number              = optional(number)
      name                = optional(string)
      aggregate_num_ports = optional(number)
      op_mode             = optional(string, "switch")
      port_profile        = optional(string)
      port_profile_id     = optional(string)
    })), [])
  }))
  description = "Devices to add to the network."
  default     = []
  nullable    = false
}

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
      }), {})
    }), {})
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
    }), {})
  }))
  description = "Network configurations."
  default     = {}
  nullable    = false
}

variable "client_groups" {
  type = map(object({
    qos_rate_max_down = optional(number, -1)
    qos_rate_max_up   = optional(number, -1)
  }))
  description = "Restrictions to apply to a group of clients."
  default     = {}
  nullable    = false
}

variable "port_forwards" {
  type = list(object({
    name                   = optional(string)            # The name of the port forwarding rule.
    dst_port               = optional(string)            # The destination port for the forwarding.
    enabled                = optional(bool, true)        # Deprecated - Specifies whether the port forwarding rule is enabled or not. Defaults to true. This will attribute will be removed in a future release. Instead of disabling a port forwarding rule you can remove it from your configuration.
    fwd_ip                 = optional(string)            # The IPv4 address to forward traffic to.
    fwd_port               = optional(string)            # The port to forward traffic to.
    log                    = optional(bool, false)       # Specifies whether to log forwarded traffic or not. Defaults to false.
    port_forward_interface = optional(string)            # The port forwarding interface. Can be wan, wan2, or both.
    protocol               = optional(string, "tcp_udp") # The protocol for the port forwarding rule. Can be tcp, udp, or tcp_udp. Defaults to tcp_udp.
    src_ip                 = optional(string, "any")     # The source IPv4 address = optional(or CIDR) # # of the port forwarding rule. For all traffic, specify any. Defaults to any.
  }))
  description = "Port forwarding rules."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for rule in var.port_forwards : contains(["tcp", "udp", "tcp_udp"], rule.protocol)])
    error_message = "Port forwarding protocol must be one of \"tcp\", \"udp\" or \"tcp_udp\"."
  }
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

variable "settings" {
  type = object({
    management = optional(object({
      auto_upgrade = optional(bool, true)
      ssh = optional(object({
        enabled = optional(bool, true)
        keys = optional(list(object({
          name    = string
          type    = optional(string, "ssh-rsa")
          key     = optional(string)
          comment = optional(string)
        })), [])
      }), {})
    }))
    radius = optional(object({
      enabled = optional(bool, false)
      accounting = optional(object({
        enabled = optional(bool, false)
        port    = optional(number, 1813)
      }), {})
      server                  = optional(string)
      auth_port               = optional(number, 1812)
      interim_update_interval = optional(number, 3600)
      secret                  = optional(string, "")
      tunneled_reply          = optional(bool, true)
    }))
    usg = optional(object({
      dhcp_relay_servers         = optional(list(string), [])
      firewall_guest_default_log = optional(bool, false)
      firewall_lan_default_log   = optional(bool, false)
      firewall_wan_default_log   = optional(bool, false)
      multicast_dns_enabled      = optional(bool, true)
    }))
  })
  description = "Unifi console settings"
  default     = {}
  nullable    = false
}

variable "wpa_supplicant" {
  description = "WPA supplicant configuration (Optional)."
  type = object({
    mac_address = string
    ca_cert     = string
    client_cert = string
    private_key = string
  })
  default  = null
  nullable = true
}

variable "ssh" {
  type = object({
    host        = string
    port        = number
    username    = string
    private_key = string
  })
  nullable = true
  default = null
}
