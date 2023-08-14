
resource "helm_release" "kube-prometheus-stack" {
  count = var.enable_kube-prometheus-stack ? 1 : 0

  name = "${var.env}-kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = "monitoring"
  version    = var.kube-prometheus-stack_helm_version
  create_namespace = true
  timeout          = "1200"
  force_update	   = true

  values = [
    file("${path.module}/kube-prometheus-stack.yaml")
  ]

}

#data "aws_ssm_parameter" "ssh_private_key" {
#  name = var.aws_ssm_key_name
#}

