resource "aws_instance" "ec2" {
  for_each = merge(local.ec2_instances...)

  ami           = each.value.ami
  instance_type = each.value.instance_type
}
