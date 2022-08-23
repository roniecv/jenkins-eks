terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

 backend "s3" {
    bucket = "demo-state-ecv"
    key    = "state/demo-state-ecv"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region     = "ap-southeast-1"
}



locals {
  contracts = {
    for contract_file in fileset(path.module, "contracts/*.yml") :
    contract_file => yamldecode(file(contract_file))
  }

  #network_contracts  = flatten([for contract_name, contract_properties in local.contracts : contract_properties.network if can(contract_properties.network)])
  storage_contracts  = flatten([for contract_name, contract_properties in local.contracts : contract_properties.storage if can(contract_properties.storage)])
  #compute_contracts  = flatten([for contract_name, contract_properties in local.contracts : contract_properties.compute if can(contract_properties.compute)])
  #database_contracts = flatten([for contract_name, contract_properties in local.contracts : contract_properties.database if can(contract_properties.database)])
  #account_contracts  = flatten([for contract_name, contract_properties in local.contracts : contract_properties.account if can(contract_properties.account)])  
}

#module "network" {
#  source            = "./templates/network"
#   network_contracts = local.network_contracts
# }

# module "policies" {
#   source = "./templates/policies"

#   vpc_id                           = module.network.vpc_id
#   private_subnets_cidr_blocks      = module.network.private_subnets_cidr_blocks
#   private_subnets_ipv6_cidr_blocks = module.network.private_subnets_ipv6_cidr_blocks
# }

module "storage" {
  source            = "./templates/storage"
  storage_contracts = local.storage_contracts
}

# module "compute" {
#   source = "./templates/compute"

#   vpc_id          = module.network.vpc_id
#   private_subnets = module.network.private_subnets

#   compute_contracts = local.compute_contracts
# }

# module "database" {
#   source = "./templates/database"

#   db_subnet_group_name = module.network.db_subnet_group_name

#   database_contracts = local.database_contracts
# }
