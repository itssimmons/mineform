#!/bin/bash
set -e

# Download needed files from Bucket
gcloud storage cp gs://mineform-data/minecraftd.conf /etc/supervisor/conf.d/minecraftd.conf
gcloud storage cp gs://mineform-data/minecraft-rcon-shell /usr/local/bin/minecraft-rcon-shell

# Update package index and upgrade system
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
  git \
  make \
  curl \
  wget \
  openssh-client \
  openjdk-17-jre-headless \
  supervisor \
  build-essential

# Create a directory for the Minecraft server
mkdir -p /opt/minecraft

# Load secrets from Secret Manager and set up SSH keys
export GITHUB_PRIVATE_KEY=$(gcloud secrets versions access latest --secret="GITHUB_PRIVATE_KEY")
export SESSION_PUBLIC_KEY=$(gcloud secrets versions access latest --secret="SESSION_PUBLIC_KEY")

# Set up SSH keys for GitHub and Mincraft user access
mkdir -p ~/.ssh

cat <<EOF > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github_key
EOF

cat <<EOF > ~/.ssh/sshd_config
Port 22
PermitRootLogin yes
PasswordAuthentication no
PubkeyAuthentication yes
AuthenticationMethods publickey

Match User minecraft
  ForceCommand /usr/local/bin/minecraft-rcon-shell
  PermitTTY yes
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
  ChallengeResponseAuthentication no
  PubkeyAuthentication yes
EOF

mkdir -p ~/.ssh
mkdir -p /home/minecraft/.ssh
touch ~/.ssh/known_hosts
touch /home/minecraft/.ssh/authorized_keys

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts
chmod 600 /home/minecraft/.ssh/authorized_keys

echo "${GITHUB_PRIVATE_KEY}" > ~/.ssh/github_key
chmod 600 ~/.ssh/github_key
ssh-keyscan github.com >> ~/.ssh/known_hosts

echo "${SESSION_PUBLIC_KEY}" > /home/minecraft/.ssh/minecraft_key

chmod 600 /home/minecraft/.ssh/minecraft_key
echo "${SESSION_PUBLIC_KEY}" >> /home/minecraft/.ssh/authorized_keys

sshd -t
systemctl restart sshd

# Clone the Minecraft server repository
cd /opt/minecraft
git clone --depth 1 --filter=blob:none --sparse git@github.com:itssimmons/mineform.git .
git config --global --add safe.directory /opt/minecraft
git sparse-checkout set server

# Setup Mincraft server user and permissions
groupadd -r minecraft
useradd -r -g minecraft -d /opt/minecraft

chown -R minecraft:minecraft /opt/minecraft
chmod +x /opt/minecraft/server/run.sh

# Install mcrcon for RCON access (optional, but useful for server management)
git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon
cd /tmp/mcrcon
make
make install
mcrcon -h
rm -rf /tmp/mcrcon

chmod +x /usr/local/bin/minecraft-rcon-shell
chown minecraft:minecraft /usr/local/bin/minecraft-rcon-shell

# Enable and start supervisor
systemctl enable supervisor
systemctl start supervisor
