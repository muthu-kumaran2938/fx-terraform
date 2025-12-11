resource "aws_secretsmanager_secret" "this" {
  name        = var.secret_name
  description = var.description

  tags = {
    Name = var.secret_name
    Env  = var.env
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_value
}
