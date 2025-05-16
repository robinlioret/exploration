terraform {
  source = "${get_repo_root()}/modules/gitops-sample"
}

inputs = {
  sample_2048_raw = true
}

dependency "argocd" {
  config_path                             = "../argocd"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}

dependency "forgejo" {
  config_path                             = "../forgejo"
  mock_outputs                            = {}
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
  skip_outputs                            = true
}
