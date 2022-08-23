variable "network_contracts" {
  type = list(any)
}

locals {
  nlb_instances = flatten(
    [for contract_name, contract_properties in var.network_contracts : lookup(contract_properties, "nlb_instances") if can(contract_properties.nlb_instances)]
  )
}

output "nlb_instances" {
  value = local.nlb_instances
}
