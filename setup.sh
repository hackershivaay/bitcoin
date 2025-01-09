#!/bin/bash

# This script will install Python, necessary dependencies, XMRig, and configure it.

# Update system and upgrade installed packages
echo "Updating system and upgrading packages..."
sudo apt update && sudo apt upgrade -y

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip

# Install build tools and dependencies for XMRig
echo "Installing build-essential, curl, and dependencies..."
sudo apt install -y build-essential curl libssl-dev libhwloc-dev

# Check Python installation
echo "Verifying Python installation..."
python3 --version
pip3 --version

# Download XMRig
echo "Downloading XMRig..."
curl -LO https://github.com/xmrig/xmrig/releases/download/v6.18.0/xmrig-6.18.0-linux-x64.tar.gz

# Extract XMRig
echo "Extracting XMRig..."
tar -xvzf xmrig-6.18.0-linux-x64.tar.gz
cd xmrig-6.18.0

# Set up basic XMRig config (you can edit this manually later)
echo "Setting up basic XMRig configuration..."
cat <<EOL > config.json
{   "cpu": true,
    "opencl": true,
    "pools": [
        {
            "url": "rx.unmineable.com:3333",  // Replace this with your preferred pool
            "user": "BTC:1J2knNSBQHk1FQzxK2yHnZNTf7Gfk8gsmT.BTC",  // Replace with your Monero wallet address
            "pass": "x"
        }
    ]
}
EOL

# Prompt user to manually edit the config if needed
echo "XMRig is set up with a basic pool and wallet address. You may want to manually edit config.json to adjust settings."

# Start XMRig (you can choose to start it manually later)
echo "Starting XMRig..."
./xmrig

# End of script
echo "Setup completed successfully!"
