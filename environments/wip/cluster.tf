module "cluster" {
  source = "../../modules/cluster"

  name = "sandbox"
  preset = "c1w0-exposed"
}
