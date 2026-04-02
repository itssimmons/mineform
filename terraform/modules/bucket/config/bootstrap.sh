#!/bin/bash
set -e

start_time=$(date +%s)

# Download /data/world from bucket if it exists
if gcloud storage ls gs://mineform-data/data/world/** >/dev/null 2>&1; then
	mkdir -p /data
  gcloud storage cp -r gs://mineform-data/data/world /data/
fi

# Update package index and upgrade system  
apt-get update -y
apt-get install -y --no-install-recommends \
  git openssh-client \
  openjdk-17-jre-headless \
  git-lfs screen

# Create a directory for the Minecraft server
mkdir -p /opt/minecraft

# Setup Mincraft server user and permissions
getent group minecraft >/dev/null || \
	groupadd -r minecraft
id -u minecraft >/dev/null 2>&1 || \
	useradd -r -g minecraft -d /opt/minecraft -s /bin/bash minecraft

# Set up SSH keys for GitHub and Mincraft user access
mkdir -p ~/.ssh
chmod 700 ~/.ssh

cat <<EOF > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github_key
EOF

grep -q "Match User minecraft" /etc/ssh/sshd_config || \
cat <<EOF >> /etc/ssh/sshd_config

Match User minecraft
	ForceCommand bash -c 'cd /opt/minecraft/server && exec screen -xRR minecraft'
  PermitTTY yes
  AllowTcpForwarding no
  X11Forwarding no
  PasswordAuthentication no
  PubkeyAuthentication yes
EOF

mkdir -p /home/minecraft/.ssh
touch ~/.ssh/known_hosts
touch /home/minecraft/.ssh/authorized_keys

chmod 700 ~/.ssh
chmod 600 ~/.ssh/known_hosts
chmod 700 /home/minecraft/.ssh
chmod 600 /home/minecraft/.ssh/authorized_keys

echo "$(gcloud secrets versions access latest --secret="SESSION_PUBLIC_KEY")" >> /home/minecraft/.ssh/authorized_keys

echo "$(gcloud secrets versions access latest --secret="GITHUB_PRIVATE_KEY")" > ~/.ssh/github_key
chmod 600 ~/.ssh/github_key
ssh-keygen -F github.com >/dev/null || ssh-keyscan -T 5 github.com >> ~/.ssh/known_hosts

chown -R minecraft:minecraft /home/minecraft

# Clone the Minecraft server repository
if [[ ! -d "/opt/minecraft/.git" ]]; then
	cd /opt/minecraft
	git clone --depth 1 --filter=blob:none --sparse git@github.com:itssimmons/mineform.git .
	git config --global --add safe.directory /opt/minecraft
	git sparse-checkout set server
	git lfs install
	git lfs pull -I "server/*"
fi

if [[ -d "/data/world" ]]; then
	rm -rf /opt/minecraft/server/world
	mv /data/world /opt/minecraft/server/
fi

chown -R minecraft:minecraft /opt/minecraft/
chmod +x /opt/minecraft/server/run.sh

# Test SSH configuration and restart SSH service
sshd -t
systemctl restart ssh

# Clean up
apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*

end_time=$(date +%s)
elapsed_time=$((${end_time} - ${start_time}))

echo "Done in ${elapsed_time}s ✨"
echo "Starting Minecraft server..."

# Logging setup
mkdir -p /var/log
touch /var/log/minecraft.log
chown minecraft:minecraft /var/log/minecraft.log
chmod 600 /var/log/minecraft.log

# Start server with Screen
su - minecraft -c \
	"cd /opt/minecraft/server && screen -L -Logfile /var/log/minecraft.log -dmS minecraft ./run.sh"
