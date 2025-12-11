resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  depends_on = []
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.name
}

# optional: local kubeconfig file (comment if not desired)
resource "local_file" "kubeconfig" {
  content  = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = aws_eks_cluster.this.name
    endpoint     = aws_eks_cluster.this.endpoint
    cert         = aws_eks_cluster.this.certificate_authority[0].data
    token        = ""  # admin uses aws eks get-token; leave blank
  })
  filename = "${var.kubeconfig_path}/${var.cluster_name}_kubeconfig"
  lifecycle { create_before_destroy = true }
}
