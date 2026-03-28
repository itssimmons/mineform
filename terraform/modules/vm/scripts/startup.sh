#!/bin/bash
set -e

# Load needed environment variables from the Secret Manager
export SSH_PRIVATE_KEY=$(gcloud secrets versions access latest --secret="SSH_PRIVATE_KEY")

# Update the package index and install necessary packages
dnf update -y
dnf install -y java-17-openjdk git curl wget openssh-clients supervisor

# Create a directory for the Minecraft server
mkdir -p /opt/minecraft
cd /opt/minecraft

# Set up SSH keys for GitHub access
mkdir -p ~/.ssh
echo <<EOF
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github_key
EOF > ~/.ssh/config

echo "${SSH_PRIVATE_KEY}" > ~/.ssh/github_key
chmod 700 ~/.ssh
chmod 600 ~/.ssh/github_key
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone the Minecraft server repository
git clone --depth 1 --filter=blob:none --sparse git@github.com:itssimmons/mineform.git .
git sparse-checkout set server

# Create user and group for running the Minecraft server
groupadd -r minecraft
useradd -r -g minecraft -d /opt/minecraft -s /bin/bash minecraft
chown -R minecraft:minecraft /opt/minecraft
chmod +x /opt/minecraft/run.sh

# Setup Supervisor to manage the Minecraft server process
cp /opt/minecraft/supervisord.conf /etc/supervisord.conf

systemctl enable supervisord
systemctl start supervisord
