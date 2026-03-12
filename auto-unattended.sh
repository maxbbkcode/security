#!/bin/bash
set -e

echo "Installing unattended-upgrades..."
apt update
apt install -y unattended-upgrades

FILE="/etc/apt/apt.conf.d/50unattended-upgrades"

echo "Commenting lines in $FILE ..."

sed -i 's|^[[:space:]]*"\${distro_id}:\${distro_codename}";|// "${distro_id}:${distro_codename}";|' "$FILE"
sed -i 's|^[[:space:]]*"\${distro_id}ESMApps:\${distro_codename}-apps-security";|// "${distro_id}ESMApps:${distro_codename}-apps-security";|' "$FILE"
sed -i 's|^[[:space:]]*"\${distro_id}ESM:\${distro_codename}-infra-security";|// "${distro_id}ESM:${distro_codename}-infra-security";|' "$FILE"

echo "Writing /etc/apt/apt.conf.d/20auto-upgrades ..."
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

echo
echo "Current /etc/apt/apt.conf.d/20auto-upgrades:"
cat /etc/apt/apt.conf.d/20auto-upgrades

echo
echo "unattended-upgrades status:"
systemctl status unattended-upgrades --no-pager || true

echo
echo "Done."
