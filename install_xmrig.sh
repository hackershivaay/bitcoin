#!/bin/bash

# Clone the repository
git clone https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz

# Upgrade system packages
sudo apt update && sudo apt upgrade -y

# Change to xmrig directory and prepare build
cd xmrig
mkdir build
cd build

# Run xmrig
./xmrig
