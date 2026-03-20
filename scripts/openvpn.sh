#!/bin/bash

# Exit immediately if any command fails
set -e

# ─────────────────────────────────────────
# 1. Update system and install OpenVPN
# ─────────────────────────────────────────
yum update -y
yum install -y openvpn iptables easy-rsa

# Enable IP forwarding (required for VPN routing)
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# ─────────────────────────────────────────
# 2. Initialize PKI (Public Key Infrastructure)
# ─────────────────────────────────────────
mkdir -p /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa

# Copy easy-rsa template if not already present
if [ ! -f vars ]; then
  cp -r /usr/share/easy-rsa/* .
fi

# ─────────────────────────────────────────
# 3. Set up OpenVPN Server (basic config)
# ─────────────────────────────────────────
PRIMARY_IFACE=$(ip route show default | awk '/default/ {print $5; exit}')

cat <<EOF > /etc/openvpn/server/server.conf
port 1194
proto udp
dev tun

# Note: Generate CA, certs, and keys before deploying
# ca /etc/openvpn/easy-rsa/pki/ca.crt
# cert /etc/openvpn/easy-rsa/pki/issued/server.crt
# key /etc/openvpn/easy-rsa/pki/private/server.key
# dh /etc/openvpn/easy-rsa/pki/dh.pem

server 10.20.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt

# Enable NAT for client traffic
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"

# Masquerade traffic
# PostUp configurations to be added after cert setup

keepalive 10 120
cipher AES-256-CBC
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF

chmod 600 /etc/openvpn/server/server.conf

# ─────────────────────────────────────────
# 4. Note: Generate certificates before starting
# ─────────────────────────────────────────
# See documentation for PKI setup with easy-rsa
# Then start and enable OpenVPN:
# systemctl enable openvpn-server@server
# systemctl start openvpn-server@server
