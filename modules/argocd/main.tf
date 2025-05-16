resource "helm_release" "this" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  # TODO: add terminal capability: https://argo-cd.readthedocs.io/en/latest/operator-manual/web_based_terminal/#enabling-the-terminal
}
