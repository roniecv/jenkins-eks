# variable "storage_contracts" {
#   type = list(any)
# }
variable "storage_contracts" {
  type = list(any)
}

locals {
#   s3_buckets = flatten(
#     [for contract_name, contract_properties in var.storage_contracts : lookup(contract_properties, "s3_buckets") if can(contract_properties.s3_buckets)]
#   )
# }
    ecr = flatten(
    [for contract_name, contract_properties in var.storage_contracts : lookup(contract_properties, "ecr") if can(contract_properties.ecr)]
  )
}

# output "s3_buckets" {
#   value = local.s3_buckets
# }
output "ecr" {
  value = local.ecr
}
