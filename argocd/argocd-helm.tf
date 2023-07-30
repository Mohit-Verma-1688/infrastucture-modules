resource "helm_release" "argocd" {
  count = var.enable_argocd ? 1 : 0

  name = "${var.env}-argocd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = var.argocd_helm_verion
  create_namespace = true
  timeout          = "1200"
  force_update	   = true

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

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

data "aws_ssm_parameter" "ssh_private_key" {
  name = var.aws_ssm_key_name
}

resource "kubernetes_secret" "ssh_key" {
  metadata {
    name      = private-repo
    namespace = "argocd" 
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "sshPrivateKey" = data.aws_ssm_parameter.ssh_private_key.value
    "type"          = "git"
    "url"           = "$(var.private_git_repo)"
    "name"          = "applications"
    "project"       = "*"
  }
}
