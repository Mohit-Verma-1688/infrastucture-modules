
resource "helm_release" "argocd-imageup" {
  count = var.enable_argocd-imageup ? 1 : 0

  name = "${var.env}-argocd-imageup"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  namespace  = "argocd"
  version    = var.argocd-imageup_helm_verion
  create_namespace = true
  timeout          = "1200"
  force_update	   = true
  
  values = [file("values/image-updater.yaml")] 

#  set {
#    name  = "server.service.annotations[0]"
#    value = "service.beta.kubernetes.io/aws-load-balancer-type: external"
#  }
#  set {
#    name  = "server.service.annotations[1]"
#    value = "service.beta.kubernetes.io/aws-load-balancer.scheme: internet-facing"
#  }
#  set {
#    name  = "server.service.annotations[2]"
#    value = "service.beta.kubernetes.io/aws-load-balancer-type: nlb"
#  }

}

