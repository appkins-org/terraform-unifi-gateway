mock_provider "unifi" {}

# Apply run block to create the bucket
run "create_networks" {
  variables {
    networks = {
      "default" = {
        subnet = "10.0.0.1/16"
      }
    }
  }

  # Check that the network has an id
  assert {
    condition     = (unifi_network.networks["default"].id != null) && (unifi_network.networks["default"].id != "")
    error_message = "Invalid network id"
  }
}

# Test basic WireGuard network creation
run "create_wireguard_network_basic" {
  variables {
    networks = {
      "wireguard" = {
        subnet  = "10.1.0.1/24"
        purpose = "wan"
        wireguard = {
          enabled     = true
          public_key  = "test-public-key-123"
          private_key = "test-private-key-456"
        }
      }
    }
  }

  # Check that the WireGuard network is created with correct properties
  assert {
    condition     = unifi_network.networks["wireguard"].id != null && unifi_network.networks["wireguard"].id != ""
    error_message = "WireGuard network should have a valid ID"
  }

  assert {
    condition     = unifi_network.networks["wireguard"].name == "Wireguard"
    error_message = "WireGuard network name should be 'Wireguard'"
  }

  assert {
    condition     = unifi_network.networks["wireguard"].purpose == "wan"
    error_message = "WireGuard network purpose should be 'wan'"
  }

  assert {
    condition     = unifi_network.networks["wireguard"].wireguard_public_key == "test-public-key-123"
    error_message = "WireGuard public key should match the configured value"
  }

  assert {
    condition     = unifi_network.networks["wireguard"].wireguard_private_key == "test-private-key-456"
    error_message = "WireGuard private key should match the configured value"
  }
}

# Test WireGuard network with manual client mode
run "create_wireguard_network_manual_client" {
  variables {
    networks = {
      "wireguard-client" = {
        subnet  = "10.2.0.1/24"
        purpose = "wan"
        wireguard = {
          enabled                = true
          client_mode            = "auto"
          client_peer_ip         = "203.0.113.1"
          client_peer_port       = 51820
          client_peer_public_key = "peer-public-key-789"
          client_preshared_key   = "preshared-key-abc"
          public_key             = "server-public-key-def"
          private_key            = "server-private-key-ghi"
        }
      }
    }
  }

  # Check WireGuard client configuration
  assert {
    condition     = unifi_network.networks["wireguard-client"].wireguard_client_mode == "manual"
    error_message = "WireGuard client mode should be 'manual'"
  }

  assert {
    condition     = unifi_network.networks["wireguard-client"].wireguard_client_peer_ip == "203.0.113.1"
    error_message = "WireGuard client peer IP should match configured value"
  }

  assert {
    condition     = unifi_network.networks["wireguard-client"].wireguard_client_peer_port == 51820
    error_message = "WireGuard client peer port should be 51820"
  }

  assert {
    condition     = unifi_network.networks["wireguard-client"].wireguard_client_peer_public_key == "peer-public-key-789"
    error_message = "WireGuard client peer public key should match configured value"
  }

  assert {
    condition     = unifi_network.networks["wireguard-client"].wireguard_client_preshared_key_enabled == true
    error_message = "WireGuard preshared key should be enabled when preshared_key is provided"
  }
}

# Test WireGuard network with auto client mode
run "create_wireguard_network_auto_client" {
  variables {
    networks = {
      "wireguard-auto" = {
        subnet  = "10.3.0.1/24"
        purpose = "wan"
        wireguard = {
          enabled     = true
          client_mode = "manual"
          public_key  = "auto-public-key-123"
          private_key = "auto-private-key-456"
        }
      }
    }
  }

  # Check WireGuard auto client configuration
  assert {
    condition     = unifi_network.networks["wireguard-auto"].wireguard_client_mode == "auto"
    error_message = "WireGuard client mode should be 'auto'"
  }

  assert {
    condition     = unifi_network.networks["wireguard-auto"].wireguard_public_key == "auto-public-key-123"
    error_message = "WireGuard public key should match configured value"
  }

  assert {
    condition     = unifi_network.networks["wireguard-auto"].wireguard_private_key == "auto-private-key-456"
    error_message = "WireGuard private key should match configured value"
  }
}

# Test WireGuard disabled network (should not set WireGuard properties)
run "create_network_wireguard_disabled" {
  variables {
    networks = {
      "regular" = {
        subnet = "10.4.0.1/24"
        wireguard = {
          enabled = false
        }
      }
    }
  }

  # Check that WireGuard is not enabled
  assert {
    condition     = unifi_network.networks["regular"].wireguard_client_mode == null
    error_message = "WireGuard client mode should be null when WireGuard is disabled"
  }

  assert {
    condition     = unifi_network.networks["regular"].wireguard_public_key == null
    error_message = "WireGuard public key should be null when WireGuard is disabled"
  }

  assert {
    condition     = unifi_network.networks["regular"].wireguard_private_key == null
    error_message = "WireGuard private key should be null when WireGuard is disabled"
  }
}

# Test multiple WireGuard networks
run "create_multiple_wireguard_networks" {
  variables {
    networks = {
      "wg-vpn1" = {
        subnet  = "10.5.0.1/24"
        purpose = "wan"
        wireguard = {
          enabled     = true
          client_mode = "manual"
          public_key  = "vpn1-public-key"
          private_key = "vpn1-private-key"
        }
      }
      "wg-vpn2" = {
        subnet  = "10.6.0.1/24"
        purpose = "wan"
        wireguard = {
          enabled     = true
          client_mode = "manual"
          public_key  = "vpn2-public-key"
          private_key = "vpn2-private-key"
        }
      }
    }
  }

  # Check that both networks are created
  assert {
    condition     = length([for k, v in unifi_network.networks : k if contains(["wg-vpn1", "wg-vpn2"], k)]) == 2
    error_message = "Both WireGuard networks should be created"
  }

  # Check first WireGuard network
  assert {
    condition     = unifi_network.networks["wg-vpn1"].wireguard_client_mode == "manual"
    error_message = "First WireGuard network should have manual client mode"
  }

  # Check second WireGuard network
  assert {
    condition     = unifi_network.networks["wg-vpn2"].wireguard_client_mode == "auto"
    error_message = "Second WireGuard network should have auto client mode"
  }
}

# Test WireGuard network with all optional parameters
run "create_wireguard_network_full_config" {
  variables {
    networks = {
      "wg-full" = {
        subnet      = "10.7.0.1/24"
        purpose     = "wan"
        domain_name = "wireguard.local"
        dhcp = {
          enabled = false
        }
        wireguard = {
          enabled                = true
          client_mode            = "manual"
          client_peer_ip         = "192.0.2.1"
          client_peer_port       = 443
          client_peer_public_key = "full-peer-public-key"
          client_preshared_key   = "full-preshared-key"
          public_key             = "full-server-public-key"
          private_key            = "full-server-private-key"
        }
      }
    }
  }

  # Comprehensive checks for full WireGuard configuration
  assert {
    condition     = unifi_network.networks["wg-full"].name == "Wg-Full"
    error_message = "Network name should be properly formatted"
  }

  assert {
    condition     = unifi_network.networks["wg-full"].domain_name == "wireguard.local"
    error_message = "Domain name should be set correctly"
  }

  assert {
    condition     = unifi_network.networks["wg-full"].dhcp_enabled == false
    error_message = "DHCP should be disabled"
  }

  assert {
    condition = alltrue([
      unifi_network.networks["wg-full"].wireguard_client_mode == "manual",
      unifi_network.networks["wg-full"].wireguard_client_peer_ip == "192.0.2.1",
      unifi_network.networks["wg-full"].wireguard_client_peer_port == 443,
      unifi_network.networks["wg-full"].wireguard_client_peer_public_key == "full-peer-public-key",
      unifi_network.networks["wg-full"].wireguard_public_key == "full-server-public-key",
      unifi_network.networks["wg-full"].wireguard_private_key == "full-server-private-key"
    ])
    error_message = "All WireGuard configuration parameters should be set correctly"
  }
}
