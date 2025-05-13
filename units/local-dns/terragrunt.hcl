include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/modules/local-dns"
}

inputs = {
  local-ip = feature.local-ip.value
}

feature "local-ip" {
  default = run_cmd("sh", "-c", "./get_ip.sh")
}