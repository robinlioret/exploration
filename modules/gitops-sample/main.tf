resource "kubernetes_manifest" "kustimize_aoa" {
  manifest = yamldecode(file("${path.module}/manifests/kustomize.aoa.yaml"))
}
