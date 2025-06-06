terraform {
  source = "${get_repo_root()}/modules/dns"
}

inputs = {
  local_ip = feature.local_ip.value
}

feature "local_ip" {
  default = run_cmd("sh", "-c", "${get_repo_root()}/scripts/get_ip.sh")
}