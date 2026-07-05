tflint {
  required_version = ">= 0.50.0"
}

config {
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
