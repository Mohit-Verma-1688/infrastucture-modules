resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name = "argocd-eks"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.argocd_helm_verion
  create_namespace = true
  timeout          = "1200"
