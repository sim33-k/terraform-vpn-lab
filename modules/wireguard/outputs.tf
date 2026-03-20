output "wireguard_public_ip" {
  description = "Elastic IP of the WireGuard server"
  value       = aws_eip.wireguard.public_ip
}

output "wireguard_instance_id" {
  description = "Instance ID of the WireGuard server"
  value       = aws_instance.wireguard.id
}

output "wireguard_primary_network_interface_id" {
  description = "Primary network interface ID of the WireGuard server"
  value       = aws_instance.wireguard.primary_network_interface_id
}

output "private_instance_id" {
  description = "Instance ID of the private server"
  value       = aws_instance.private.id
}

output "private_instance_ip" {
  description = "Private IP of the private server"
  value       = aws_instance.private.private_ip
}
