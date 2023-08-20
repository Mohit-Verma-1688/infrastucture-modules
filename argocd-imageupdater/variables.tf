variable "env" {
  description = "Environment name."
  type        = string
}

variable "secret-name" {
  description = "Private Docker Registry Access Toekn"
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_argocd-imageup" {
  description = "Determines whether to deploy argocd-imageup application"
  type        = bool
  default     = false
}

variable "argocd-imageup_helm_verion" {
  description = "Argo CD  Helm verion"
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}

variable "aws_ssm_key_name" {
  description = "Name of the aws ssm key parameter already created to store git repo key."
  type        = string
}

variable "private_git_repo" {
  description = "Name of the private git repo."
  type        = string
}
