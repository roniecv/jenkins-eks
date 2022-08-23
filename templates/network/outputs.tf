output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  value = module.vpc.private_subnets_ipv6_cidr_blocks
}

output "db_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}
