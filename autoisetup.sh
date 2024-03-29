#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt update && sudo apt -y upgrade

# Install wget, screen, and git without any prompts
sudo apt install -y wget golang git ufw

# Download Go
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

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

# Clone the repository
git clone https://github.com/quilibriumnetwork/ceremonyclient || { echo "Failed to clone the repository. Exiting."; exit 1; }

# Navigate to ceremonyclient/node directory
cd ceremonyclient/node || { echo "Failed to navigate to ceremonyclient/node directory. Exiting."; exit 1; }

# Create a screen session and run the command
screen -dmS ceremonyclient_node bash -c 'GOEXPERIMENT=arenas go run ./...'

# Exit the screen session
sleep 3
screen -S ceremonyclient_node -X stuff $'\003' # Sends CTRL+C to exit the command

# Run the command with --db-console
GOEXPERIMENT=arenas go run ./... --db-console

# Add a delay of 3 seconds and then exit the screen session
sleep 3
screen -S ceremonyclient_node -X stuff $'q'

# Check for the existence of the keys.yml file
keys_file="/root/ceremonyclient/node/config/keys.yml"
if [ -f "$keys_file" ]; then
    cat "$keys_file"
else
    echo "keys.yml file not found at $keys_file."
fi
