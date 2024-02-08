#!/bin/bash

# Update and Upgrade Ubuntu Packages
sudo apt update && sudo apt upgrade -y

# Install wget
sudo apt install wget -y

# Download Go
wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz

# Extract Go and Install Golang
sudo tar -xvf go1.20.2.linux-amd64.tar.gz
sudo apt install golang -y

# Move Go to /usr/local
sudo mv go /usr/local

# Setting up environment variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/Projects/Proj1
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Update .profile file
echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
echo 'export GOPATH=$HOME/Projects/Proj1' >> $HOME/.profile
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.profile

# Clone the ceremonyclient repository
git clone https://github.com/quilibriumnetwork/ceremonyclient

# Starting screen sessions and running commands
screen -dmS quilibrium bash -c 'cd ceremonyclient/node && GOEXPERIMENT=arenas go run ./...; exec bash'
screen -dmS quilibrium_wallet bash -c 'cd ceremonyclient/node && GOEXPERIMENT=arenas go run ./... --db-console; exec bash'

# Output keys.yml content (after a delay to allow previous commands to complete)
sleep 10
cat ceremonyclient/node/.config/keys.yml
