#!/bin/bash

# Set DEBIAN_FRONTEND to noninteractive to avoid any prompts
export DEBIAN_FRONTEND=noninteractive

# Update and Upgrade Ubuntu Packages without any prompts
sudo apt-get update && sudo apt-get -y upgrade

# Install wget, screen, and git without any prompts
sudo apt-get install -y wget screen git

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
screen -dmS quilibrium
screen -S quilibrium -X stuff $'cd ceremonyclient/node\n'
screen -S quilibrium -X stuff $'GOEXPERIMENT=arenas go run ./...\n'
sleep 10 # Adjust this sleep time as necessary
screen -S quilibrium -X stuff $'\003' # Send Ctrl+C to stop the command
screen -S quilibrium -X stuff $'exit\n'

# Starting second screen session, running commands, and then exiting
screen -dmS quilibrium_wallet
screen -S quilibrium_wallet -X stuff $'cd ceremonyclient/node\n'
screen -S quilibrium_wallet -X stuff $'GOEXPERIMENT=arenas go run ./... --db-console\n'
sleep 10 # Adjust this sleep time as necessary
screen -S quilibrium_wallet -X stuff $'\003' # Send Ctrl+C to stop the command
screen -S quilibrium_wallet -X stuff $'exit\n'

# Wait for the .config/keys.yml file to be created
sleep 30 # Adjust this sleep time as necessary

# Output keys.yml content
if [ -f ceremonyclient/node/.config/keys.yml ]; then
    cat ceremonyclient/node/.config/keys.yml
else
    echo "keys.yml file not found."
fi
