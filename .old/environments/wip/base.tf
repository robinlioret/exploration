module "dns" {
  source = "../../modules/dns"

  domain = "sandbox.local"
}

module "cluster" {
  source = "../../modules/cluster"

  name = "sandbox"
}
