resource "helm_release" "this" {
  name = "argo-cd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
}
