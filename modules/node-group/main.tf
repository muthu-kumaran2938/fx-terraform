resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = lookup(each.value, "desired_size", 2)
    max_size     = lookup(each.value, "max_size", 3)
    min_size     = lookup(each.value, "min_size", 1)
  }

  instance_types = lookup(each.value, "instance_types", ["t3.medium"])

  remote_access {
    # optional: use EC2 keypair name; if you want SSM-only, set this block to null/leave out
    ec2_ssh_key = lookup(each.value, "ec2_ssh_key", null)
  }

  ami_type = lookup(each.value, "ami_type", "AL2_x86_64")

  tags = merge(var.tags, { Name = each.key })
  depends_on = [aws_eks_node_group.this] # ensures ordering if multiple
}
