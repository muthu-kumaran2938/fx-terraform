output "alb_arn" { value = aws_lb.internal.arn }
output "alb_dns_name" { value = aws_lb.internal.dns_name }
output "alb_zone_id" { value = aws_lb.internal.zone_id }
output "target_group_arn" { value = aws_lb_target_group.http.arn }
