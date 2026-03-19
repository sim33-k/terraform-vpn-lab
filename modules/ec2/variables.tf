variable "ami_id" {
  description = "AMI ID to use for all instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the existing AWS key pair for SSH access"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "wireguard_sg_id" {
  description = "Security group ID for the WireGuard instance"
  type        = string
}

variable "private_sg_id" {
  description = "Security group ID for the private instance"
  type        = string
}