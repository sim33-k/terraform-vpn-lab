variable "ami_id" {
  description = "AMI ID to use for the instance"
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

variable "openvpn_sg_id" {
  description = "Security group ID for the OpenVPN instance"
  type        = string
}
