module "vpc" {
  source = "../../modules/vpc"
}
module "eks" {
  source = "../../modules/eks"
}
module "ecr" {
  source   = "../../modules/ecr"
  services = ["service1", "service2", "service3", "service12"]
}
module "rds" {
  source = "../../modules/rds"
}
module "alb" {
  source = "../../modules/alb-internal"
}
module "route53" {
  source = "../../modules/route53"
}
module "s3" {
  source = "../../modules/s3"
}
module "endpoints" {
  source = "../../modules/vpc-endpoints"
}
module "secrets" {
  source = "../../modules/secrets-manager"
}
