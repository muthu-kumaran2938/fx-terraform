module "vpc" {
  source = "../../modules/vpc"

  env             = "dev"
  vpc_cidr        = "10.0.0.0/16"

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}
module "sg" {
  source = "../../modules/security-group"

  env      = "dev"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
}


module "ec2_key_secret" {
  source = "../../modules/secrets"

  env          = "dev"
  secret_name  = "red-ec2"
  secret_value = "red-ec2"    # the actual keypair name
}

module "ec2_public_1" {
  source = "../../modules/ec2"
  env    = "dev"
  name   = "pub-1"

  subnet_id           = module.vpc.public_subnets[0]
  sg_id               = module.sg.public_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile

  key_secret_name      = module.ec2_key_secret.secret_id
}
module "ec2_public_2" {
  source = "../../modules/ec2"
  env    = "dev"
  name   = "pub-2"

  subnet_id           = module.vpc.public_subnets[1]
  sg_id               = module.sg.public_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile
  key_secret_name      = module.ec2_key_secret.secret_id
}
module "ec2_private_1" {
  source = "../../modules/ec2"
  env    = "dev"
  name   = "pri-1"

  subnet_id           = module.vpc.private_subnets[0]
  sg_id               = module.sg.private_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile
  key_secret_name      = module.ec2_key_secret.secret_id
}
module "ec2_private_2" {
  source = "../../modules/ec2"
  env    = "dev"
  name   = "pri-2"

  subnet_id           = module.vpc.private_subnets[1]
  sg_id               = module.sg.private_sg_id
  iam_instance_profile = module.iam.ec2_instance_profile
  key_secret_name      = module.ec2_key_secret.secret_id
}


# --------------------------
# 2 Public EC2
# --------------------------

module "iam" {
  source = "../../modules/iam"

  env         = "dev"
  prefix      = "fdx"
  tags = {
    Project = "fedex"
    Env     = "dev"
  }
  # Optionally provide specific secret ARNs you want nodes to read
  secrets_arns = [module.ec2_key_secret.secret_arn]  # if you want to restrict
}
##########2938################
# S3 bucket(s)
module "s3" {
  source = "../../modules/s3"
  buckets = {
    logs = { name = "fdx-dev-alb-logs" }
    artifacts = { name = "fdx-dev-artifacts" }
  }
  default_tags = { Project = "fedex", Env = "dev" }
}

# S3 Access Points (map keys refer to keys in s3.buckets)
module "s3_ap" {
  source = "../../modules/s3-accesspoint"
  vpc_id = module.vpc.vpc_id
  bucket_map = {
    logs = module.s3.buckets["logs"]
    artifacts = module.s3.buckets["artifacts"]
  }
  access_points = {
    alb_logs = { bucket_key = "logs" }
    apps     = { bucket_key = "artifacts" }
  }
  default_tags = { Project = "fedex", Env = "dev" }
}

# ECR (12 microservices)
module "ecr" {
  source = "../../modules/ecr"
  services = [
    "service1","service2","service3","service4","service5","service6",
    "service7","service8","service9","service10","service11","service12"
  ]
  tags = { Project = "fedex", Env = "dev" }
}

# RDS - example map; pass passwords from secrets manager or module.secrets outputs


module "rds_svc1_secret" {
  source = "../../modules/secrets"
  env = "dev"
  secret_name = "svc1-db-creds"
  # store JSON string with username/password
  secret_value = jsonencode({
    username = "svc1admin"
    password = "ChangeThisToSomethingSecure!"
  })
}

module "rds_svc2_secret" {
  source = "../../modules/secrets"
  env = "dev"
  secret_name = "svc2-db-creds"
  secret_value = jsonencode({
    username = "svc2admin"
    password = "ChangeThisToo!"
  })
}
module "rds" {
  source = "../../modules/rds"
  env = "dev"
  private_subnet_ids = module.vpc.private_subnets
  db_security_group_ids = [module.sg.private_sg_id]
  databases = {
    svc1 = { db_name = "svc1db", secret_arn = module.rds_svc1_secret.secret_arn }
    svc2 = { db_name = "svc2db", secret_arn = module.rds_svc2_secret.secret_arn }
  }
  tags = { Project = "fedex", Env = "dev" }
}



# Route53 private hosted zone
module "route53" {
  source = "../../modules/r53"
  zone_name = "internal.fdx.local"
  vpc_id = module.vpc.vpc_id
  tags = { Project = "fedex", Env = "dev" }
}
resource "aws_route53_record" "api_alias" {
  zone_id = module.route53.zone_id
  name    = "api.internal.fdx.local"   # adjust to the hostname you want
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}


# ACM certificate for internal domain (validated in private zone)
module "acm" {
  source = "../../modules/acm"
  domain_name = "api.internal.fdx.local"
  sans = []
  route53_zone_id = module.route53.zone_id
  tags = { Project = "fedex", Env = "dev" }
}
# Ensure ALB gets the certificate ARN from ACM
module "alb" {
  source = "../../modules/internal-alb"
  name = "fdx-internal"
  subnets = module.vpc.public_subnets
  security_groups = [module.sg.public_sg_id]
  vpc_id = module.vpc.vpc_id
  target_port = 8080
  certificate_arn = module.acm.certificate_arn   # TLS cert from ACM
  enable_http = false                             # optional: force HTTPS only
  tags = { Project = "fedex", Env = "dev" }
}

# Route53 alias record to ALB (private)


# Internal ALB


# VPC Endpoints (use private subnets and an endpoint security group)
resource "aws_security_group" "endpoint_sg" {
  name = "endpoint-sg-dev"
  vpc_id = module.vpc.vpc_id
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [module.vpc.vpc_cidr]
}

}
module "vpc_endpoints" {
  source = "../../modules/vpc-endpoint"
  vpc_id = module.vpc.vpc_id
  region = "ap-south-1"
  subnet_ids = module.vpc.private_subnets
  public_route_table_ids = [aws_route_table.public.id] # if you create route tables; else pass []
  endpoint_sg_ids = [aws_security_group.endpoint_sg.id]
}

# EKS control plane only
module "eks" {
  source = "../../modules/eks"
  cluster_name = "fdx-dev-eks"
  cluster_role_arn = module.iam.eks_cluster_role_arn
  private_subnet_ids = module.vpc.private_subnets
  endpoint_private_access = true
  endpoint_public_access = false
  kubeconfig_path = "/tmp"
}
# EKS managed node groups
module "eks_nodegroups" {
  source = "../../modules/node-group"

  cluster_name = module.eks.cluster_name
  node_role_arn = module.iam.eks_node_role_arn   # from iam module
  subnet_ids = module.vpc.private_subnets

  node_groups = {
    managed-default = {
      desired_size  = 2
      min_size      = 1
      max_size      = 3
      instance_types= ["t3.medium"]
      # If you want SSH access to nodes (not recommended), provide key name:
      ec2_ssh_key = module.ec2_key_secret.secret_string == "" ? null : jsondecode(data.aws_secretsmanager_secret_version.keypair.secret_string) # OPTIONAL
    }
  }
  tags = { Project = "fedex", Env = "dev" }
}


# ACM + Route53: ACM DNS validation will create records in the private zone; ensure the zone is present and the ALLOW_RECORD_CREATION permissions exist for the Terraform principal.

# Secrets format: RDS secrets must be JSON { "username": "...", "password": "..." }. The secrets module earlier uses secret_value which we set with jsonencode(...).

# EKS node group & IAM: Use module.iam.eks_node_role_arn for node_role_arn. Confirm AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly, and AmazonSSMManagedInstanceCore are attached (the provided modules/iam attaches these).

# VPC endpoints: Ensure you created endpoint SG that allows 443 to/from the VPC; you already created aws_security_group.endpoint_sg in example.

# Terraform provider & versions: Keep provider versions compatible (hashicorp/aws ~> 5.x recommended).

# Replace placeholders: Update domain api.internal.fdx.local, secret names, passwords, tags and region to match your environment.