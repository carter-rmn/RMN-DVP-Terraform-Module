# output "cluster_endpoint" {
#   value = var.eks.create ? aws_eks_cluster.main[0].endpoint : null
# }

# output "cluster_certificate_authority_data" {
#   value = var.eks.create ? aws_eks_cluster.main[0].certificate_authority[0].data : null
# }

# output "cluster_name" {
#   value = var.eks.create ? aws_eks_cluster.main[0].name : null
# }

# output "eks" {
#   value = var.eks.create ? aws_eks_cluster.main[0] : null
# }