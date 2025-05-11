resource "helm_release" "this" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.2"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  set {
    name  = "crds.enabled"
    value = true
  }
}