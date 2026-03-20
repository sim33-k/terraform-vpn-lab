output "vpc_id" {
  value = aws_vpc.main.id
}

output "openvpn_sg_id" {
  value = aws_security_group.openvpn.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}

output "wireguard_sg_id" {
  value = aws_security_group.wireguard.id
}

output "private_sg_id" {
  value = aws_security_group.private.id
}