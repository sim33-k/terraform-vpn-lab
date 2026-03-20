variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "vpn_client_cidr" {
  description = "CIDR used by WireGuard VPN clients"
  type        = string
}

variable "your_ip" {
  description = "Your local machine IP in CIDR notation"
  type        = string
}