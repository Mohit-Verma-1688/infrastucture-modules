output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "openid_provider_arn" {
  value = aws_iam_openid_connect_provider.this[0].arn
}

output "eks_id" {
  value = aws_eks_cluster.this[0].id
}
