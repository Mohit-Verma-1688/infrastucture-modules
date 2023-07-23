resource "kubectl_manifest" "Issuer" {
 manifest = {
  "apiVersion" = "cert-manager.io/v1"
  "kind" = "Issuer"
  "metadata" = {
    "name" = "letsencrypt-dns01-$(var.env)"
    "namespace" = "argocd"
  }
  "spec" = {
    "acme" = {
      "email" = "mohit_verma1688@gmail.com"
      "privateKeySecretRef" = {
        "name" = "letsencrypt-$(var.env)-dns01-key-pair"
      }
      "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
      "solvers" = [
        {
          "dns01" = {
            "route53" = {
              "hostedZoneID" = "Z100992510LUGZYBTY35U"
              "region" = "us-east-1"
            }
          }
        },
      ]
    }
  }
}
 }


resource "kubectl_manifest" "ingress_argocd" {
 manifest = {
  "apiVersion" = "networking.k8s.io/v1"
  "kind" = "Ingress"
  "metadata" = {
    "annotations" = {
      "cert-manager.io/issuer" = "letsencrypt-dns01-$(var.env)"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      "nginx.ingress.kubernetes.io/ssl-passthrough" = "true"
    }
    "name" = "argocd"
    "namespace" = "argocd"
  }
  "spec" = {
    "ingressClassName" = "external-nginx"
    "rules" = [
      {
        "host" = "$(var.env)-argocd.themulticlouding.com"
        "http" = {
          "paths" = [
            {
              "backend" = {
                "service" = {
                  "name" = "$(var.env)-argocd-server"
                  "port" = {
                    "name" = "https"
                  }
                }
              }
              "path" = "/"
              "pathType" = "Prefix"
            },
          ]
        }
      },
    ]
    "tls" = [
      {
        "hosts" = [
          "$(var.env)-argocd.themulticlouding.com",
        ]
        "secretName" = "argocd-secret"
      },
    ]
  }
}


}
