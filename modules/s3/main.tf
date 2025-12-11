resource "aws_s3_bucket" "this" {
  for_each = var.buckets

  bucket = each.value.name
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = lookup(each.value, "versioning", false)
  }

  tags = merge(var.default_tags, { Name = each.value.name })
}
