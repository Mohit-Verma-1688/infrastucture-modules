data "aws_eks_cluster" "eks" {
    name = var.eks_name

}

resource "kubectl_manifest" "Issuer" {
yaml_body = <<-EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-dns01-$(var.env)
  namespace: argocd
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: mohit_verma1688@gmail.com
    privateKeySecretRef:
      name: letsencrypt-$(var.env)-dns01-key-pair
    solvers:
    - dns01:
        route53:
          region: us-east-1
EOF

}


resource "kubectl_manifest" "ingress_argocd" {
yaml_body = <<-EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
    annotations:
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      cert-manager.io/issuer: letsencrypt-dns01-$(var.env)
      nginx.ingress.kubernetes.io/ssl-passthrough: 'true'
    name: argocd
    namespace: argocd
spec:
    rules:
    - host: $(var.env)-argocd.themulticlouding.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: $(var.env)-argocd-server
              port:
                name: https
    ingressClassName: "external-nginx"
    tls:
    - hosts:
      - $(var.env)-argocd.themulticlouding.com
      secretName: argocd-secret
EOF
}
