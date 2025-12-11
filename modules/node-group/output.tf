output "node_groups" {
  value = { for k, ng in aws_eks_node_group.this : k => ng.node_group_name }
}
