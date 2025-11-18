resource "aws_iam_role" "eks_cluster" {
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.name}-k8s-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.k8s_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = aws_subnet.private_subnets[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}

resource "aws_iam_role" "nodes_eks" {
  name               = "role-node-group-eks"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_eks.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_eks.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_eks.name
}


resource "aws_eks_node_group" "nodes_eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.name}-k8s-node-group"
  node_role_arn   = aws_iam_role.nodes_eks.arn
  subnet_ids = aws_subnet.private_subnets[*].id
  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type       = "AL2023_x86_64_STANDARD"
  capacity_type  = "SPOT"
  disk_size      = 20
  instance_types = var.instance_types  # Multiple types for better spot availability
  labels = {
    role = "nodes-group-1"
  }

  tags = {
    Name        = "${var.name}-k8s-node"
    Environment = "sandbox"
    Project     = "rch-preludetx"
  }

  version = var.k8s_version

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_eks,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_eks,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}
