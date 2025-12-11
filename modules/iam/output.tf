output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "eks_node_instance_profile" {
  value = aws_iam_instance_profile.eks_node_profile.name
}

output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "secrets_read_policy_arn" {
  value = aws_iam_policy.secrets_read_policy.arn
}

output "ecr_push_policy_arn" {
  value = aws_iam_policy.ecr_push_policy.arn
}
