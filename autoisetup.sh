#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt-get update && sudo apt-get -y upgrade

# Install wget and screen without any prompts
sudo apt-get install -y wget screen

# Download Go
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

# Extract Go
sudo tar -xvf go1.20.2.linux-amd64.tar.gz

# Move Go to /usr/local
sudo mv go /usr/local

# Install Golang without any prompts
sudo apt-get install -y golang

# Setting up environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update .profile file
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/Projects/Proj1' >> $HOME/.profile
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.profile

# Clone the ceremonyclient repository
if git clone https://github.com/quilibriumnetwork/ceremonyclient; then
    echo "Repository cloned successfully."
else
    echo "Failed to clone the repository. Exiting."
    exit 1
fi

# Starting first screen session, running commands, and then exiting
screen -dmS quilibrium bash -c '
    cd ceremonyclient/node
    GOEXPERIMENT=arenas go run ./...
    exec bash'
sleep 5 # Wait for the command to start
screen -S quilibrium -X stuff $'exit\n'

# Starting second screen session, running commands, and then exiting
screen -dmS quilibrium_wallet bash -c '
    cd ceremonyclient/node
    GOEXPERIMENT=arenas go run ./... --db-console
    exec bash'
sleep 5 # Wait for the command to start
screen -S quilibrium_wallet -X stuff $'exit\n'

# Output keys.yml content (after a delay to allow previous commands to complete)
sleep 10
cat ceremonyclient/node/.config/keys.yml
