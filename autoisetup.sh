#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt-get update && sudo apt-get -y -o Dpkg::Options::="--force-confnew" upgrade

# Install wget, screen, and git without any prompts
sudo apt-get install -y wget screen git

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

# Clone the ceremonyclient repository if it does not exist
if [ -d "ceremonyclient" ]; then
    echo "The 'ceremonyclient' directory already exists, using the existing directory."
else
    git clone https://github.com/quilibriumnetwork/ceremonyclient || { echo "Failed to clone the repository. Exiting."; exit 1; }
fi

# Start the node in a screen session
screen -dmS quilibrium_node bash -c 'cd ceremonyclient/node; GOEXPERIMENT=arenas go run ./...; exec bash'

# Start the wallet in a second screen session
screen -dmS quilibrium_wallet bash -c 'cd ceremonyclient/node; GOEXPERIMENT=arenas go run ./... --db-console; exec bash'

# Check for the existence of the keys.yml file
if [ -f "ceremonyclient/node/.config/keys.yml" ]; then
    cat "ceremonyclient/node/.config/keys.yml"
else
    echo "keys.yml file not found."
fi
