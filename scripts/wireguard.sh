#!/bin/bash

# Exit immediately if any command fails
set -e

# ─────────────────────────────────────────
# 1. Update system and install WireGuard
# ─────────────────────────────────────────
yum update -y
yum install -y wireguard-tools iptables

# Enable IP forwarding (required for VPN routing)
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# ─────────────────────────────────────────
# 2. Generate server keys
# ─────────────────────────────────────────
mkdir -p /etc/wireguard
cd /etc/wireguard

# Generate private and public key pair
if [ ! -f server_private.key ] || [ ! -f server_public.key ]; then
  wg genkey | tee server_private.key | wg pubkey > server_public.key
fi

# Lock down permissions on private key
chmod 600 server_private.key

SERVER_PRIVATE_KEY=$(cat server_private.key)
PRIMARY_IFACE=$(ip route show default | awk '/default/ {print $5; exit}')

# ─────────────────────────────────────────
# 3. Write WireGuard server config
# ─────────────────────────────────────────
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 10.10.0.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY

# Masquerade traffic leaving through primary interface (NAT)
# This allows VPN clients to reach the private subnet
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $PRIMARY_IFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $PRIMARY_IFACE -j MASQUERADE

# ─────────────────────────────────────────
# Peer (your laptop/client) will be added
# manually after you generate client keys.
# See instructions below.
# ─────────────────────────────────────────
EOF

chmod 600 /etc/wireguard/wg0.conf

# ─────────────────────────────────────────
# 4. Start and enable WireGuard
# ─────────────────────────────────────────
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
