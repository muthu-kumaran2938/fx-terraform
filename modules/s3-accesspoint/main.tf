resource "aws_s3_access_point" "this" {
  for_each = var.access_points

  bucket = lookup(var.bucket_map, each.value.bucket_key)
  name   = each.key

  vpc_configuration {
    vpc_id = var.vpc_id
  }

}
