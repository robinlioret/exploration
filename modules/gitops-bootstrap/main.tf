resource "kubernetes_manifest" "kustimize_aoa" {
  manifest = yamldecode(file("${path.module}/manifests/kustomize.aoa.yaml"))
}

resource "kubernetes_manifest" "helm_aoa" {
  manifest = yamldecode(file("${path.module}/manifests/helm.aoa.yaml"))
}
