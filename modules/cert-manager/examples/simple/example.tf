module "cluster" {
  source = "../../../cluster"
}

module "example-cert-manager" {
  source = "../.."

  depends_on = [module.cluster.endpoint]
}
