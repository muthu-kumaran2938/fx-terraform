output "alb_dns" {
  value = module.alb.alb_dns_name
}

output "alb_zone_id" {
  value = module.alb.alb_zone_id
}

output "acm_cert_arn" {
  value = module.acm.certificate_arn
}

output "rds_endpoints" {
  value = module.rds.endpoints
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_kubeconfig_file" {
  value = "${module.eks.kubeconfig_path}/${module.eks.cluster_name}_kubeconfig"
}
