module "network" {
  source = "./modules/network"

  aws_region          = var.aws_region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  vpn_client_cidr     = var.vpn_client_cidr
  openvpn_client_cidr = var.openvpn_client_cidr
  your_ip             = var.your_ip
}

module "wireguard" {
  source = "./modules/wireguard"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  wireguard_sg_id   = module.network.wireguard_sg_id
  private_sg_id     = module.network.private_sg_id
}

resource "aws_route" "private_to_wireguard_clients" {
  route_table_id         = module.network.private_route_table_id
  destination_cidr_block = var.vpn_client_cidr
  network_interface_id   = module.wireguard.wireguard_primary_network_interface_id
}

module "openvpn" {
  source = "./modules/openvpn"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_pair_name    = var.key_pair_name
  public_subnet_id = module.network.public_subnet_id
  openvpn_sg_id    = module.network.openvpn_sg_id
}

resource "aws_route" "private_to_openvpn_clients" {
  route_table_id         = module.network.private_route_table_id
  destination_cidr_block = var.openvpn_client_cidr
  network_interface_id   = module.openvpn.openvpn_primary_network_interface_id
}