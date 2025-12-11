######################
# EKS Cluster Role
######################
data "aws_iam_policy_document" "eks_cluster_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.prefix}-eks-cluster-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

######################
# EKS Node Role (for managed/self-managed nodes)
######################
data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_node_role" {
  name               = "${var.prefix}-eks-node-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json
  tags = var.tags
}

# Attach AWS managed policies required by EKS worker nodes
resource "aws_iam_role_policy_attachment" "eks_worker_NodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_CNI" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_ECRRead" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_worker_SSM" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile used by node groups (or EC2 if you want)
resource "aws_iam_instance_profile" "eks_node_profile" {
  name = "${var.prefix}-eks-node-ip-${var.env}"
  role = aws_iam_role.eks_node_role.name
}

######################
# Generic EC2 Instance Role (for your EC2 modules)
# includes SSM, SecretsManagerRead, optional ECR read
######################
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.prefix}-ec2-role-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ec2_SSM" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_ECRRead" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Custom inline policy for SecretsManager read-only (limit by resource if you want)
data "aws_iam_policy_document" "secrets_read" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = var.secrets_arns == [] ? ["*"] : var.secrets_arns
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "secrets_read_policy" {
  name        = "${var.prefix}-secrets-read-${var.env}"
  description = "Allow read of specified secrets for EC2/EKS nodes"
  policy      = data.aws_iam_policy_document.secrets_read.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "ec2_secrets_read_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.prefix}-ec2-ip-${var.env}"
  role = aws_iam_role.ec2_role.name
}

######################
# Optional: ECR push policy for CI user (if you want)
# Not attached to nodes by default
######################
data "aws_iam_policy_document" "ecr_push" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "ecr_push_policy" {
  name        = "${var.prefix}-ecr-push-${var.env}"
  policy      = data.aws_iam_policy_document.ecr_push.json
  description = "Allow pushing/pulling to ECR (CI service)"
  tags        = var.tags
}
