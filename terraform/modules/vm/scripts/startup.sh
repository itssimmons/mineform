#!/bin/bash
set -e

# Update the package index and install necessary packages
dnf update -y
dnf install -y java-17-openjdk git curl wget openssh-clients supervisor

# Create a directory for the Minecraft server
mkdir -p /opt/minecraft
cd /opt/minecraft

# Set up SSH keys for GitHub access
mkdir -p ~/.ssh
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
chmod +x /opt/minecraft/scripts/run.sh

# Download the Minecraft server JAR file
wget https://api.papermc.io/v2/projects/paper/versions/1.20.4/builds/500/downloads/paper-1.20.4-500.jar -O server.jar

# Setup Supervisor to manage the Minecraft server process
cp /opt/minecraft/supervisord.conf /etc/supervisord.conf

systemctl enable supervisord
systemctl start supervisord
