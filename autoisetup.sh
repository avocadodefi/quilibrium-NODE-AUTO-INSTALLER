#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt-get update && sudo apt-get -y -o Dpkg::Options::="--force-confnew" upgrade

# Install wget, screen, and git without any prompts
sudo apt-get install -y wget screen git

# Download Go
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

# Check if /usr/local/go already exists
if [ -d "/usr/local/go" ]; then
    echo "/usr/local/go already exists. Removing existing directory."
    sudo rm -rf /usr/local/go
fi

# Extract Go and move to /usr/local
sudo tar -xvf go1.20.2.linux-amd64.tar.gz
sudo mv go /usr/local

# Setting up environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update .profile file
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/Projects/Proj1' >> $HOME/.profile
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.profile

# Check if the ceremonyclient directory exists and is a Git repository
if [ -d "ceremonyclient" ]; then
    if [ -d "ceremonyclient/.git" ]; then
        echo "The 'ceremonyclient' directory already exists and is a Git repository. Pulling the latest changes."
        cd ceremonyclient
        git pull
        cd ..
    else
        echo "The 'ceremonyclient' directory already exists but is not a Git repository. Removing and cloning anew."
        rm -rf ceremonyclient
        git clone https://github.com/quilibriumnetwork/ceremonyclient
    fi
else
    git clone https://github.com/quilibriumnetwork/ceremonyclient || { echo "Failed to clone the repository. Exiting."; exit 1; }
fi

# Wait for a while to allow initialization
sleep 30  # Increased from 10 to 30 seconds

# Check for the existence of the keys.yml file
keys_file="/root/ceremonyclient/node/config/keys.yml"
if [ -f "$keys_file" ]; then
    cat "$keys_file"
else
    echo "keys.yml file not found at $keys_file."
fi
