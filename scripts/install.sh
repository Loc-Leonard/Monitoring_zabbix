#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git jq python3-pip

if dpkg -l | grep -q '^ii  containerd '; then
  sudo apt remove -y containerd
fi

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER" || true

echo "Done. Re-login or run: newgrp docker"