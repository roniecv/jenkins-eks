variable "database_contracts" {
  type = list(any)
}

locals {
  db_instances = flatten(
    [for contract_name, contract_properties in var.database_contracts : lookup(contract_properties, "db_instances") if can(contract_properties.db_instances)]
  )
}
