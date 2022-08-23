resource "aws_lb" "nlb" {
  for_each = merge(local.nlb_instances...)

  name               = each.key
  internal           = each.value.internal
  load_balancer_type = "network"

  subnets = flatten([module.vpc.public_subnets])
}

resource "aws_lb_target_group" "http-tg" {
  for_each = merge(local.nlb_instances...)

  name     = "${each.key}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}
