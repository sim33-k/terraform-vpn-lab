output "wireguard_public_ip" {
  description = "Public IP to SSH into the WireGuard server"
  value       = module.wireguard.wireguard_public_ip
}

output "private_instance_ip" {
  description = "Private IP of the private server"
  value       = module.wireguard.private_instance_ip
}

# output "openvpn_public_ip" {
#   description = "Public IP to SSH into the OpenVPN server"
#   value       = module.openvpn.openvpn_public_ip
# }