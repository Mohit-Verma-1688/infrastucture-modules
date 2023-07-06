variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "enable_argocd" {
  description = "Determines whether to deploy argocd application"
  type        = bool
  default     = false
}

variable "argocd_helm_verion" {
  description = "Argo CD  Helm verion"
  type        = string
}

variable "openid_provider_arn" {
  description = "IAM Openid Connect Provider ARN"
  type        = string
}
