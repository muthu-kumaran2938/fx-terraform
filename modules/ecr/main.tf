resource "aws_ecr_repository" "repos" {
  for_each = toset(var.services)

  name = each.key

  image_scanning_configuration { scan_on_push = true }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = var.tags
}
