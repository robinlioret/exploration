terraform {
  source = "${get_repo_root()}/modules/cert-issuer"
}

inputs = {
  ca_cert_export_path = "${get_repo_root()}/files/ca.sandbox.local.crt"
}

dependency "cert-manager" {
  config_path                             = "../cert-manager"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}