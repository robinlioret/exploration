resource "helm_release" "this" {
  name = "argo-cd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
}

resource "kubernetes_manifest" "guestbook-sample" {
  depends_on = [helm_release.this]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "guestbook-simple"
      namespace = "argo-cd"
      annotations = {
        "argocd.argoproj.io/sync-options" = join(",", [
          "Prune=true",
          "Delete=true"
        ])
      }
    }
    spec = {
      project = "default"
      source = {
        path           = "guestbook"
        repoURL        = "http://forgejo.sandbox.local:3000/administrator/argocd-example-apps.git"
        targetRevision = "HEAD"
      }
      destination = {
        namespace = "default"
        server    = "https://kubernetes.default.svc"
      }
      syncPolicy = {
        automated = {
          allowEmpty = true
          enabled    = true
          prune      = true
          selfHeal   = true
        }
      }
    }
  }
}
