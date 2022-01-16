###########----------- output kubeconfig -----------###########

locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: module.eks.eks-endpoint
    certificate-authority-data: module.eks.eks-cluster-ca
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "eks-var.project-var.environment"
KUBECONFIG
}

output "kubeconfig" {
  sensitive = true
  value = local.kubeconfig
}



###########----------- Outputs needed for nodes -----------###########


output "eks-endpoint" {
  value = module.eks.eks-endpoint
}

output "eks-cluster-ca" {
  value = module.eks.eks-cluster-ca
}

output "eks-name" {
  value = module.eks.eks-name
}


#### iam

###########----------- Output yml file to apply to cluster -----------###########

locals {
  config-map-aws-auth = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: module.iam.node-iam-role-arn
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config-map-aws-auth" {
  sensitive = true
  value = local.config-map-aws-auth
}


output "cluster-iam-role-arn" {
  value = module.iam.cluster-iam-role-arn
}

output "node-iam-instance-profile" {
  value = module.iam.node-iam-instance-profile
}

output "node-iam-role-arn" {
  value = module.iam.node-iam-role-arn
}


#### sg

output "node-security-groups" {
  value = module.sg.node-security-groups
}

output "cluster-security-groups" {
  value = module.sg.cluster-security-groups
}