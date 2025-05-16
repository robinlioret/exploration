terraform {
  source = "${get_repo_root()}/modules/argocd"
}

dependency "cluster-issuer" {
  config_path                             = "../cluster"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}
