#!/bin/bash

# Minimal install - just the essentials
sudo yum update -y
sudo yum install -y git docker curl

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Install Docker Compose (only thing not in yum)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Done! Logout and login again, then test with: docker-compose --version"
