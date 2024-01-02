// The example below comes from https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/complete/main.tf

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  enable_irsa                          = var.enable_irsa

  cluster_addons = var.cluster_addons

  # Extend cluster security group rules
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  # Extend node-to-node security group rules
  node_security_group_additional_rules = var.node_security_group_additional_rules

  # Self Managed Node Group(s)
  self_managed_node_group_defaults = var.self_managed_node_group_defaults
  self_managed_node_groups         = var.self_managed_node_groups

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = var.eks_managed_node_group_defaults
  eks_managed_node_groups         = var.eks_managed_node_groups

  # Fargate Profile(s)
  fargate_profiles = var.fargate_profiles

  # Create a new cluster where both an identity provider and Fargate profile is created
  # will result in conflicts since only one can take place at a time
  # OIDC Identity provider
  cluster_identity_providers = var.cluster_identity_providers

  # aws-auth configmap
  manage_aws_auth_configmap                        = var.manage_aws_auth_configmap
  aws_auth_node_iam_role_arns_non_windows          = var.aws_auth_node_iam_role_arns_non_windows
  aws_auth_fargate_profile_pod_execution_role_arns = var.aws_auth_fargate_profile_pod_execution_role_arns
  aws_auth_roles                                   = concat(var.aws_auth_roles, [
    # We need to add in the Karpenter node IAM role for nodes launched by Karpenter
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    },
  ])
  aws_auth_users                                   = var.aws_auth_users
  aws_auth_accounts                                = var.aws_auth_accounts

  tags = var.tags
}
