# resource "aws_s3_bucket" "s3_bucket" {
#   for_each = toset(local.s3_buckets)
#   bucket   = each.key
#   force_destroy = true
# }
