output "wireguard_public_ip" {
  description = "Public IP to SSH into the WireGuard server"
  value       = module.ec2.wireguard_public_ip
}

output "private_instance_ip" {
  description = "Private IP of the private server"
  value       = module.ec2.private_instance_ip
}