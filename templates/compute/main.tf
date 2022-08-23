variable "compute_contracts" {
  type = list(any)
}

locals {
  ec2_instances = flatten(
    [for contract_name, contract_properties in var.compute_contracts : lookup(contract_properties, "ec2_instances") if can(contract_properties.ec2_instances)]
  )

  eks_clusters = flatten(
    [for contract_name, contract_properties in var.compute_contracts : lookup(contract_properties, "eks_clusters") if can(contract_properties.eks_clusters)]
  )

  eks_clusters_properties = {
    for cluster_name, cluster_properties in module.eks : cluster_name => cluster_properties
  }
}
