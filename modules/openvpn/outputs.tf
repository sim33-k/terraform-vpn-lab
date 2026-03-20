output "openvpn_public_ip" {
  description = "Elastic IP of the OpenVPN server"
  value       = aws_eip.openvpn.public_ip
}

output "openvpn_instance_id" {
  description = "Instance ID of the OpenVPN server"
  value       = aws_instance.openvpn.id
}

output "openvpn_primary_network_interface_id" {
  description = "Primary network interface ID of the OpenVPN server"
  value       = aws_instance.openvpn.primary_network_interface_id
}
