#!/bin/bash

# Ensure the unattended-upgrades package is installed
sudo apt-get install unattended-upgrades -y

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Enable all automatic updates (optional, if you want all types of updates to be automatic)
# sudo dpkg-reconfigure --priority=low unattended-upgrades

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt-get update
sudo apt-get upgrade -yq
sudo apt-get dist-upgrade -yq

# Install wget, screen, and git without any prompts
sudo apt-get install wget screen git -y

# Download Go
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

# Extract Go and move to /usr/local
sudo tar -xvf go1.20.2.linux-amd64.tar.gz
sudo mv go /usr/local

# Install Golang without any prompts
sudo apt-get install golang -y

# Setting up environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update .profile file
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/Projects/Proj1' >> $HOME/.profile
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.profile

# Clone the ceremonyclient repository if it does not exist
if [ ! -d "ceremonyclient" ]; then
    git clone https://github.com/quilibriumnetwork/ceremonyclient
else
    echo "The 'ceremonyclient' directory already exists, skipping cloning."
fi

# Starting screen sessions and running commands
screen -dmS quilibrium
sleep 1
screen -S quilibrium -X stuff 'cd ceremonyclient/node\n'
sleep 1
screen -S quilibrium -X stuff 'GOEXPERIMENT=arenas go run ./...\n'
sleep 5
screen -S quilibrium -X stuff $'\003'
sleep 1
screen -S quilibrium -X stuff 'exit\n'
sleep 1

screen -dmS quilibrium_wallet
sleep 1
screen -S quilibrium_wallet -X stuff 'cd ceremonyclient/node\n'
sleep 1
screen -S quilibrium_wallet -X stuff 'GOEXPERIMENT=arenas go run ./... --db-console\n'
sleep 5
screen -S quilibrium_wallet -X stuff $'\003'
sleep 1
screen -S quilibrium_wallet -X stuff 'exit\n'
sleep 1

# Check for the existence of the keys.yml file
if [ -f "ceremonyclient/node/.config/keys.yml" ]; then
    cat "ceremonyclient/node/.config/keys.yml"
else
    echo "keys.yml file not found."
fi
