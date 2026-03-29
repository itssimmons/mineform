#!/bin/bash
set -e

# Load needed environment variables from the Secret Manager
export SSH_PRIVATE_KEY=$(gcloud secrets versions access latest --secret="SSH_PRIVATE_KEY")

/usr/bin/dpkg --configure --pending

# Update package index and upgrade system
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
  git \
  curl \
  wget \
  openssh-client \
  openjdk-17-jre-headless \
  supervisor

# Create a directory for the Minecraft server
mkdir -p /opt/minecraft
cd /opt/minecraft

# Set up SSH keys for GitHub access
mkdir -p ~/.ssh

cat <<EOF > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github_key
EOF

echo "${SSH_PRIVATE_KEY}" > ~/.ssh/github_key
chmod 700 ~/.ssh
chmod 600 ~/.ssh/github_key
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone the Minecraft server repository
git clone --depth 1 --filter=blob:none --sparse git@github.com:itssimmons/mineform.git .
git config --global --add safe.directory /opt/minecraft
git sparse-checkout set server
cd server

# Create user and group for running the Minecraft server
groupadd -r minecraft
useradd -r -g minecraft -d /opt/minecraft -s /bin/bash minecraft
chown -R minecraft:minecraft /opt/minecraft
chmod +x /opt/minecraft/server/run.sh

# Setup Supervisor to manage the Minecraft server process
mkdir -p /etc/supervisor
mkdir -p /var/log/supervisor/conf.d
cp /opt/minecraft/server/ci/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enable and start supervisor
systemctl enable supervisor
systemctl start supervisor
