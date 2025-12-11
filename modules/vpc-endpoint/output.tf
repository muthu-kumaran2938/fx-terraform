output "endpoints" {
  value = {
    s3          = aws_vpc_endpoint.s3.id
    ecr_api     = aws_vpc_endpoint.ecr_api.id
    ecr_dkr     = aws_vpc_endpoint.ecr_dkr.id
    secrets_mgr = aws_vpc_endpoint.secretsmanager.id
    ssm         = aws_vpc_endpoint.ssm.id
    ssmmessages = aws_vpc_endpoint.ssm_messages.id
    logs        = aws_vpc_endpoint.logs.id
  }
}
