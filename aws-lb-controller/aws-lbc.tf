data "aws_iam_openid_connect_provider" "this" {
  arn = var.openid_provider_arn
}

data "aws_iam_policy_document" "aws-lbc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_iam_openid_connect_provider.this.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
      type        = "Federated"
    }
  }
}

data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.body
}

resource "aws_iam_role" "aws-lbc" {
  count = var.enable_aws-lbc ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.aws-lbc.json
  name               = "${var.eks_name}-aws-lbc"
}

resource "aws_iam_policy" "aws-lbc" {
  count = var.enable_aws-lbc ? 1 : 0

  name = "${var.eks_name}-aws-lbc"
  path = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy      = data.http.lbc_iam_policy.body
}

resource "aws_iam_role_policy_attachment" "aws-lbc" {
  count = var.enable_aws-lbc ? 1 : 0

  role       = aws_iam_role.aws-lbc[0].name
  policy_arn = aws_iam_policy.aws-lbc[0].arn
}

resource "helm_release" "aws-lbc" {
  count = var.enable_aws-lbc ? 1 : 0

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.aws-lbc_helm_verion


  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws-lbc[0].arn
  }


  set {
    name  = "clusterName"
    value = var.eks_name
  }


}

