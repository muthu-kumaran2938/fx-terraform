# Gateway endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = var.public_route_table_ids
  depends_on = []
}

# Interface endpoints
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids
  security_group_ids = var.endpoint_sg_ids
  private_dns_enabled = true
}


# Secrets: For RDS passwords and any sensitive variables, create secrets with modules/secrets and pass the secret values (or secret ARNs) into modules/rds. I put placeholder passwords in env/dev/main.tf — replace them with data.aws_secretsmanager_secret_version lookups or reference module.secrets.secret_id values.

# Route53 / ACM: The ACM DNS validation will create records in the private hosted zone — that's supported and works for internal domains.

# ALB listeners & target groups: I created a simple HTTP listener and TG. You might want HTTPS listener with ACM cert attached — to do that, change aws_lb_listener protocol to HTTPS and add certificate_arn = var.certificate_arn and pass module.acm.certificate_arn into the ALB module.

# EKS nodes: I created control plane only. When you’re ready to add nodegroups (managed or self-managed), create separate modules/eks-nodegroup that uses module.iam.eks_node_role_arn and module.iam.eks_node_instance_profile.

# Route tables: The vpc-endpoints module used public_route_table_ids — ensure you have route table resources or change to appropriate route table IDs.

# Adjust region & naming: Replace ap-south-1 and names with your target region and naming scheme.