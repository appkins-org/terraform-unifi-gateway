config {
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

rule "terraform_unused_required_providers" {
  enabled = false
}
