resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = merge(var.tags, { Name = "${var.env}-rds-subnet-group" })
}

# For each DB, read credentials from Secrets Manager if secret_arn is provided
data "aws_secretsmanager_secret_version" "db_secrets" {
  for_each = {
    for k, v in var.databases : k => v
    if contains(keys(v), "secret_arn") && v.secret_arn != ""
  }
  secret_id = each.value.secret_arn
}

resource "aws_db_instance" "this" {
  for_each = var.databases

  identifier         = "${var.env}-${each.key}"
  engine             = lookup(each.value, "engine", "postgres")
  engine_version     = lookup(each.value, "engine_version", var.default_engine_version)
  instance_class     = lookup(each.value, "instance_class", "db.t3.micro")
  allocated_storage  = lookup(each.value, "storage", 20)
  name               = lookup(each.value, "db_name", each.key)

  # username & password: prefer secret if provided, else use username/password fields
  username = lookup(each.value, "username",
    (
      contains(keys(each.value),"secret_arn") && each.value.secret_arn != "" ?
        jsondecode(data.aws_secretsmanager_secret_version.db_secrets[each.key].secret_string).username :
        "admin"
    )
  )

  password = lookup(each.value, "password",
    (
      contains(keys(each.value),"secret_arn") && each.value.secret_arn != "" ?
        jsondecode(data.aws_secretsmanager_secret_version.db_secrets[each.key].secret_string).password :
        ""
    )
  )

  vpc_security_group_ids = var.db_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  multi_az              = lookup(each.value, "multi_az", false)
  skip_final_snapshot   = lookup(each.value, "skip_final_snapshot", true)
  publicly_accessible   = false
  deletion_protection   = lookup(each.value, "deletion_protection", false)
  tags = merge(var.tags, { Service = each.key })
}
