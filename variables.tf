variable "aws_region" {
  description = "AWS region to deploy into"
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

variable "instance_type" {
  description = "EC2 instance type for all instances"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the existing AWS EC2 key pair for SSH access (for example: mumbai, not mumbai.pem)"
  type        = string

  validation {
    condition     = !endswith(var.key_pair_name, ".pem")
    error_message = "key_pair_name must be the EC2 key pair name, not a local .pem file name."
  }
}

variable "your_ip" {
  description = "Your local machine IP in CIDR notation e.g. 203.94.83.86/32"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for all instances"
  type        = string
}

variable "vpn_client_cidr" {
  description = "CIDR used by WireGuard VPN clients"
  type        = string
  default     = "10.10.0.0/24"
}

variable "openvpn_client_cidr" {
  description = "CIDR used by OpenVPN VPN clients"
  type        = string
  default     = "10.20.0.0/24"
}