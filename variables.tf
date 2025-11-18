variable "region" {
  type    = string
  default = "us-east-1"
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "aws_profile" {
  type    = string
  default = "rchsandbox"
}

variable "name" {
  type    = string
  default = "preludetx-sandbox"
}

variable "k8s_version" {
  type    = string
  default = "1.34"
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for node group"
  default     = ["t3.small", "t3a.small", "t2.small"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.10.0/23", "10.0.12.0/23", "10.0.14.0/23"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ec2_ssh_key" {
  type        = string
  description = "EC2 SSH key pair name that already exists"
  default     = "strinh"
}
