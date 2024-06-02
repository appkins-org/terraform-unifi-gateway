# Unifi Gateway

Terraform module for provisioning a Unifi Gateway.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 0.41.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_groups"></a> [client\_groups](#input\_client\_groups) | Restrictions to apply to a group of clients. | <pre>map(object({<br>    qos_rate_max_down = optional(number, -1)<br>    qos_rate_max_up   = optional(number, -1)<br>  }))</pre> | `{}` | no |
| <a name="input_dyndns"></a> [dyndns](#input\_dyndns) | Dynamic DNS configuration | <pre>object({<br>    enabled  = optional(bool, false)<br>    hostname = optional(string)<br>    service  = optional(string)<br>    username = optional(string)<br>    password = optional(string)<br>    server   = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | Network configurations. | <pre>map(object({<br>    purpose         = optional(string, "corporate")<br>    subnet          = string<br>    domain_name     = optional(string)<br>    multicast_dns   = optional(bool, true)<br>    internet_access = optional(bool, true)<br>    vlan_id         = optional(number)<br>    dhcp = optional(object({<br>      enabled    = optional(bool, true)<br>      start      = optional(string)<br>      stop       = optional(string)<br>      v6_enabled = optional(bool, false)<br>      boot = optional(object({<br>        enabled   = optional(bool, false)<br>        file_name = optional(string, "pxelinux.0")<br>        server    = optional(string)<br>      }))<br>    }))<br>    clients = optional(list(object({<br>      name = string<br>      mac  = string<br>      ip   = optional(string)<br>    })), [])<br>    wan = optional(object({<br>      dhcp_v6_pd_size = optional(number)           # Specifies the IPv6 prefix size to request from ISP. Must be between 48 and 64.<br>      dns             = optional(list(string), []) # DNS servers IPs of the WAN.<br>      egress_qos      = optional(number)           # Specifies the WAN egress quality of service. Defaults to 0.<br>      gateway         = optional(string)           # The IPv4 gateway of the WAN.<br>      gateway_v6      = optional(string)           # The IPv6 gateway of the WAN.<br>      ip              = optional(string)           # The IPv4 address of the WAN.<br>      ipv6            = optional(string)           # The IPv6 address of the WAN.<br>      netmask         = optional(string)           # The IPv4 netmask of the WAN.<br>      networkgroup    = optional(string)           # Specifies the WAN network group. Must be one of either WAN, WAN2 or WAN_LTE_FAILOVER.<br>      prefixlen       = optional(number)           # The IPv6 prefix length of the WAN. Must be between 1 and 128.<br>      type            = optional(string)           # Specifies the IPV4 WAN connection type. Must be one of either disabled, static, dhcp, or pppoe.<br>      type_v6         = optional(string)           # Specifies the IPV6 WAN connection type. Must be one of either disabled, static, or dhcpv6.<br>      username        = optional(string)           # Specifies the IPV4 WAN username.<br>      password        = optional(string)           # Specifies the IPV4 WAN password.<br>    }), {})<br>    ipv6 = optional(object({<br>      interface_type        = optional(string, "none") # Specifies which type of IPv6 connection to use. Must be one of either static, pd, or none. Defaults to none.<br>      pd_interface          = optional(string)         # Specifies which WAN interface to use for IPv6 PD. Must be one of either wan or wan2.<br>      pd_prefixid           = optional(string)         # Specifies the IPv6 Prefix ID.<br>      pd_start              = optional(string)         # Start address of the DHCPv6 range. Used if ipv6_interface_type is set to pd.<br>      pd_stop               = optional(string)         # End address of the DHCPv6 range. Used if ipv6_interface_type is set to pd.<br>      ra_enable             = optional(bool, false)    # Specifies whether to enable router advertisements or not.<br>      ra_preferred_lifetime = optional(number, 14400)  # Lifetime in which the address can be used. Address becomes deprecated afterwards. Must be lower than or equal to ipv6_ra_valid_lifetime Defaults to 14400.<br>      ra_priority           = optional(string)         # IPv6 router advertisement priority. Must be one of either high, medium, or low<br>      ra_valid_lifetime     = optional(number, 86400)  # Total lifetime in which the address can be used. Must be equal to or greater than ipv6_ra_preferred_lifetime. Defaults to 86400.<br>      static_subnet         = optional(string)         # Specifies the static IPv6 subnet when ipv6_interface_type is 'static'.<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Unifi console settings | <pre>object({<br>    management = optional(object({<br>      auto_upgrade = optional(bool, true)<br>      ssh = optional(object({<br>        enabled = optional(bool, true)<br>        keys = optional(list(object({<br>          name    = string<br>          type    = optional(string, "ssh-rsa")<br>          key     = optional(string)<br>          comment = optional(string)<br>        })), [])<br>      }), {})<br>    }))<br>    radius = optional(object({<br>      enabled = optional(bool, false)<br>      accounting = optional(object({<br>        enabled = optional(bool, false)<br>        port    = optional(number, 1813)<br>      }), {})<br>      server                  = optional(string)<br>      auth_port               = optional(number, 1812)<br>      interim_update_interval = optional(number, 3600)<br>      secret                  = optional(string, "")<br>      tunneled_reply          = optional(bool, true)<br>    }))<br>    usg = optional(object({<br>      dhcp_relay_servers         = optional(list(string), [])<br>      firewall_guest_default_log = optional(bool, false)<br>      firewall_lan_default_log   = optional(bool, false)<br>      firewall_wan_default_log   = optional(bool, false)<br>      multicast_dns_enabled      = optional(bool, true)<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_site"></a> [site](#input\_site) | The site name. | `string` | `"default"` | no |

## Outputs

No outputs.

# Example

```hcl
locals {
  config   = yamldecode(file("${path.root}/config.yaml"))
  networks = { for k, v in local.config.networks : k => merge({ clients = [] }, v, { domain_name = "appkins.io" }) }
}

module "unifi" {
  source = "../"

  networks = local.networks
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | >= 0.41.0 |

## Resources

| Name | Type |
|------|------|
| [unifi_dynamic_dns.dns](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/dynamic_dns) | resource |
| [unifi_network.networks](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/network) | resource |
| [unifi_setting_mgmt.default](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/setting_mgmt) | resource |
| [unifi_setting_radius.default](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/setting_radius) | resource |
| [unifi_setting_usg.default](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/setting_usg) | resource |
| [unifi_user.clients](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/user) | resource |
| [unifi_user_group.default](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/user_group) | resource |

<!-- END_TF_DOCS -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```

### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test
```

## Authors

This project is authored by below people

- appkins

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
