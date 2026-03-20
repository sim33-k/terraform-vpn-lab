# Elastic IP for WireGuard instance
resource "aws_eip" "wireguard" {
  instance = aws_instance.wireguard.id
  domain   = "vpc"

  tags = {
    Name = "wireguard-eip"
  }
}

# WireGuard Instance (Public Subnet)
resource "aws_instance" "wireguard" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_pair_name
  source_dest_check      = false
  vpc_security_group_ids = [var.wireguard_sg_id]

  user_data = file("${path.root}/scripts/wireguard.sh")

  tags = {
    Name = "wireguard-server"
  }
}

# Private Instance for testing (Private Subnet)
resource "aws_instance" "private" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.private_sg_id]

  tags = {
    Name = "private-server"
  }
}
