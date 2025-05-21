resource "kubernetes_manifest" "kustimize_aoa" {
  manifest = yamldecode(templatefile("${path.module}/manifests/kustomize.aoa.yaml", { git_repo = var.git_repo }))
}

resource "kubernetes_manifest" "helm_aoa" {
  manifest = yamldecode(templatefile("${path.module}/manifests/helm.aoa.yaml", { git_repo = var.git_repo }))
}
