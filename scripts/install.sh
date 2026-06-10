#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release git docker.io docker-compose-plugin jq python3-pip
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER" || true