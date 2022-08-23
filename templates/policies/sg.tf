variable "vpc_id" {
  type = string
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
}

variable "private_subnets_ipv6_cidr_blocks" {
  type = list(string)
}

resource "aws_security_group" "allow_postgres_from_priv_subnets" {
  name        = "allow_postgres_from_priv_subnets"
  description = "Allow postgres db inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "postgres from private subnets"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = var.private_subnets_cidr_blocks
    ipv6_cidr_blocks = var.private_subnets_ipv6_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_postgres_from_priv_subnets"
  }
}
