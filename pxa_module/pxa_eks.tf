resource "aws_eks_cluster" "eks" {
  name                      = "${local.pxa_prefix}-eks"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  role_arn                  = aws_iam_role.role_eks.arn
  version                   = "1.29"

  vpc_config {
    endpoint_public_access = true
    subnet_ids             = local.vpc.subnets.private
  }

  tags = {
    Name        = "${local.pxa_prefix}-eks"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${local.pxa_prefix}-eks-node-group"
  node_role_arn   = aws_iam_role.role_eks_node.arn
  subnet_ids      = local.vpc.subnets.private

  scaling_config {
    desired_size = local.pxa_config.eks_node_group.desired_size
    max_size     = local.pxa_config.eks_node_group.max_size
    min_size     = local.pxa_config.eks_node_group.min_size
  }

  instance_types = [local.pxa_config.eks_node_group.instance_type]  

  tags = {
    Name        = "${local.pxa_prefix}-eks-node-group"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = "true"
  }
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity.0.oidc.0.issuer
}
