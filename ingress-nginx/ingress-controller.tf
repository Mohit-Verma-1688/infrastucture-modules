resource "helm_release" "ingress-nginx" {
  count = var.enable_ingress-controller ? 1 : 0

  name = "ingress-nginx"

  repository = "https://github.com/kubernetes/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = var.ingress-controller_helm_verion
  create_namespace = true
  timeout          = "1200"
  force_update	   = true

  values = [
    file("${path.module}/nginx-values.yaml")
  ]

#  set {
#    name  = "server.service.type"
#    value = "NodePort"
#  }

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
