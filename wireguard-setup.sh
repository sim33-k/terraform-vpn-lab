#!/bin/bash

# Exit immediately if any command fails
set -e

# ─────────────────────────────────────────
# 1. Update system and install WireGuard
# ─────────────────────────────────────────
yum update -y
yum install -y wireguard-tools wireguard-dkms

# Enable IP forwarding (required for VPN routing)
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# ─────────────────────────────────────────
# 2. Generate server keys
# ─────────────────────────────────────────
mkdir -p /etc/wireguard
cd /etc/wireguard

# Generate private and public key pair
wg genkey | tee server_private.key | wg pubkey > server_public.key

# Lock down permissions on private key
chmod 600 server_private.key

SERVER_PRIVATE_KEY=$(cat server_private.key)

# ─────────────────────────────────────────
# 3. Write WireGuard server config
# ─────────────────────────────────────────
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 10.10.0.1/24
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY

# Masquerade traffic leaving through eth0 (NAT)
# This allows VPN clients to reach the private subnet
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

# ─────────────────────────────────────────
# Peer (your laptop/client) will be added
# manually after you generate client keys.
# See instructions below.
# ─────────────────────────────────────────
EOF

# ─────────────────────────────────────────
# 4. Start and enable WireGuard
# ─────────────────────────────────────────
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
```

---

## What each section does
```
1. Install       → installs wireguard-tools via yum (Amazon Linux 2)
2. IP Forwarding → allows the server to route packets between interfaces
                   without this, VPN traffic goes nowhere
3. Keys          → generates a unique server keypair on first boot
4. wg0.conf      → the WireGuard interface config
                   10.10.0.1/24 is the VPN tunnel network
                   completely separate from your VPC CIDRs
5. iptables      → NAT rules so VPN clients can reach the private subnet
6. Start         → enables wg-quick so it survives reboots
```

---

## Important — the VPN network vs your VPC network
```
Your VPC:        10.0.0.0/16
  Public subnet: 10.0.1.0/24  ← WireGuard server lives here
  Private subnet:10.0.2.0/24  ← Private server lives here

WireGuard tunnel:10.10.0.1/24 ← Separate virtual network
  Server gets:   10.10.0.1
  Your laptop gets: 10.10.0.2 (assigned when you configure the client)