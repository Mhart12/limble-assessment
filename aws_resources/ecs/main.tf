module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "wordpress-demo"
  cluster_version = "1.27"

  node_groups = {
    demo = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.medium"
    }
  }
}