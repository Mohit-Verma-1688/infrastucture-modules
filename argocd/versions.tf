terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
   }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"

   }
   
  }
}
