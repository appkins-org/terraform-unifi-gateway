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
