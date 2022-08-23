variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(any)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  for_each = merge(local.eks_clusters...)

  cluster_name    = each.key
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    instance_type                          = each.value.instance_type
    update_launch_template_default_version = true
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
  }

  eks_managed_node_groups = {
    workload = {
      name         = "ng-1"
      min_size     = each.value.min_size
      max_size     = each.value.max_size
      desired_size = each.value.desired_size

      instance_types = [each.value.instance_type]
    }
  }
}
