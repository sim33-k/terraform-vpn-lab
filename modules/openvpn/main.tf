# Elastic IP for OpenVPN instance
resource "aws_eip" "openvpn" {
  instance = aws_instance.openvpn.id
  domain   = "vpc"

  tags = {
    Name = "openvpn-eip"
  }
}

# OpenVPN Instance (Public Subnet)
resource "aws_instance" "openvpn" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  key_name               = var.key_pair_name
  vpc_security_group_ids = [var.openvpn_sg_id]

  user_data = file("${path.root}/scripts/openvpn.sh")

  tags = {
    Name = "openvpn-server"
  }
}
