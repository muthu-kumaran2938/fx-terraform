output "access_points" {
  value = { for k, ap in aws_s3_access_point.this : k => ap.arn }
}
