variable "db_subnet_group_name" {
  type = string
}

resource "aws_db_instance" "db_postgres" {
  for_each = merge(local.db_instances...)

  identifier = each.key

  allocated_storage = each.value.db_storage_size
  storage_type      = each.value.db_storage_type

  multi_az             = each.value.db_multi_az
  db_subnet_group_name = var.db_subnet_group_name

  engine               = each.value.db_engine_type
  engine_version       = each.value.db_engine_version
  instance_class       = each.value.db_instance_class
  parameter_group_name = each.value.db_parameter_group

  db_name  = each.value.db_name
  password = "foobarbaz"
  username = each.value.db_name

  skip_final_snapshot = true
}
