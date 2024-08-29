module "vpc" {
  source = "../vpc"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"

  cluster_name    = "wordpress"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  vpc_id = module.vpc.outputs.vpc_id

  node_groups = {
    demo = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.medium"
    }
  }

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
}