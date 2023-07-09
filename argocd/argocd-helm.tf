resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name = "argocd-eks"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.argocd_helm_verion
  create_namespace = true
  timeout          = "1200"
  force_update	   = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.annotations[0]"
    value = "service.beta.kubernetes.io/aws-load-balancer-type: external"
 
  }
  set {
    name  = "server.service.annotations[1]"
    value = "service.beta.kubernetes.io/aws-load-balancer.scheme: internet-facing"

  }


}
