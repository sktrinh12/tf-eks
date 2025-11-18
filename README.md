# Terraform EKS Sandbox

This repo contains Terraform code to provision a **sandbox EKS (Kubernetes) cluster on AWS**.  
It sets up the network (VPC + subnets), IAM roles, the EKS control plane, and a managed node group.

## What it creates

- A VPC with public and private subnets
- Internet Gateway, NAT Gateway, and route tables
- An EKS cluster: `${var.name}-k8s-cluster`
- A managed node group using Spot instances (Amazon Linux 2023)
- Tags and subnet annotations so `LoadBalancer` Services work correctly

## Prerequisites

- Terraform installed
- AWS CLI configured with a profile
- An existing EC2 key pair (used by `var.ec2_ssh_key`)
- Permissions to create VPC, EKS, EC2, IAM, and networking resources

## How to use

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Optional override defaults**

    ```bash
    region      = "us-east-1"
    aws_profile = "rchsandbox"
    name        = "preludetx-sandbox"
    ec2_ssh_key = "your-keypair-name"
    ```

3. **Review and plan**

    ```bash
    terraform plan
    ```

4. **Apply**

    ```bash
    terraform apply --auto-approve
    ```

5. **Configure `kubectl`**

    ```bash
    aws eks update-kubeconfig \
      --name preludetx-sandbox-k8s-cluster \
      --region us-east-1 \
      --profile rchsandbox

    kubectl get nodes
    ```

6. **Destroy resources**

    ```bash
    terraform destroy --auto-approve
    ```
