output "endpoints" {
  value = { for k, db in aws_db_instance.this : k => db.endpoint }
}

output "addresses" {
  value = { for k, db in aws_db_instance.this : k => db.address }
}
