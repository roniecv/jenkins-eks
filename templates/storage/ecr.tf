resource "aws_ecr_repository" "ecr-dev" {
  for_each = toset(local.ecr)
  name = "ifg-test"
  tags = {
    Environment = "dev"
  }
}
