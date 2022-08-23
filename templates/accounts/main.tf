variable "account_contracts" {
  type = list(any)
}

locals {
  organization = flatten(
    [for contract_name, contract_properties in var.account_contracts : lookup(contract_properties, "organization") if can(contract_properties.organization)]
  )
  accounts = flatten(
    [for contract_name, contract_properties in var.account_contracts : lookup(contract_properties, "accounts") if can(contract_properties.accounts)]
  )
  ssoassignment = flatten(
    [for contract_name, contract_properties in var.account_contracts : lookup(contract_properties, "ssoassignment") if can(contract_properties.ssoassignment)]
  )
}
output "accounts" {
   value = local.accounts
}

output "organization"{
  value = local.organization
}

output "ssoassignment"{
  value = local.ssoassignment
}
