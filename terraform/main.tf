provider "aws" {
region = var.aws_region
}


data "aws_caller_identity" "current" {}


data "aws_availability_zones" "available" {
state = "available"
}


module "vpc" {
source = "terraform-aws-modules/vpc/aws"
version = "~> 5.0"


name = "${var.project_name}-vpc"
cidr = "10.0.0.0/16"


azs = slice(data.aws_availability_zones.available.names, 0, 2)
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]


enable_nat_gateway = true
single_nat_gateway = true
map_public_ip_on_launch = true
}


module "eks" {
source = "terraform-aws-modules/eks/aws"
version = "~> 20.0"


cluster_name = var.project_name
cluster_version = var.cluster_version
cluster_endpoint_public_access = true


vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.private_subnets


enable_irsa = true


eks_managed_node_groups = {
default = {
desired_size = var.desired_size
min_size = var.min_size
max_size = var.max_size
instance_types = var.node_instance_types
capacity_type = "ON_DEMAND"
}
}


# Encrypt k8s secrets with a KMS key managed by the module
kms_key_enable_default_policy = true
kms_key_administrators = [data.aws_caller_identity.current.arn]
}


resource "aws_ecr_repository" "app" {
name = "${var.project_name}-app"
image_tag_mutability = "MUTABLE"
image_scanning_configuration { scan_on_push = true }
}